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
      
      def assign_steps_to(assignee)
        assignee.use(@params[:steps]) if @params[:steps]
        assignee.use(steps_for_key) if @params[:steps_for]
      end
      
      def steps_for_key
        $rspec_story_steps[@params[:steps_for]]
      end
    end
  end
end
