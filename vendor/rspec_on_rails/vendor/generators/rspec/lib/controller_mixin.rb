require 'rexml/document'

module Spec
  module ControllerContext
    def self.included(base)
      super
      base.send :include, Spec::ControllerContext::InstanceMethods
    end

    module InstanceMethods
      def controller_name(name=nil)
        @controller_name = name if name
        @controller_name
      end

    end
  end

  module ControllerExecution

    def self.included(base)
      super
      base.send :include, Spec::ControllerExecution::InstanceMethods
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

      def assigns(key = nil) 
        if key.nil? 
          @response.template.assigns 
        else 
          @response.template.assigns[key.to_s] 
        end 
      end 


      ##
      # Excutes the request +action+ with +params+.
      #
      # See also: get, post, put, delete, head, xml_http_request

      def process(action, parameters = nil)
        parameters ||= {}

        @request.recycle!
        @request.env['REQUEST_METHOD'] ||= 'GET'
        @request.action = action.to_s

        @request.assign_parameters @controller_class.controller_path, action.to_s,
                                   parameters

        build_request_uri action, parameters

        @controller.process @request, @response
      end

      ##
      # Performs a GET request on +action+ with +params+.

      def get(action, parameters = nil)
        @request.env['REQUEST_METHOD'] = 'GET'
        process action, parameters
      end

      ##
      # Performs a HEAD request on +action+ with +params+.

      def head(action, parameters = nil)
        @request.env['REQUEST_METHOD'] = 'HEAD'
        process action, parameters
      end

      ##
      # Performs a POST request on +action+ with +params+.

      def post(action, parameters = nil)
        @request.env['REQUEST_METHOD'] = 'POST'
        process action, parameters
      end

      ##
      # Performs a PUT request on +action+ with +params+.

      def put(action, parameters = nil)
        @request.env['REQUEST_METHOD'] = 'PUT'
        process action, parameters
      end

      ##
      # Performs a DELETE request on +action+ with +params+.

      def delete(action, parameters = nil)
        @request.env['REQUEST_METHOD'] = 'DELETE'
        process action, parameters
      end

      def xml_document
        @xml_document ||= REXML::Document.new(@response.body)
      end

      def xml_tags(xpath)
        xml_document.elements.to_a(xpath)
      end

      def xml_attrs(xpath)
        xml_document.elements.to_a(xpath).first.attributes
      end

      def xml_text(xpath)
        xml_document.elements.to_a(xpath).first.text.to_s
      end

      private

      def build_request_uri(action, parameters)
        return if @request.env['REQUEST_URI']

        options = @controller.send :rewrite_options, parameters
        options.update :only_path => true, :action => action

        url = ActionController::UrlRewriter.new @request, parameters
        @request.set_REQUEST_URI url.rewrite(options)
      end 

    end
  end
end
