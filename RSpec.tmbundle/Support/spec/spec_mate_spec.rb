require 'stringio'

context "SpecMate" do
  setup do
    @first_failing_spec  = /fixtures\/example_failing_spec\.rb&line=3/n
    @second_failing_spec  = /fixtures\/example_failing_spec\.rb&line=7/n
    
    root = File.expand_path(File.dirname(__FILE__) + '/../../../..')
    if File.exist?("#{root}/bin/spec")
      @spec_cmd = "ruby -I\"#{root}/lib\" \"#{root}/bin/spec\""
    else
      @spec_cmd = "spec"
    end
    ENV['TM_SPEC'] = @spec_command
    ENV['TM_PROJECT_DIRECTORY'] = File.expand_path(File.dirname(__FILE__))
    ENV['TM_FILEPATH'] = nil
    ENV['TM_LINE_NUMBER'] = nil
    require File.dirname(__FILE__) + '/../lib/spec_mate'
    @spec_mate = SpecMate.new
  end

  specify "should run whole file when only file specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/fixtures/example_failing_spec.rb'

    out = StringIO.new
    @spec_mate.run_file(out)
    out.rewind
    html = out.read
    html.should =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end

  specify "should run first spec when file and line 4 specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/fixtures/example_failing_spec.rb'
    ENV['TM_LINE_NUMBER'] = '4'

    out = StringIO.new
    @spec_mate.run_focussed(out)
    out.rewind
    html = out.read
    html.should =~ @first_failing_spec
    html.should_not =~ @second_failing_spec
  end

  specify "should run first spec when file and line 8 specified" do
    ENV['TM_FILEPATH'] = File.expand_path(File.dirname(__FILE__)) + '/fixtures/example_failing_spec.rb'
    ENV['TM_LINE_NUMBER'] = '8'

    out = StringIO.new
    @spec_mate.run_focussed(out)
    out.rewind
    html = out.read

    html.should_not =~ @first_failing_spec
    html.should =~ @second_failing_spec
  end

  specify "should run all selected files" do
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
end