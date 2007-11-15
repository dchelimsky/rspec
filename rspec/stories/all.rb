$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'spec'
require 'rbconfig'
require 'tempfile'

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

steps_for :rspec_and_test_unit  do

  Given("the test file $relative_path") do |relative_path|
    @path = File.join(File.dirname(__FILE__), relative_path)
  end
  When("I run it with the $interpreter") do |interpreter|
    stderr_file = Tempfile.new('rspec')
    stderr_file.close
    @stdout = case(interpreter)
      when 'ruby interpreter' then ruby(@path, stderr_file.path)
      when 'spec script' then spec(@path, stderr_file.path)
      else raise "Unknown interpreter: #{interpreter}"
    end
    @stderr = IO.read(stderr_file.path)
    @exit_code = $?.to_i
  end
  Then("the exit code should be $exit_code") do |exit_code|
    if @exit_code != exit_code.to_i
      raise "Did not exit with #{exit_code}, but with #{@exit_code}. Standard error:\n#{stderr}"
    end
  end
  Then("the $stream should contain \"$line\"") do |stream, line|
    written = case(stream)
      when 'stdout' then @stdout
      when 'stderr' then @stderr
      else raise "Unknown stream: #{stream}"
    end
    
    written.should =~ /#{line}/m
  end
end

with_steps_for :rspec_and_test_unit do
  Dir["#{File.dirname(__FILE__)}/**"].each do |file|
    run file if File.file?(file) && !(file =~ /\.rb$/)
  end
end