dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/matchers/assert_select_matcher")

module Spec
  module Rails
    module Matchers
      def have_tag(*args, &block)
        AssertSelect.new(*args, &block)
      end
    end
  end
end