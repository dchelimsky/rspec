require 'spec'

module Spec
  module Tool
    context "TestUnitApi" do

      setup do
        @an_int = 789
      end

      teardown do
      end

      specify "Can be translated to rspec" do
        a_float = 123.45
        a_nil = nil

        @an_int.should.not.be nil
        lambda { true }.should.be true
        lambda do
          true
        end.should.be true
        @an_int.should.equal 789
        a_float.should.be.close 123.5, 0.1
        @an_int.should.be.instance.of Fixnum
        @an_int.should.be.kind.of Numeric
        @an_int.to_s.should.match /789/
        a_nil.should.be nil
        @an_int.to_s.should.not.match /7890/
        @an_int.should.not.equal 780
        @an_int.should.not.be nil
        a_float.should.not.be @an_int
        lambda { foo = 1 }.should.not.raise
        lambda do
          foo = 2
        end.should.not.raise
        lambda { foo = 3 }.should.not.throw
        lambda do
          foo = 4
        end.should.not.throw
        #assert_operator       object1, operator, object2, "a message"
        lambda { raise NotImplementedError }.should.raise NotImplementedError
        lambda do
          raise NotImplementedError
        end.should.raise NotImplementedError
        lambda { raise NotImplementedError }.should.raise NotImplementedError
        lambda do
          raise NotImplementedError
        end.should.raise NotImplementedError
        @an_int.should.respond.to :to_f
        a_float.should.be a_float
        #assert_send send_array, "a message"
        lambda { throw :foo }.should.throw :foo
        lambda do
          throw :foo
        end.should.throw :foo

      end
    end
  end
end