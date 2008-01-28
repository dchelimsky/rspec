require File.dirname(__FILE__) + '/../../spec_helper'

share_as :RunnerSpecHelper do
  before(:each) do
    @first_failing_spec  = /fixtures\/example_failing_spec\.rb&line=3/n
    @second_failing_spec  = /fixtures\/example_failing_spec\.rb&line=7/n
    @fixtures_path = File.expand_path(File.dirname(__FILE__)) + '/../../../fixtures'

    set_env
    load File.expand_path("#{File.dirname(__FILE__)}/../../../lib/spec/mate.rb")
    @spec_mate = Spec::Mate::Runner.new

    @test_runner_io = StringIO.new
  end

  after(:each) do
    set_env
    $".delete_if do |path|
      path =~ /example_failing_spec\.rb/
    end
    rspec_options.example_groups.delete_if do |example_group|
      example_group.description == "An example failing spec"
    end
  end
end

describe "Spec::Mate::Runner#run_file" do
  include RunnerSpecHelper

  it "should run whole file when only file specified" do
    ENV['TM_FILEPATH'] = "#{@fixtures_path}/example_failing_spec.rb"

    @spec_mate.run_file(@test_runner_io)
    @test_runner_io.rewind
    html = @test_runner_io.read
    html.should =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end
end

describe "Spec::Mate::Runner#run_files" do
  include RunnerSpecHelper

  it "should run all selected files" do
    ENV['TM_SELECTED_FILES'] = ['example_failing_spec.rb', 'example_passing_spec.rb'].map do |f|
      "'#{@fixtures_path}/#{f}'"
    end.join(" ")

    @spec_mate.run_files(@test_runner_io)
    @test_runner_io.rewind
    html = @test_runner_io.read

    html.should =~ @first_failing_spec
    html.should =~ @second_failing_spec
    html.should =~ /should pass/
    html.should =~ /should pass too/
  end
end

describe "Spec::Mate::Runner#run_focused" do
  include RunnerSpecHelper

  it "should run first spec when file and line 4 specified" do
    ENV['TM_FILEPATH'] = "#{@fixtures_path}/example_failing_spec.rb"
    ENV['TM_LINE_NUMBER'] = '4'

    @spec_mate.run_focussed(@test_runner_io)
    @test_runner_io.rewind
    html = @test_runner_io.read
    html.should =~ @first_failing_spec
    html.should_not =~ @second_failing_spec
  end

  it "should run first spec when file and line 8 specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/../../../fixtures/example_failing_spec.rb'
    ENV['TM_LINE_NUMBER'] = '8'

    @spec_mate.run_focussed(@test_runner_io)
    @test_runner_io.rewind
    html = @test_runner_io.read

    html.should_not =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end
end

describe "Spec::Mate::Runner error cases" do
  include RunnerSpecHelper

  it "should raise exception when TM_PROJECT_DIRECTORY points to bad location" do
    ENV['TM_PROJECT_DIRECTORY'] = __FILE__ # bad on purpose
    lambda do
      load File.dirname(__FILE__) + '/../../../lib/spec/mate.rb'
    end.should_not raise_error
  end

  it "should raise exception when TM_RSPEC_HOME points to bad location" do
    ENV['TM_RSPEC_HOME'] = __FILE__ # bad on purpose
    lambda do
      load File.dirname(__FILE__) + '/../lib/spec_mate.rb'
    end.should raise_error
  end
end
