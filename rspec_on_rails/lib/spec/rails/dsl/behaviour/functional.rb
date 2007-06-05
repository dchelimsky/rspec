module Spec
  module Rails
    module DSL
      module FunctionalBehaviourHelpers
        class << self
          def included(mod)
            mod.send :include, ExampleMethods
            mod.send :extend, BehaviourMethods
          end
        end
        
        module BehaviourMethods
          # You MUST provide a controller_name within the context of
          # your controller specs:
          #
          #   describe "ThingController" do
          #     controller_name :thing
          #     ...
          def controller_name(name=nil)
            @controller_class_name = "#{name}_controller".camelize
          end
        end
        
        module ExampleMethods
          # :call-seq:
          #   assigns()
          #
          # Hash of instance variables to values that are made available to views.
          # == Examples
          #
          #   #in thing_controller.rb
          #   def new
          #     @thing = Thing.new
          #   end
          #
          #   #in thing_controller_spec
          #   get 'new'
          #   assigns[:registration].should == Thing.new
          #--
          # NOTE - Even though docs say only use assigns[:key] format, but allowing assigns(:key)
          # in order to avoid breaking old specs.
          #++
          def assigns(key = nil)
            if key.nil?
              @controller.assigns
              _controller_ivar_proxy
            else
              @controller.assigns[key]
              _controller_ivar_proxy[key]
            end
          end

        protected
          def _controller_ivar_proxy
            @controller_ivar_proxy ||= IvarProxy.new @controller 
          end
        end
      end

      class FunctionalEvalContext < Spec::Rails::DSL::EvalContext
        include Spec::Rails::DSL::FunctionalBehaviourHelpers
        attr_reader :request, :response
        
        def setup #:nodoc:

          @controller_class = Object.path2class @controller_class_name
          raise "Can't determine controller class for #{@controller_class_name}" if @controller_class.nil?

          @controller = @controller_class.new
        
          @request = ActionController::TestRequest.new
          @response = ActionController::TestResponse.new
        end
        
        def params
          request.parameters
        end
        
        def flash
          response.flash
        end
        
        def session
          request.session
        end
        
      end
    end
  end
end
