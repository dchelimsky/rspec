module Spec
  module Rails
    module Runner
      class FunctionalEvalContext < Spec::Rails::Runner::EvalContext
        attr_reader :session, :flash, :request, :response, :params
        def setup #:nodoc:
          super

          @controller_class = Object.path2class @controller_class_name
          raise "Can't determine controller class for #{@controller_class_name}" if @controller_class.nil?

          @controller = @controller_class.new
        
          @session = ActionController::TestSession.new
          @flash = ActionController::Flash::FlashHash.new
          @request = ActionController::TestRequest.new
          @response = ActionController::TestResponse.new
          @params = Hash.new

          @session['flash'] = @flash
          @request.session = @session

          setup_extra if respond_to? :setup_extra
        end      

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
            _controller_ivar_proxy
          else
            _controller_ivar_proxy[key]
          end
        end
      
        private
        def _controller_ivar_proxy
          @controller_ivar_proxy ||= Spec::Rails::Expectations::IvarProxy.new @controller 
        end
      end
    end
  end
end
