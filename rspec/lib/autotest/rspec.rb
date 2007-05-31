require 'autotest'

class Autotest::Rspec < Autotest

  def initialize # :nodoc:
    super
    @spec_command = "spec"
    @test_mappings = {
      %r%^spec/.*\.rb$% => proc { |filename, _|
        filename
      },
      %r%^lib/(.*)\.rb$% => proc { |_, m|
        ["spec/#{m[1]}_spec.rb"]
      },
      %r%^spec/(spec_helper|shared/.*)\.rb$% => proc {
        files_matching %r%^spec/.*_spec\.rb$%
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

  def make_test_cmd(files_to_test)
    cmds = []
    full, partial = files_to_test.partition { |k,v| v.empty? }
  
    unless full.empty? then
      files = full.map {|k,v| k}.flatten.join(' ')
      cmds << "#{@spec_command} #{add_options_if_present}#{files}"
    end
  
    partial.each do |f, methods|
      cmds.push(*methods.map { |meth|
        "#{@spec_command} #{add_options_if_present} #{f}"
      })
    end
  
    return cmds.join('; ')
  end
  
  def add_options_if_present
    File.exist?("spec/spec.opts") ? "-O spec/spec.opts " : ""
  end

end
