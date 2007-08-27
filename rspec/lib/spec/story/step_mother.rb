module Spec
  module Story
    class StepMother
      def initialize
        @steps = Hash.new do |hsh,key|
          hsh[key] = Hash.new do |hsh,key|
            raise UnknownStepException, key
          end
        end
      end
      
      def store(type, name, step)
        @steps[type][name] = step
      end
      
      def find(type, name)
        @steps[type][name]
      end
    end
  end
end
