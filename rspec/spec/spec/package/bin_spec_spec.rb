require "#{File.dirname(__FILE__)}/../../spec_helper"
require 'rbconfig'

describe "The bin/spec script" do
  it "should have no warnings" do
    pending "Hangs on JRuby" if PLATFORM =~ /java/
    spec_path = "#{File.dirname(__FILE__)}/../../../bin/spec"
    output = nil

    config       = ::Config::CONFIG
    ruby         = File::join(config['bindir'], config['ruby_install_name']) + config['EXEEXT']
    IO.popen("#{ruby} -w #{spec_path} --help 2>&1") do |io|
      output = io.read
    end
    output.should_not =~ /warning/n
  end
end
