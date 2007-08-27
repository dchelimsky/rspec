module Spec
  module Story
    class Scenario
      attr_accessor :name, :body, :story
      
      def initialize(story, name, &body)
        raise ArgumentError, 'Scenario must have a body' unless block_given?
        @story = story
        @name = name
        @body = body
      end
    end
  end
end
