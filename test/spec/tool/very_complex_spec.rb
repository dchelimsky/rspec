require 'spec'
require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Tool
    context "VeryComplex" do
      specify "Is still translatable" do
        an_int = 789
        a_float = 123.45
        a_nil = nil

        an_int.should.not.be.nil
        Proc.new{ true }.should.be.true
        Proc.new do
          true
        end.should.be.true
        an_int.should.equal 789
        a_float.should.be.close.to 123.5
        an_int.should.be.instance.of Fixnum
        an_int.should.be.kind.of Numeric
        an_int.to_s.should.match /789/
        a_nil.should.be.nil
        an_int.to_s.should.not.match /7890/
        an_int.should.not.equal 780
        "a message".should.not.be.nil an_int
        a_float.should.not.be.same an_int
        Proc.new{ foo = 1 }.should.not.raise
        Proc.new do
          foo = 2
        end.should.not.raise
        Proc.new{ foo = 3 }.should.not.throw
        Proc.new do
          foo = 4
        end.should.not.throw
        #assert_operator       object1, operator, object2, "a message"
        Proc.new{ raise NotImplementedError }.should.raise NotImplementedError
        Proc.new do
          raise NotImplementedError
        end.should.raise NotImplementedError
        Proc.new{ raise NotImplementedError }.should.raise NotImplementedError
        Proc.new do
          raise NotImplementedError
        end.should.raise NotImplementedError
        an_int.should.respond.to :to_f
        a_float.should.be a_float
        #assert_send send_array, "a message"
        assert_throws(:foo, "a message"){
          throw :foo
        }
        assert_throws(:foo, "a message") do
          throw :foo
        end

      end
    end
  end
end