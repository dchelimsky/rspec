module RCov
  class TestTask < Rake::TestTask
    def define
      lib_path = @libs.join(File::PATH_SEPARATOR)
      desc "Run tests with rcov"
      task 'test_with_rcov' do
        run_code = ''
        RakeFileUtils.verbose(@verbose) do
          run_code =
            case @loader
            when :direct
              "-e 'ARGV.each{|f| load f}'"
            when :testrb
              "-S testrb #{fix}"
            when :rake
              rake_loader
            end
          @ruby_opts.unshift( "-I#{lib_path}" )
          @ruby_opts.unshift( "--exclude test.*.rb")
          @ruby_opts.unshift( "-w" ) if @warning
          rcov @ruby_opts.join(" ") +
            " \"#{run_code}\" " +
            file_list.collect { |fn| "\"#{fn}\"" }.join(' ') +
            " #{option_list}"
        end
      end
    self
    end
  end
end

module FileUtils
  def rcov(*args,&block)
    if Hash === args.last
      options = args.pop
    else
      options = {}
    end
    if args.length > 1 then
      sh(*(['rcov'] + args + [options]), &block)
    else
      sh("rcov #{args}", options, &block)
    end
  end
end