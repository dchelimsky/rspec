require "#{File.dirname(__FILE__)}/../../spec_helper"

context "The bin/spec script" do
  specify "has no warnings" do
    spec_path = "#{File.dirname(__FILE__)}/../../../bin/spec"
    output = nil
    IO.popen("ruby -w #{spec_path} --help 2>&1") do |io|
      output = io.read
    end
    output.should_not =~ /warning/n
  end
end