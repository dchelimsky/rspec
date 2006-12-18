module Spec
  module Rails
    class RenderMatcher
      
      def initialize(controller_path=nil, integrate_views=false)
        @controller_path = controller_path
        @integrate_views = integrate_views
        @should_render_called = false
      end
      
      def set_expected(expected, &block)
        if @performed_render
          verify_rendered(expected, @options)
          return
        end
        should_render_called
        @mock = Spec::Mocks::Mock.new("controller")
        @mock.should_receive(
          :render, 
          :expected_from => caller(0)[2],
          :message => "controller expected call to render #{expected.inspect} but it was never received"
        ).with(expected)
        @options = expected
        @block = block
      end

      def set_actual(actual, response=nil, &block)
        @response = response
        @performed_render = true
        if should_render_called?
          @mock.__reset_mock
          verify_rendered(@options, actual)
        else
          @options = actual
          @block = block
        end
      end

      def should_render_rjs(element, *args)
        # NOTE - this only works right now for post-action expectations
        # NOTE - the first branch of the following conditional is here to
        # handle expectations with partials:
        #   controller.should_render_rjs element, :partial => 'path/to/partial'
        # This is a LOT of noise and could probably be implemented more simply
        # and directly by intercepting the call to @context.render on line 647
        # of prototype_helper.rb in actionpack (1.12.5)
        if args.last.is_a?(Hash)
          page = Spec::Mocks::Mock.new("page", :null_object => true, :auto_verify => false)
          if element == :page
            page_element = Spec::Mocks::Mock.new("element", :null_object => true, :auto_verify => false)
            page.should_receive(:[]).with(args.shift).and_return(page_element)
            page_element.should_receive(args.shift).with(*args)
          else
            page.should_receive(element).with(*args)
          end
          __verify_block @block, page, page_element
        else
          @response.should_have_rjs(element, *args)
        end
      end

      def should_not_render_rjs(element, *args)
        #NOTE - see NOTE in should_render_rjs above
        if args.last.is_a?(Hash)
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
        else
          @response.should_not_have_rjs(element, *args)
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
      
      def should_render_called?
        @should_render_called
      end
      
      def should_render_called
        @should_render_called = true
      end

      def verify_rendered(expected, actual)
        if actual.is_a?(Hash)
          if (content_type = actual[:content_type]) && (action = actual[:action])
            if content_type == "text/html" || content_type == "text/javascript"
              actual = {:template => "#{@controller_path}/#{action}"}
            end
          # Rails 1.1.6 - content_type isn't passed in when
          # you make an xhr request
          elsif (action = actual[:action]) =~ /\.rjs$/
            actual = {:template => "#{@controller_path}/#{action}"}
          end
        end
        actual.should == expected
      end
    end
  end
end

