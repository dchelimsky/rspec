$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'spec'
require 'rbconfig'
require 'tempfile'
require File.dirname(__FILE__) + '/smart_match'

module StoryHelper
  def ruby(args, stderr)
    config       = ::Config::CONFIG
    interpreter  = File::join(config['bindir'], config['ruby_install_name']) + config['EXEEXT']
    cmd = "#{interpreter} #{args} 2> #{stderr}"
    #puts "\nCOMMAND: #{cmd}"
    `#{cmd}`
  end

  def spec(args, stderr)
    ruby("#{File.dirname(__FILE__) + '/../bin/spec'} #{args}", stderr)
  end

  def cmdline(args, stderr)
    ruby("#{File.dirname(__FILE__) + '/cmdline.rb'} #{args}", stderr)
  end
  
  Spec::Story::World.send :include, self
end


steps_for :rspec_and_test_unit do

  Given("the file $relative_path") do |relative_path|
    @path = File.join(File.dirname(__FILE__), relative_path)
  end
  When("I run it with the $interpreter") do |interpreter|
    stderr_file = Tempfile.new('rspec')
    stderr_file.close
    @stdout = case(interpreter)
      when 'ruby interpreter' then ruby(@path, stderr_file.path)
      when 'spec script' then spec(@path, stderr_file.path)
      when 'CommandLine object' then cmdline(@path, stderr_file.path)
      else raise "Unknown interpreter: #{interpreter}"
    end
    @stderr = IO.read(stderr_file.path)
    @exit_code = $?.to_i
  end
  Then("the exit code should be $exit_code") do |exit_code|
    if @exit_code != exit_code.to_i
      raise "Did not exit with #{exit_code}, but with #{@exit_code}. Standard error:\n#{@stderr}"
    end
  end
  Then("the $stream should match $regex") do |stream, string_or_regex|
    written = case(stream)
      when 'stdout' then @stdout
      when 'stderr' then @stderr
      else raise "Unknown stream: #{stream}"
    end
    written.should smart_match(string_or_regex)
  end
  Then("the $stream should not match $regex") do |stream, string_or_regex|
    written = case(stream)
      when 'stdout' then @stdout
      when 'stderr' then @stderr
      else raise "Unknown stream: #{stream}"
    end
    written.should_not smart_match(string_or_regex)
  end
end

with_steps_for :rspec_and_test_unit do
  Dir["#{File.dirname(__FILE__)}/**"].each do |file|
    run file if File.file?(file) && !(file =~ /\.rb$/)
  end
end