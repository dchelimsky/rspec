# stub frameworks like to gum up Object, so this is deliberately
# set NOT to run so that you don't accidentally run it when you
# run this dir.

# To run it, stand in this directory and say:
#
#   RUN_MOCHA_SPEC=true ruby ../bin/spec mocking_with_mocha.rb

if ENV['RUN_MOCHA_SPEC']
  Spec::Runner.configure do |config|
    config.mock_with :mocha
  end
  describe "Mocha framework" do
    it "should should be made available by saying config.mock_with :mocha" do
      m = mock()
      m.expects(:msg).with("arg")
      m.msg
    end
  end
end