# This is a port of assert_select for rspec.

# assert_select plugins for Rails
#
# Copyright (c) 2006 Assaf Arkin, under Creative Commons Attribution and/or MIT License
# Developed for http://co.mments.com
# Code and documention: http://labnotes.org

module Spec # :nodoc:
  module Rails
    module Matchers
      
      class AssertSelect
        def initialize(*args, &block)
          @message = args.shift
          @spec_scope = args.shift
          @args = args
          @block = block
        end
        def matches?(response, &block)
          @block = block if block
          begin
            @spec_scope.send(@message, *@args, &@block)
          rescue Exception => @error
          end
          @error.nil?
        end
        def failure_message
          @error.message
        end
        def negative_failure_message
          "negative_failure_message"
        end
        def description
          "description"
        end
      end
      
      # wrapper for assert_select
      # see documentation for assert_select
      def have_tag(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select)
        AssertSelect.new(*args, &block)
      end
    
      # wrapper for assert_select
      # syntactic sugar for nesting
      #
      #   response.should have_tag("div#1") do
      #     with_tag("span", "some text")
      #   end
      #
      # see documentation for assert_select
      def with_tag(*args, &block)
        response.should have_tag(*args, &block)
      end
    
      # wrapper for assert_select with false
      # syntactic sugar for nesting
      #
      #   response.should have_tag("div#1") do
      #     without_tag("span", "some text")
      #   end
      #
      # see documentation for assert_select
      def without_tag(*args, &block)
        response.should_not have_tag(*args, &block)
      end
    
      # wrapper for assert_select_rjs
      #
      # see documentation for assert_select_rjs
      def have_rjs(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_rjs)
        AssertSelect.new(*args, &block)
      end
      
      # wrapper for assert_select_feed
      #
      # see documentation for assert_select_feed
      def be_feed(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_feed)
        AssertSelect.new(*args, &block)
      end
      
      # wrapper for assert_select_email
      #
      # see documentation for assert_select_email
      def send_email(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_email)
        AssertSelect.new(*args, &block)
      end
      
      # wrapper for assert_select_encoded
      #
      # see documentation for assert_select_encoded
      def with_encoded(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_encoded)
        response.should AssertSelect.new(*args, &block)
      end
    end
  end
end