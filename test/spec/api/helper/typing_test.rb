require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class TypeTest < Test::Unit::TestCase

      	# should.be.an.instance.of <class>
	
      	def test_should_be_an_instance_of_should_pass_when_target_is_specified_class
      		assert_nothing_raised do
      			5.should.be.an.instance.of Fixnum
      		end
      	end
	
      	def test_should_be_an_instance_of_should_fail_when_target_is_not_specified_class
      		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      			5.should.be.an.instance.of Integer
      		end
      	end
	
      	# should.be.a.kind.of <class>
	
      	def test_should_be_a_kind_of_should_pass_when_target_is_of_specified_class
      		assert_nothing_raised do
      			5.should.be.a.kind.of Fixnum
      		end
      	end

      	def test_should_be_a_kind_of_should_pass_when_target_is_of_subclass_of_specified_class
      		assert_nothing_raised do
      			5.should.be.a.kind.of Integer
      		end
      	end

      	def test_should_be_an_instance_of_should_fail_when_target_is_not_specified_class
      		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      			5.should.be.a.kind.of String
      		end
      	end
	
      	# should.not.be.an.instance_of <class>
	
      	def test_should_not_be_an_instance_of_should_fail_when_target_is_of_specified_class
      		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      			'hello'.should.not.be.an.instance.of String
      		end
      	end
	
      	def test_should_be_an_instance_of_should_pass_when_target_is_not_of_specified_class
      		assert_nothing_raised do
      			[].should.not.be.an.instance.of String
      		end
      	end

      	# should.be.a.kind.of <class>
	
      	def test_should_not_be_a_kind_of_should_fail_when_target_is_of_specified_class
      		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      			5.should.not.be.a.kind.of Fixnum
      		end
      	end

      	def test_should_not_be_a_kind_of_should_fail_when_target_is_of_subclass_of_specified_class
      		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      			5.should.not.be.a.kind.of Integer
      		end
      	end

      	def test_should_not_be_an_instance_of_should_pass_when_target_is_not_specified_class
      		assert_nothing_raised do
      			5.should.not.be.a.kind.of String
      		end
      	end
	
      	# should.respond.to <message>
	
      	def test_should_respond_to_should_pass_when_target_does
      		assert_nothing_raised do
      			"".should.respond.to :length
      		end
      	end

      	def test_should_respond_to_should_fail_when_target_doesnt
      		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      			"".should.respond.to :connect
      		end
      	end

      	# should.not.respond.to <message>
	
      	def test_not_should_respond_to_should_fail_when_target_does
      		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      			"".should.not.respond.to :length
      		end
      	end

      	def test_not_should_respond_to_should_pass_when_target_doesnt
      		assert_nothing_raised do
      			"".should.not.respond.to :connect
      		end
      	end

      end
    end
  end
end
