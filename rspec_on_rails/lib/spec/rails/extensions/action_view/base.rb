require 'spec/mocks/proxy'

module ActionView #:nodoc:
  class Base #:nodoc:
    cattr_accessor :base_view_path
    def render_partial(partial_path, local_assigns = nil, deprecated_local_assigns = nil) #:nodoc:
      if partial_path.is_a?(String)
        unless partial_path.include?("/")
          unless self.class.base_view_path.nil?
            partial_path = "#{self.class.base_view_path}/#{partial_path}"
          end
        end
      end
      super(partial_path, local_assigns, deprecated_local_assigns)
    end
    
    # unofficial and in progress - use at your own risk
    def expect_render(opts={})
      expect_render_mock_proxy.should_receive(:render, :expected_from => caller(1)[0]).with(opts)
      register_verify_after_each
    end
    
    # unofficial and in progress - use at your own risk
    def stub_render(opts={})
      expect_render_mock_proxy.should_receive(:render, :expected_from => caller(1)[0]).with(opts).any_number_of_times
    end
    
    # unofficial and in progress - use at your own risk
    def verify_rendered_proc
      template = self
      @verify_rendered_proc ||= Proc.new do
        template.verify_rendered
        template.unregister_verify_after_each
      end
    end
    
    # unofficial and in progress - use at your own risk
    def register_verify_after_each
      proc = verify_rendered_proc
      Spec::DSL::Behaviour.after(:each, &proc)
    end
    
    # unofficial and in progress - use at your own risk
    def unregister_verify_after_each
      proc = verify_rendered_proc
      Spec::DSL::Behaviour.remove_after(:each, &proc)
    end

    # unofficial and in progress - use at your own risk
    def verify_rendered
      expect_render_mock_proxy.rspec_verify
    end
    
    # unofficial and in progress - use at your own risk
    def expect_render_mock_proxy
      @expect_render_mock_proxy ||= lambda do
        Spec::Mocks::Proxy.new(proxy = Object.new, "expect_render_mock_proxy")
        proxy.stub!(:render)
        proxy
      end.call
    end

    alias_method :orig_render, :render
    def render(options = {}, old_local_assigns = {}, &block)
      if (Hash === options)
        expect_render_mock_proxy.render(options)
      end
      unless expect_render_mock_proxy.send(:__mock_proxy).send(:find_matching_expectation, :render, options)
        orig_render(options, old_local_assigns, &block)
      end
    end
  end
end
