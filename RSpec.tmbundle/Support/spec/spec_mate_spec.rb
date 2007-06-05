require "#{File.dirname(__FILE__)}/spec_helper"
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "rspec", "spec", "spec_helper"))

describe "SpecMate" do
  def set_env
    root = File.expand_path(File.dirname(__FILE__) + '/../../../rspec')
    ENV['TM_SPEC'] = "ruby -I\"#{root}/lib\" \"#{root}/bin/spec\""
    ENV['TM_RSPEC_HOME'] = "#{root}"
    ENV['TM_PROJECT_DIRECTORY'] = File.expand_path(File.dirname(__FILE__))
    ENV['TM_FILEPATH'] = nil
    ENV['TM_LINE_NUMBER'] = nil
  end
  
  before(:each) do
    @first_failing_spec  = /fixtures\/example_failing_spec\.rb&line=3/n
    @second_failing_spec  = /fixtures\/example_failing_spec\.rb&line=7/n
    
    set_env
    load File.dirname(__FILE__) + '/../lib/spec_mate.rb'
    @spec_mate = SpecMate.new
  end
  
  after(:each) do
    set_env
  end

  it "should run whole file when only file specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/fixtures/example_failing_spec.rb'

    out = StringIO.new
    @spec_mate.run_file(out)
    out.rewind
    html = out.read
    html.should =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end

  it "should run first spec when file and line 4 specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/fixtures/example_failing_spec.rb'
    ENV['TM_LINE_NUMBER'] = '4'

    out = StringIO.new
    @spec_mate.run_focussed(out)
    out.rewind
    html = out.read
    html.should =~ @first_failing_spec
    html.should_not =~ @second_failing_spec
  end

  it "should run first spec when file and line 8 specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/fixtures/example_failing_spec.rb'
    ENV['TM_LINE_NUMBER'] = '8'

    out = StringIO.new
    @spec_mate.run_focussed(out)
    out.rewind
    html = out.read

    html.should_not =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end

  it "should run all selected files" do
    ENV['TM_SELECTED_FILES'] = ['example_failing_spec.rb', 'example_passing_spec.rb'].map do |f|
      "'" + File.expand_path(File.dirname(__FILE__)) + "/fixtures/#{f}'"
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
  
  it "should raise exception when TM_RSPEC_HOME points to bad location" do
    ENV['TM_PROJECT_DIRECTORY'] = __FILE__ # bad on purpose
    lambda do
      load File.dirname(__FILE__) + '/../lib/spec_mate.rb'
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
