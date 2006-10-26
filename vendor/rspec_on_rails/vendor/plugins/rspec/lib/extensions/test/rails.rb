require 'test/rails'

#This is necessary to override ZenTests automagic mapping of test names to tested classes
class Test::Rails::HelperTestCase
  def self.inherited(helper_testcase)
    super
  end
end