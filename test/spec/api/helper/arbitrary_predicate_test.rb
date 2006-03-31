require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ArbitraryPredicateTest < Test::Unit::TestCase

        # should.be.xxx

      	def test_should_be_xxx_should_raise_when_target_doesnt_understand_xxx
      		assert_raise(NoMethodError) do
            5.should.be.xxx
          end
      	end

      	def test_should_be_xxx_should_raise_when_sending_xxx_to_target_returns_false
      		mock = Mock.new("xxx? returns false")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(false)
      	  assert_raise(ExpectationNotMetError) do
            mock.should.be.xxx
          end
      		mock.__verify
        end

      	def test_should_be_xxx_should_raise_when_sending_xxx_to_target_returns_nil
      		mock = Mock.new("xxx? returns nil")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(nil)
      	  assert_raise(ExpectationNotMetError) do
            mock.should.be.xxx
          end
      		mock.__verify
        end

      	def test_should_be_xxx_should_not_raise_when_sending_xxx_to_target_returns_true
      		mock = Mock.new("xxx? returns true")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(true)
      	  assert_nothing_raised do
            mock.should.be.xxx
          end
      		mock.__verify
        end

      	def test_should_be_xxx_should_not_raise_when_sending_xxx_to_target_returns_something_other_than_true_false_or_nil
      		mock = Mock.new("xxx? returns 5")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(5)
      	  assert_nothing_raised do
            mock.should.be.xxx
          end
      		mock.__verify
        end

      	# should.be.xxx(args)
	
        def test_should_be_xxx_with_args_passes_args_properly
       		mock = Mock.new("xxx?(1 2 3) returns true")
      		mock.should_receive(:xxx?).once.with(1, 2, 3).and_return(true)
      	  assert_nothing_raised do
            mock.should.be.xxx(1, 2, 3)
          end
      		mock.__verify
        end

        # should.not.be.xxx

      	def test_should_not_be_xxx_should_raise_when_target_doesnt_understand_xxx
      		assert_raise(NoMethodError) do
            5.should.not.be.xxx
          end
      	end

      	def test_should_not_be_xxx_should_raise_when_sending_xxx_to_target_returns_true
      		mock = Mock.new("xxx? returns true")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(true)
      	  assert_raise(ExpectationNotMetError) do
            mock.should.not.be.xxx
          end
      		mock.__verify
        end

      	def test_should_not_be_xxx_shouldnt_raise_when_sending_xxx_to_target_returns_nil
      		mock = Mock.new("xxx? returns nil")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(nil)
      	  assert_nothing_raised do
            mock.should.not.be.xxx
          end
      		mock.__verify
        end

      	def test_should_not_be_xxx_shouldnt_raise_when_sending_xxx_to_target_returns_false
      		mock = Mock.new("xxx? returns false")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(false)
      	  assert_nothing_raised do
            mock.should.not.be.xxx
          end
      		mock.__verify
        end

      	def test_should_not_be_xxx_should_raise_when_sending_xxx_to_target_returns_something_other_than_true_false_or_nil
      		mock = Mock.new("xxx? returns 5")
      		mock.should_receive(:xxx?).once.with_no_args.and_return(5)
      	  assert_raise(ExpectationNotMetError) do
            mock.should.not.be.xxx
          end
      		mock.__verify
        end
  
      	# should.be.xxx(args)
	
        def test_should_not_be_xxx_with_args_passes_args_properly
       		mock = Mock.new("xxx?(1 2 3) returns false")
      		mock.should_receive(:xxx?).once.with(1, 2, 3).and_return(false)
      	  assert_nothing_raised do
            mock.should.not.be.xxx(1, 2, 3)
          end
      		mock.__verify
        end

      end
    end
  end
end
