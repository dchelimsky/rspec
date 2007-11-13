require 'rbconfig'
require "test/unit"
require "test/unit/testresult"
require "test/unit/ui/testrunnermediator"
require File.dirname(__FILE__) + '/../../spec/spec_helper.rb'

module RubyRunner
  # Launces a new ruby interpreter - the same as the one running this one.
  # This is to ensure we fork with jruby when running with jruby
  def ruby(args)
    config       = ::Config::CONFIG
    interpreter  = File::join(config['bindir'], config['ruby_install_name']) + config['EXEEXT']
    `#{interpreter} #{args}`
  end
end