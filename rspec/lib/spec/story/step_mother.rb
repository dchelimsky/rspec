module Spec
  module Story
    class StepMother
      def initialize
        @steps = Hash.new do |hsh,type|
          hsh[type] = Hash.new do |hsh,name|
            if step_group and step = step_group.find(type, name)
              step
            else
              SimpleStep.new(name) do
                raise Spec::DSL::ExamplePendingError.new("Unimplemented step: #{name}")
              end
            end
          end
        end
      end
      
      def use(step_group)
        @step_group = step_group
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

      private
        def step_group
          @step_group
        end
      
    end
  end
end
