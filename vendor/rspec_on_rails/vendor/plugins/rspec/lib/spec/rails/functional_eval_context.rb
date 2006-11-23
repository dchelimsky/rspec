module Spec
  module Rails
    class FunctionalEvalContext < Spec::Rails::EvalContext
      attr_reader :session
      def setup
        super

        @controller_class = Object.path2class @controller_class_name
        raise "Can't determine controller class for #{@controller_class_name}" if @controller_class.nil?

        @controller = @controller_class.new

        @session = ActionController::TestSession.new

        @flash = ActionController::Flash::FlashHash.new
        @session['flash'] = @flash

        @request = ActionController::TestRequest.new
        @request.session = @session

        @response = ActionController::TestResponse.new

        setup_extra if respond_to? :setup_extra
      end

      # Docs say only use assigns[:key] format, but allowing assigns(:key)
      # in order to avoid breaking old specs.
      def assigns(key = nil)
        if key.nil?
          _controller_ivar_proxy
        else
          _controller_ivar_proxy[key]
        end
      end
      
      private
      def _controller_ivar_proxy
        @controller_ivar_proxy ||= Spec::Rails::IvarProxy.new @controller 
      end
    end
  end
end

