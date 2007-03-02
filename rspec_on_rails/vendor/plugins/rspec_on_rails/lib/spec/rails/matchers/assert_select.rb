# This is a wrapper of assert_select for rspec.

module Spec # :nodoc:
  module Rails
    module Matchers
      
      class AssertSelect #:nodoc:
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
          "should_not #{description}, but did"
        end
        
        def description
          {
            :assert_select => "have_tag#{format_args(*@args)}",
            :assert_select_email => "send_email#{format_args(*@args)}",
          }[@message]
        end
        
        private
          def format_args(*args)
            return "" if args.empty?
            return "(#{arg_list(*args)})"
          end
          def arg_list(*args)
            args.collect do |arg|
              arg.respond_to?(:description) ? arg.description : arg.inspect
            end.join(", ")
          end
      end
      
      # :call-seq:
      #   response.should have_tag(*args, &block)
      #
      # wrapper for assert_select
      #
      # see documentation for assert_select at http://api.rubyonrails.org/
      def have_tag(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select)
        AssertSelect.new(*args, &block)
      end
    
      # wrapper for a nested assert_select
      #
      #   response.should have_tag("div#1") do
      #     with_tag("span", "some text")
      #   end
      #
      # see documentation for assert_select at http://api.rubyonrails.org/
      def with_tag(*args, &block)
        response.should have_tag(*args, &block)
      end
    
      # wrapper for a nested assert_select with false
      #
      #   response.should have_tag("div#1") do
      #     without_tag("span", "some text that shouldn't be there")
      #   end
      #
      # see documentation for assert_select at http://api.rubyonrails.org/
      def without_tag(*args, &block)
        response.should_not have_tag(*args, &block)
      end
    
      # :call-seq:
      #   response.should have_rjs(*args, &block)
      #
      # wrapper for assert_select_rjs
      #
      # see documentation for assert_select_rjs at http://api.rubyonrails.org/
      def have_rjs(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_rjs)
        AssertSelect.new(*args, &block)
      end
      
      # :call-seq:
      #   response.should be_feed(*args, &block)
      #
      # wrapper for assert_select_feed
      #
      # see documentation for assert_select_feed at http://api.rubyonrails.org/
      def be_feed(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_feed)
        AssertSelect.new(*args, &block)
      end
      
      # :call-seq:
      #   response.should send_email(*args, &block)
      #
      # wrapper for assert_select_email
      #
      # see documentation for assert_select_email at http://api.rubyonrails.org/
      def send_email(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_email)
        AssertSelect.new(*args, &block)
      end
      
      # wrapper for assert_select_encoded
      #
      # see documentation for assert_select_encoded at http://api.rubyonrails.org/
      def with_encoded(*args, &block)
        args.unshift(self)
        args.unshift(:assert_select_encoded)
        response.should AssertSelect.new(*args, &block)
      end
    end
  end
end