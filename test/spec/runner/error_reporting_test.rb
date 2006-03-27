require 'test/unit'

require 'collection_owner'
require 'spec'

class ErrorReportingContext < Spec::Context

  def should_satisfy
    5.should.satisfy { |x| x == 3 }
  end

  def should_not_satisfy
    3.should.not.satisfy { |x| x == 3 }
  end

  def should_equal
    Object.should.equal Class
  end

  def should_not_equal
    Object.should.not.equal Object
  end

  def should_be_nil
    Object.should.be nil
  end

  def should_not_be_nil
    nil.should.not.be nil
  end

  def should_be_empty
    ['foo', 'bar'].should.be.empty
  end
  
  def should_not_be_empty
    [].should.not.be.empty
  end

  def should_include
    ['foo'].should.include('bar')
  end

  def should_not_include
    ['foo'].should.not.include('foo')
  end

  def should_be_true
    false.should.be true
  end

  def should_be_false
    true.should.be false
  end
  
  def should_raise_with_no_error
    proc { ''.to_s }.should.raise NoMethodError
  end
  
  def should_raise_with_wrong_error
    proc { ''.no_method }.should.raise SyntaxError
  end
  
  def should_not_raise
    proc { ''.no_method }.should.not.raise NoMethodError
  end  

  def should_have_with_length
    owner = CollectionOwner.new
    owner.should.have(3).items_in_collection_with_length_method
  end

  def should_have_at_least_with_length
    owner = CollectionOwner.new
    owner.should.have.at.least(3).items_in_collection_with_length_method
  end

  def should_have_at_most_with_length
    owner = CollectionOwner.new
    (1..4).each { |n| owner.add_to_collection_with_length_method n }
    owner.should.have.at.most(3).items_in_collection_with_length_method
  end
  
  def should_have_with_size
    owner = CollectionOwner.new
    owner.should.have(3).items_in_collection_with_size_method
  end

  def should_have_at_least_with_size
    owner = CollectionOwner.new
    owner.should.have.at.least(3).items_in_collection_with_size_method
  end

  def should_have_at_most_with_size
    owner = CollectionOwner.new
    (1..4).each { |n| owner.add_to_collection_with_size_method n }
    owner.should.have.at.most(3).items_in_collection_with_size_method
  end
end

class ErrorReportingRunner

  def initialize
    @failures = []
  end

  def pass(spec)
  end

  def failure(spec, exception)
    @failures << exception.message
  end

  def error(spec)
  end

  def spec(spec)
  end

  def run(context)
    context.specifications.each do |example|
      the_context = context.new(example)
      the_context.run(self)
    end
  end

  def dump_failures
    @failures
  end

end


class ErrorReportingTest < Test::Unit::TestCase

  def setup
    @runner = ErrorReportingRunner.new
    @runner.run(ErrorReportingContext)
  end

  def test_should_report_message_for_should_satisfy
    assert @runner.dump_failures.include?("Supplied expectation was not satisfied")
  end

  def test_should_report_message_for_should_equal
    assert @runner.dump_failures.include?("<Object:Class> should equal <Class:Class>"), @runner.dump_failures
  end

  def test_should_report_message_for_should_not_equal
    assert @runner.dump_failures.include?("<Object:Class> should not equal <Object:Class>"), @runner.dump_failures
  end
  
  def test_should_report_message_for_should_be_nil
    assert @runner.dump_failures.include?("<Object:Class> should be nil")
  end

  def test_should_report_message_for_should_not_be_nil
    assert @runner.dump_failures.include?("nil should not be nil")
  end
  
  def test_should_report_message_for_should_be_empty
    assert @runner.dump_failures.include?('<["foo", "bar"]> should be empty')
  end

  def test_should_report_message_for_should_not_be_empty
    assert @runner.dump_failures.include?("<[]> should not be empty")
  end
    
  def test_should_report_message_for_should_include
    assert @runner.dump_failures.include?('<["foo"]> should include <"bar">')
  end
  
  def test_should_report_message_for_should_not_include
    assert @runner.dump_failures.include?('<["foo"]> should not include <"foo">')
  end
  
  def test_should_report_message_for_should_be_true
    assert @runner.dump_failures.include?("<false> should be <true>")
  end

  def test_should_report_message_for_should_be_false
    assert @runner.dump_failures.include?("<true> should be <false>")
  end
  
  def test_should_report_message_for_should_raise_with_no_error
    assert @runner.dump_failures.include?("<Proc> should raise <\"NoMethodError\">")
  end
  
  def test_should_report_message_for_should_raise_with_wrong_error
    assert @runner.dump_failures.include?("<Proc> should raise <\"SyntaxError\">")
  end
  
  def test_should_report_message_for_should_not_raise
    assert @runner.dump_failures.include?("<Proc> should not raise <\"NoMethodError\">")
  end
  
  def test_should_report_message_for_should_not_raise
    assert @runner.dump_failures.include?("<Proc> should not raise <\"NoMethodError\">")
  end
  
  def test_should_report_message_for_should_have_with_length
    assert @runner.dump_failures.include?('<CollectionOwner> should have 3 items_in_collection_with_length_method (has 0)')
  end
  
  def test_should_report_message_for_should_have_at_least_with_length
    assert @runner.dump_failures.include?('<CollectionOwner> should have at least 3 items_in_collection_with_length_method (has 0)')
  end
  
  def test_should_report_message_for_should_have_at_most_with_length
    assert @runner.dump_failures.include?('<CollectionOwner> should have at most 3 items_in_collection_with_length_method (has 4)')
  end
  
  def test_should_report_message_for_should_have_with_size
    assert @runner.dump_failures.include?('<CollectionOwner> should have 3 items_in_collection_with_size_method (has 0)')
  end
  
  def test_should_report_message_for_should_have_at_least_with_size
    assert @runner.dump_failures.include?('<CollectionOwner> should have at least 3 items_in_collection_with_size_method (has 0)')
  end
  
  def test_should_report_message_for_should_have_at_most_with_size
    assert @runner.dump_failures.include?('<CollectionOwner> should have at most 3 items_in_collection_with_size_method (has 4)')
  end
  
end
