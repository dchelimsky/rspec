module Spec
  module Rails
    class RenderMatcher
      
      def set_expectation(options, &block)
        @mock = Spec::Mocks::Mock.new("controller")
        @mock.should_receive(:match_render_call, :expected_from => caller(0)[2]).with(options)
        @options = options
        @block = block
      end

      def set_rendered(options, &block)
        if @options #implies set_expectation called first
          @mock.__reset_mock
          match(options)
        else
          @options = options
          @block = block
        end
      end

      def verify_rendered(expected)
        @options.should == expected
      end
      
      #TODO - rename to verify_rendered
      def match(expected)
        @options.should == expected
      end
      
      def should_render_rjs(element, *args)
        page = Spec::Mocks::Mock.new("page", :null_object => true, :auto_verify => false)
        if element == :page
          page_element = Spec::Mocks::Mock.new("element", :null_object => true, :auto_verify => false)
          page.should_receive(:[]).with(args.shift).and_return(page_element)
          page_element.should_receive(args.shift).with(*args)
        else
          page.should_receive(element).with(*args)
        end
        __verify_block @block, page, page_element
      end

      def should_not_render_rjs(element, *args)
        page = Spec::Mocks::Mock.new("page", :null_object => true, :auto_verify => false)
        if element == :page
          element_name = args.shift
          @block.call(page)
          if page.received_message?(:[], element_name)
            page_element = Spec::Mocks::Mock.new(element_name, :null_object => true, :auto_verify => false)
            page.should_receive(:[]).with(element_name).and_return(page_element)
            page_element.should_not_receive(args.shift).with(*args)
            __verify_block @block, page, page_element
          end
        else
          page.should_not_receive(element).with(*args)
          __verify_block @block, page
        end
      end
      
      private
      def __verify_block(block, page, page_element=nil)
        begin
          block.call(page)
        rescue
        end
        begin
          page.__verify
          page_element.__verify unless page_element.nil?
        rescue => e
          raise Spec::Expectations::ExpectationNotMetError.new(e.message)
        end
      end
    end
  end
end
