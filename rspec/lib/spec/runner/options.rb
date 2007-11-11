module Spec
  module Runner
    class Options
      FILE_SORTERS = {
        'mtime' => lambda {|file_a, file_b| File.mtime(file_b) <=> File.mtime(file_a)}
      }

      BUILT_IN_FORMATTERS = {
        'specdoc'  => Formatter::SpecdocFormatter,
        's'        => Formatter::SpecdocFormatter,
        'html'     => Formatter::HtmlFormatter,
        'h'        => Formatter::HtmlFormatter,
        'rdoc'     => Formatter::RdocFormatter,
        'r'        => Formatter::RdocFormatter,
        'progress' => Formatter::ProgressBarFormatter,
        'p'        => Formatter::ProgressBarFormatter,
        'failing_examples' => Formatter::FailingExamplesFormatter,
        'e'        => Formatter::FailingExamplesFormatter,
        'failing_behaviours' => Formatter::FailingBehavioursFormatter,
        'b'        => Formatter::FailingBehavioursFormatter,
        'profile'  => Formatter::ProfileFormatter,
        'o'        => Formatter::ProfileFormatter,
        'textmate' => Formatter::TextMateFormatter,
      }

      attr_accessor(
        :backtrace_tweaker,
        :context_lines,
        :diff_format,
        :dry_run,
        :profile,
        :examples,
        :failure_file,
        :formatters,
        :heckle_runner,
        :line_number,
        :loadby,
        :reporter,
        :reverse,
        :timeout,
        :verbose,
        :user_input_for_runner,
        :error_stream,
        :output_stream,
        # TODO: BT - Figure out a better name
        :current_argv
      )
      attr_reader :colour, :differ_class, :files, :example_groups

      def initialize(error_stream, output_stream)
        @error_stream = error_stream
        @output_stream = output_stream
        @backtrace_tweaker = QuietBacktraceTweaker.new
        @examples = []
        @formatters = []
        @colour = false
        @profile = false
        @dry_run = false
        @reporter = Reporter.new(self)
        @context_lines = 3
        @diff_format  = :unified
        @files = []
        @example_groups = []
        @user_input_for_runner = nil
        @examples_run = false
      end

      def add_example_group(behaviour)
        @example_groups << behaviour
      end

      def run_examples
        return true unless examples_should_be_run?
        runner = custom_runner || BehaviourRunner.new(self)

        runner.load_files(files_to_load)
        if example_groups.empty?
          true
        else
          success = runner.run
          @examples_run = true
          heckle if heckle_runner
          success
        end
      end

      def examples_should_be_run?
        return @examples_should_be_run unless @examples_should_be_run.nil?
        @examples_should_be_run = true
      end
      attr_writer :examples_should_be_run

      def examples_run?
        @examples_run
      end

      def colour=(colour)
        @colour = colour
        begin; \
          require 'Win32/Console/ANSI' if @colour && PLATFORM =~ /win32/; \
        rescue LoadError ; \
          raise "You must gem install win32console to use colour on Windows" ; \
        end
      end

      def custom_runner?
        return user_input_for_runner ? true : false
      end

      def custom_runner
        return nil unless custom_runner?
        klass_name, arg = split_at_colon(user_input_for_runner)
        runner_type = load_class(klass_name, 'behaviour runner', '--runner')
        return runner_type.new(self, arg)
      end

      def differ_class=(klass)
        return unless klass
        @differ_class = klass
        Spec::Expectations.differ = self.differ_class.new(self)
      end

      def parse_diff(format)
        case format
        when :context, 'context', 'c'
          @diff_format  = :context
          default_differ
        when :unified, 'unified', 'u', '', nil
          @diff_format  = :unified
          default_differ
        else
          @diff_format  = :custom
          self.differ_class = load_class(format, 'differ', '--diff')
        end
      end

      def parse_example(example)
        if(File.file?(example))
          @examples = File.open(example).read.split("\n")
        else
          @examples = [example]
        end
      end

      def parse_format(format_arg)
        format, where = split_at_colon(format_arg)
        # This funky regexp checks whether we have a FILE_NAME or not
        unless where
          raise "When using several --format options only one of them can be without a file" if @out_used
          where = @output_stream
          @out_used = true
        end

        formatter_type = BUILT_IN_FORMATTERS[format] || load_class(format, 'formatter', '--format')
        create_formatter(formatter_type, where)
      end

      def create_formatter(formatter_type, where=@output_stream)
        formatter = formatter_type.new(self, where)
        @formatters << formatter
        formatter
      end

      def parse_require(req)
        req.split(",").each{|file| require file}
      end

      def parse_heckle(heckle)
        heckle_require = [/mswin/, /java/].detect{|p| p =~ RUBY_PLATFORM} ? 'spec/runner/heckle_runner_unsupported' : 'spec/runner/heckle_runner'
        require heckle_require
        @heckle_runner = HeckleRunner.new(heckle)
      end

      def split_at_colon(s)
        if s =~ /([a-zA-Z_]+(?:::[a-zA-Z_]+)*):?(.*)/
          arg = $2 == "" ? nil : $2
          [$1, arg]
        else
          raise "Couldn't parse #{s.inspect}"
        end
      end

      def load_class(name, kind, option)
        if name =~ /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/
          arg = $2 == "" ? nil : $2
          [$1, arg]
        else
          m = "#{name.inspect} is not a valid class name"
          @error_stream.puts m
          raise m
        end
        begin
          eval(name, binding, __FILE__, __LINE__)
        rescue NameError => e
          @error_stream.puts "Couldn't find #{kind} class #{name}"
          @error_stream.puts "Make sure the --require option is specified *before* #{option}"
          if $_spec_spec ; raise e ; else exit(1) ; end
        end
      end

      def files_to_load
        result = []
        sorted_files.each do |file|
          if test ?d, file
            result += Dir[File.expand_path("#{file}/**/*.rb")]
          elsif test ?f, file
            result << file
          else
            raise "File or directory not found: #{file}"
          end
        end
        result
      end

      def number_of_examples
        @example_groups.inject(0) {|sum, behaviour| sum + behaviour.number_of_examples}
      end

      protected
      def heckle
        returns = self.heckle_runner.heckle_with
        self.heckle_runner = nil
        returns
      end
      
      def sorted_files
        return sorter ? files.sort(&sorter) : files
      end

      def sorter
        FILE_SORTERS[loadby]
      end

      def default_differ
        require 'spec/expectations/differs/default'
        self.differ_class = Spec::Expectations::Differs::Default
      end
    end
  end
end
