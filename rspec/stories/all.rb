$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'spec'
require 'rbconfig'
require 'tempfile'

def ruby(args, stderr)
  config       = ::Config::CONFIG
  interpreter  = File::join(config['bindir'], config['ruby_install_name']) + config['EXEEXT']
  `#{interpreter} #{args} 2> #{stderr}`
end

steps_for :rspec_and_test_unit  do

  Given("the test file $relative_path") do |relative_path|
    @path = File.join(File.dirname(__FILE__), relative_path)
  end
  When("I run it with the $interpreter") do |interpreter|
    @stderr = Tempfile.new('rspec')
    @stderr.close
    @output = ruby(@path, @stderr.path)
    @exit_code = $?.to_i
  end
  Then("the exit code should be $exit_code") do |exit_code|
    if @exit_code != exit_code.to_i
      stderr = IO.read(@stderr.path)
      raise "Did not exit with #{exit_code}, but with #{@exit_code}. Standard error:\n#{stderr}"
    end
  end
  Then("the output should contain \"$line\"") do |line|
    @output.should =~ /#{line}/m
  end
end

with_steps_for :rspec_and_test_unit do
  Dir["#{File.dirname(__FILE__)}/**"].each do |file|
    run file if File.file?(file) && !(file =~ /\.rb$/)
  end
end