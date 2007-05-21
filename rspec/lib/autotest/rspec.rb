require 'autotest'

class Autotest::Rspec < Autotest

  def initialize # :nodoc:
    super
    @spec_command = "spec "
    @test_mappings = {
      %r%^spec/.*rb$% => proc { |filename, _|
        filename
      },
      %r%^lib/(.*)\.rb$% => proc { |_, m|
        ["spec/#{m[1]}_spec.rb"]
      },
    }
  end
  
  def tests_for_file(filename)
    super.select { |f| @files.has_key? f }
  end

  def handle_results(results)
    failed = results.scan(/^\d+\)\n(?:\e\[\d*m)?(?:.*?Error in )?'([^\n]*)'(?: FAILED)?(?:\e\[\d*m)?\n(.*?)\n\n/m)
    @files_to_test = consolidate_failures failed
    unless @files_to_test.empty? then
      hook :red
    else
      hook :green
    end unless $TESTING
    @tainted = true unless @files_to_test.empty?
  end

  def consolidate_failures(failed)
    filters = Hash.new { |h,k| h[k] = [] }
    failed.each do |spec, failed_trace|
      @files.keys.select{|f| f =~ /spec\//}.each do |f|
        if failed_trace =~ Regexp.new(f)
          filters[f] << spec
          break
        end
      end
    end
    return filters
  end

  def make_test_command(files_to_test)
    "script/spec -O spec/spec.opts"
  end

  # def make_test_cmd(files_to_test)
  #   ""
  #   cmds = []
  #   full, partial = files_to_test.partition { |k,v| v.empty? }
  # 
  #   unless full.empty? then
  #     classes = full.map {|k,v| k}.flatten.join(' ')
  #     cmds << "#{@spec_command} #{classes}"
  #   end
  # 
  #   partial.each do |klass, methods|
  #     cmds.push(*methods.map { |meth|
  #       "#{@spec_command} -e #{meth.inspect} #{klass}"
  #     })
  #   end
  # 
  #   return cmds.join('; ')
  # end
end
