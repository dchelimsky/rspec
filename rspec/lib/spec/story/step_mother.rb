module Spec
  module Story
    class StepMother
      def initialize
        @steps = Hash.new do |hsh,type|
          hsh[type] = Hash.new do |hsh,name|
            raise UnknownStepException, "No such step: #{type} #{name}"
          end
        end
      end
      
      def store(type, name, step)
        @steps[type][name] = step
      end
      
      def find(type, name)
        @steps[type][name]
      end
      
      def clear
        @steps.clear
      end
      
      def empty?
        @steps.empty?
      end
    end
  end
end
