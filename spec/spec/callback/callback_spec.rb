require File.dirname(__FILE__) + '/../../spec_helper.rb'

context "A Callback" do
  setup do
    @callback_object = Object.new
    @callback_object.extend Spec::Callback
  end

  specify "should be notified" do
    callback_key = :create
    passed_callback_argument = nil
    @callback_object.define_callback(callback_key) do |callback_argument|
      passed_callback_argument = callback_argument
    end

    expected_argument = Object.new
    @callback_object.notify_callbacks(callback_key, expected_argument)
    passed_callback_argument.should_equal expected_argument
  end

  specify "should handle errors" do
    @callback_object.define_callback(:error_callback) do
      raise "First Error"
    end

    @callback_object.define_callback(:error_callback) do
      raise "Second Error"
    end

    error_messages = []
    @callback_object.notify_callbacks(:error_callback) do |e|
      error_messages << e.message
    end

    error_messages.should_eql ["First Error", "Second Error"]
  end

  specify "should not fail with nothing to notify" do
    @callback_object.notify_callbacks(:foobar, :argument)
  end
end
