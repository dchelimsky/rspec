# stub frameworks like to gum up Object, so this is deliberately
# set NOT to run so that you don't accidentally run it when you
# run this dir.

# To run it, stand in this directory and say:
#
#   RUN_MOCHA_SPEC=true bin/spec failing_examples/mocking_with_mocha.rb

if ENV['RUN_MOCHA_SPEC']
  require 'rubygems'
  gem 'mocha'
  require 'mocha'

  describe Mocha, " framework" do
    it "should should be made available by simply requiring mocha" do
      m = Object.new
      m.expects(:msg)
    end
  end
end