# This file contains various classes used by the tests.
# They are kept in a separate file so that they can also
# be accessed by the test2spec-translated specs
module Spec
  module Api
    class ClassWithMultiWordPredicate
      def multi_word_predicate?
        true 
      end
    end

    module Helper
      class CollectionWithSizeMethod
        def initialize; @list = []; end
        def size; @list.size; end
        def push(item); @list.push(item); end
      end

      class CollectionWithLengthMethod
        def initialize; @list = []; end
        def length; @list.size; end
        def push(item); @list.push(item); end
      end

      class CollectionOwner
        attr_reader :items_in_collection_with_size_method, :items_in_collection_with_length_method

        def initialize
          @items_in_collection_with_size_method = CollectionWithSizeMethod.new
          @items_in_collection_with_length_method = CollectionWithLengthMethod.new
        end

        def add_to_collection_with_size_method(item)
          @items_in_collection_with_size_method.push(item)
        end

        def add_to_collection_with_length_method(item)
          @items_in_collection_with_length_method.push(item)
        end
      end

      class XxxMock
        def initialize(return_val)
          @return_val = return_val
          @xxx_called = false
        end

        def xxx?
          @xxx_called = true
          @return_val
        end

        def yyy?(a, b, c)
          a.should.be 1
          b.should.be 2
          c.should.be 3
          @xxx_called = true
          @return_val
        end

        def __verify
          @xxx_called.should.be true
        end
      end
    end
  end
end

module Custom
  class Formatter
  end
end

