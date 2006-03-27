require 'test/unit'
require File.dirname(__FILE__) + '/context'
require File.dirname(__FILE__) + '/mock_builder'

class ContextTest < Test::Unit::TestCase

  def test_should_add_its_name_to_builder
    @context = Spec::Context.new("builder test") { true }
    builder = MockBuilder.new
    @context.add_to_builder(builder)
    assert_equal(builder.context_name_received, "builder test")
  end
  
  def test_should_add_spec_data_to_builder
    @context = Spec::Context.new("test context") { true }
    @context.specify("test spec") { true }
    builder = MockBuilder.new
    @context.add_to_builder(builder)
    assert_equal("test context", builder.context_name_received)
    assert_equal("test spec", builder.spec_name_received)
  end
  
end