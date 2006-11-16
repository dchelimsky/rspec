# begin
#   require 'test/rails'
# rescue LoadError
#   raise "You must gem install ZenTest"
# end

#This is necessary to override ZenTests automagic mapping of test names to tested classes
# class Spec::Rails::HelperTestCase
#   def self.inherited(helper_testcase)
#     super
#   end
# end