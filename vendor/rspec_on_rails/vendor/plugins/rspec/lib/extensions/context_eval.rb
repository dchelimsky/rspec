module Spec
  module Runner
    module ContextEval
      module RailsPluginModuleMethods

        def controller_name(name=nil)
          @controller_name = name if name
          @controller_name
        end

        def helper(name, &block)
          self.class.helper(name, &block)
        end

        def self.helper(name, &block)
          Spec::Runner::ExecutionContext.send :define_method, name.to_sym, &block
        end
        
      end

      ModuleMethods.class_eval do
        include RailsPluginModuleMethods
      end
      
      module RailsPluginInstanceMethods
        attr_reader :response, :request, :controller

        def setup_with_controller(controller_name=nil)
          return unless controller_name

          @controller_class = "#{controller_name}_controller".camelize.constantize
          raise "Can't determine controller class for #{self.class}" if @controller_class.nil?
          @controller_class.send(:define_method, :rescue_action) { |e| raise e }

          @controller = @controller_class.new

          @flash = ActionController::Flash::FlashHash.new

          @session = ActionController::TestSession.new
          @session['flash'] = @flash

          @request = ActionController::TestRequest.new
          @request.session = @session

          @response = ActionController::TestResponse.new

          @deliveries = []
          ActionMailer::Base.deliveries = @deliveries

          # used by util_audit_assert_assigns
          @assigns_asserted = []
          @assigns_ignored ||= [] # untested assigns to ignore
        end

        def teardown_with_controller
        end

        def tag(*opts)
          opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
          tag = find_tag(opts)
        end
        
      end

      InstanceMethods.class_eval do
        include RailsPluginInstanceMethods
      end
      
    end
  end
end


