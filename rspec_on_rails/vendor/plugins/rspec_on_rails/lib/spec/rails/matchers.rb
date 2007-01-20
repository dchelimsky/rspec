dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/matchers/assert_select_matcher")

module Spec
  module Rails
    module Matchers
      def have_tag(*args, &block)
        args.unshift(response)
        AssertSelect.new(*args, &block)
      end

      def have_rjs(*args, &block)
        args.unshift(response)
        case args.last
        when Hash
          args.last[:select_type] = "rjs"
        else
          args << {:select_type => "rjs"}
        end
        AssertSelect.new(*args, &block)
      end
      
      def with_tag(*args, &block)
        AssertSelect.selected.should have_tag(*args, &block)
      end
      
      def without_tag(*args, &block)
        AssertSelect.selected.should_not have_tag(*args, &block)
      end
    end
  end
end