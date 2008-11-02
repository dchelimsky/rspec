module Spec
  module Matchers

    class ContainExactly #:nodoc:

      def initialize(*expecteds)
        @expecteds = expecteds
        @offending_objects = []
      end

      def matches?(given)
        @given = given
        @extra_items = @given.reject do |object|
          @expecteds.include?(object)
        end
        @missing_items = @expecteds.reject do |object|
          @given.include?(object)
        end
        @extra_items.empty? and @missing_items.empty?
      end

        def failure_message
          _message
        end
        
      #   def negative_failure_message
      #     _message("not ")
      #   end
        
        def description
          "include #{_pretty_print(@expecteds)}"
        end
        
        private
          def _message(maybe_not="")
            message =  "expected collection contained:  #{@expecteds.sort.inspect}\n"
            message += "actual collection contained:    #{@given.sort.inspect}\n"
            message += "the missing elements were:      #{@missing_items.sort.inspect}\n" unless @missing_items.empty?
            message += "the extra elements were:        #{@extra_items.sort.inspect}\n" unless @extra_items.empty?
            message
          end
          
      #     def _pretty_print(array)
      #       result = ""
      #       array.each_with_index do |item, index|
      #         if index < (array.length - 2)
      #           result << "#{item.inspect}, "
      #         elsif index < (array.length - 1)
      #           result << "#{item.inspect} and "
      #         else
      #           result << "#{item.inspect}"
      #         end
      #       end
      #       result
      #     end
    end

    # :call-seq:
    #   should include(expected)
    #   should_not include(expected)
    #
    # Passes if given includes expected. This works for
    # collections and Strings. You can also pass in multiple args
    # and it will only pass if all args are found in collection.
    #
    # == Examples
    #
    #   [1,2,3].should include(3)
    #   [1,2,3].should include(2,3) #would pass
    #   [1,2,3].should include(2,3,4) #would fail
    #   [1,2,3].should_not include(4)
    #   "spread".should include("read")
    #   "spread".should_not include("red")
    def contain_exactly(*expected)
      Matchers::ContainExactly.new(*expected)
    end
  end
end
