require File.dirname(__FILE__) + '/../../spec_helper'

describe "Spec::Mate::Runner", :shared => true do
  before(:each) do
    @first_failing_spec  = /fixtures\/example_failing_spec\.rb&line=3/n
    @second_failing_spec  = /fixtures\/example_failing_spec\.rb&line=7/n
    
    set_env
    load File.dirname(__FILE__) + '/../../../lib/spec/mate.rb'
    @spec_mate = Spec::Mate::Runner.new

    @test_runner_io = StringIO.new
    Test::Unit::UI::Console::TestRunner.const_set(:STDOUT, @test_runner_io)
  end
  
  after(:each) do
    set_env
    Test::Unit::UI::Console::TestRunner.__send__(:remove_const, :STDOUT)
  end
end

describe "Spec::Mate::Runner#run_file" do
  it_should_behave_like "Spec::Mate::Runner"
  
  it "should run whole file when only file specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/../../../fixtures/example_failing_spec.rb'

    out = StringIO.new
    @spec_mate.run_file(out)
    out.rewind
    html = out.read
    html.should =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end
end

describe "Spec::Mate::Runner#run_files" do
  it_should_behave_like "Spec::Mate::Runner"

  it "should run all selected files" do
    ENV['TM_SELECTED_FILES'] = ['example_failing_spec.rb', 'example_passing_spec.rb'].map do |f|
      "'" + File.expand_path(File.dirname(__FILE__)) + "/../../../fixtures/#{f}'"
    end.join(" ")

    out = StringIO.new
    @spec_mate.run_files(out)
    out.rewind
    html = out.read

    html.should =~ @first_failing_spec
    html.should =~ @second_failing_spec
    html.should =~ /should pass/
    html.should =~ /should pass too/
  end
end

describe "Spec::Mate::Runner#run_focused" do
  it_should_behave_like "Spec::Mate::Runner"

  it "should run first spec when file and line 4 specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/../../../fixtures/example_failing_spec.rb'
    ENV['TM_LINE_NUMBER'] = '4'

    out = StringIO.new
    @spec_mate.run_focussed(out)
    out.rewind
    html = out.read
    html.should =~ @first_failing_spec
    html.should_not =~ @second_failing_spec
  end

  it "should run first spec when file and line 8 specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/../../../fixtures/example_failing_spec.rb'
    ENV['TM_LINE_NUMBER'] = '8'

    out = StringIO.new
    @spec_mate.run_focussed(out)
    out.rewind
    html = out.read

    html.should_not =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end
end

describe "Spec::Mate::Runner error cases" do
  it_should_behave_like "Spec::Mate::Runner"

  it "should raise exception when TM_RSPEC_HOME points to bad location" do
    ENV['TM_PROJECT_DIRECTORY'] = __FILE__ # bad on purpose
    lambda do
      load File.dirname(__FILE__) + '/../../../lib/spec/mate.rb'
    end.should_not raise_error
  end
  
  it "should raise exception when TM_RSPEC_HOME points to bad location" do
    ENV['TM_PROJECT_DIRECTORY'] = __FILE__ # bad on purpose
    ENV['TM_RSPEC_HOME'] = __FILE__ # bad on purpose
    lambda do
      load File.dirname(__FILE__) + '/../lib/spec_mate.rb'
    end.should raise_error
  end
end
