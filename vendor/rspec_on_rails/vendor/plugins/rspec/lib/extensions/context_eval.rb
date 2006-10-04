module Spec
  module Runner
    module ContextEval
      module ModuleMethods
        include Spec::ControllerContext

        def helper(name, &block)
          self.class.helper(name, &block)
        end

        def self.helper(name, &block)
          Spec::Runner::ExecutionContext.send :define_method, name.to_sym, &block
        end
      end

      module InstanceMethods
        attr_reader :response, :request, :controller

        def setup_with_controller(controller_name=nil)
          return unless controller_name

          @controller_class = "#{controller_name}_controller".camelize.constantize

          #@controller_class = Object.path2class @controller_class_name
          raise "Can't determine controller class for #{self.class}" if @controller_class.nil?

          @controller = @controller_class.new

          @session = ActionController::TestSession.new

          @flash = ActionController::Flash::FlashHash.new
          @session['flash'] = @flash

          @request = ActionController::TestRequest.new
          @request.session = @session

          @response = ActionController::TestResponse.new
          @controller_class.send(:define_method, :rescue_action) { |e| raise e }

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
    end
  end
end