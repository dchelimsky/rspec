dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/matchers/assert_select_matcher")

module Spec
  module Rails
    module Matchers
      # :call-seq:
      #   response.should have_tag(selector, equality?, message?)
      #   response.should have_tag(element, selector, equality?, message?)
      #
      # This is a wrapper for assert_select and works the same way
      # but with rspec-friendly syntax
      #
      # An expecation that selects elements and makes one or more equality comparisons.
      #
      # If the first argument is an element, selects all matching elements
      # starting from (and including) that element and all its children in
      # depth-first order.
      #
      # If no element if specified, calling #have_tag will select from the
      # response HTML. Calling #have_tag inside an #have_tag block will
      # run the assertion for each element selected by the enclosing assertion.
      #
      # For example:
      #   response.should have_tag("ol>li") { |elements|
      #     elements.each do |element|
      #       element.should have_tag("li")
      #     end
      #   end
      # Or for short:
      #   response.should have_tag("ol>li") {
      #     with_tag("li")
      #   }
      # The selector may be a CSS selector expression (+String+), an expression
      # with substitution values, or an HTML::Selector object.
      #
      # === Equality
      #
      # The equality test may be one of the following:
      # * <tt>true</tt> -- passes if at least one element selected.
      # * <tt>false</tt> -- passes if no element selected.
      # * <tt>String/Regexp</tt> -- passes if the text value of at least
      #   one element matches the string or regular expression.
      # * <tt>Integer</tt> -- passes if exactly that number of
      #   elements are selected.
      # * <tt>Range</tt> -- passes if the number of selected
      #   elements fit the range.
      # If no equality test specified, the expecatation passes if at least one
      # element selected.
      #
      # To set more than one equality expectation, use a hash with the following keys:
      # * <tt>:text</tt> -- Narrow the selection to elements that have this text
      #   value (string or regexp).
      # * <tt>:html</tt> -- Narrow the selection to elements that have this HTML
      #   content (string or regexp).
      # * <tt>:count</tt> -- Assertion is true if the number of selected elements
      #   is equal to this value.
      # * <tt>:minimum</tt> -- Assertion is true if the number of selected
      #   elements is at least this value.
      # * <tt>:maximum</tt> -- Assertion is true if the number of selected
      #   elements is at most this value.
      #
      # If the method is called with a block, once all expectations are
      # evaluated the block is called with an array of all selected elements.
      #
      # === Examples
      # 
      #   # At least one form element
      #   response.should have_tag("form")
      #
      #   # Form element includes four input fields
      #   response.should have_tag("form input", 4)
      #
      #   # Page title is "Welcome"
      #   response.should have_tag("title", "Welcome")
      #
      #   # Page title is "Welcome" and there is only one title element
      #   response.should have_tag("title", {:count=>1, :text=>"Welcome"},
      #       "Wrong title or more than one title element")
      #
      #   # Page contains no forms
      #   response.should have_tag("form", false, "This page must contain no forms")
      #
      #   # Test the content and style
      #   response.should have_tag("body div.header ul.menu")
      #
      #   # Use substitution values
      #   response.should have_tag("ol>li#?", /item-\d+/)
      #
      #   # All input fields in the form have a name
      #   response.should have_tag("form input") {
      #     with_tag("[name=?]", /.+/)
      #   }
      def have_tag(*args, &block)
        args.unshift(response)
        AssertSelect.new(*args, &block)
      end

      def be_rjs(*args, &block)
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
      
      def with_encoded(*args, &block)
        case args.last
        when Hash
          args.last[:select_type] = "encoded"
        else
          args << {:select_type => "encoded"}
        end
        AssertSelect.selected.should have_tag(*args, &block)
      end
      
      def without_tag(*args, &block)
        AssertSelect.selected.should_not have_tag(*args, &block)
      end
      
      def be_feed(*args, &block)
        args.unshift(response)
        case args.last
        when Hash
          args.last[:select_type] = "feed"
        else
          args << {:select_type => "feed"}
        end
        AssertSelect.new(*args, &block)
      end
      
      def send_email(*args, &block)
        args.unshift(response)
        case args.last
        when Hash
          args.last[:select_type] = "email"
        else
          args << {:select_type => "email"}
        end
        AssertSelect.new(*args, &block)
      end
    end
  end
end