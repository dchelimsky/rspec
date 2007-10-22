module Spec
  module Story
    class Story
      attr_reader :title, :narrative
      
      def initialize(title, narrative, params = {}, &body)
        @body = body
        @title = title
        @narrative = narrative
        @params = params
      end
      
      def [](key)
        @params[key]
      end
      
      def run_in(obj)
        obj.instance_eval(&@body)
      end
      
      def assign_step_matchers_to(assignee)
        assignee.use(@params[:step_matchers])
      end
    end
  end
end
