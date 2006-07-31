require 'application'

silence_warnings { RAILS_ENV = "test" }

require 'active_record/base'
require 'active_record/fixtures'
require 'action_controller/test_process'
require 'action_controller/integration'
require 'spec'

module Spec
  module Runner

    class ExecutionContext
      include Spec::ControllerExecution
      include ActionController::TestProcess

      def tag(*opts)
        opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
        tag = find_tag(opts)
      end
    end

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

    class Context
      module RailsPluginClassMethods
        def fixture_path
          @fixture_path ||= RAILS_ROOT + '/spec/fixtures'
        end
        attr_writer :fixture_path
      end
      extend RailsPluginClassMethods

      # entry point into rspec
      # Keep it sync'ed!
      super_run = instance_method(:run)
      define_method :run do |reporter, dry_run|
        controller_name = @context_eval_module.instance_eval {@controller_name}

        setup_method = proc do
          setup_with_controller(controller_name)
        end
        setup_parts.unshift setup_method

        teardown_method = proc do
          teardown_with_controller
        end
        teardown_parts.unshift teardown_method
        super_run.bind(self).call(reporter, dry_run)
      end
    end # Context

  end
end

module ActionController
  class TestResponse
    def should_render(expected=nil)
      expected = expected.to_s unless expected.nil?
      rendered = expected ? rendered_file(!expected.include?('/')) : rendered_file
      expected.should_equal rendered
    end
  end
end

class String
  def should_have_tag(*opts)
    opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
    begin
      HTML::Document.new(self).find(opts).should_not_be_nil
    rescue
      self.should_include opts.inspect
    end
  end
end

NilClass.sugarize_for_rspec!