module Spec
  module Rails
    module Runner
      class BehaviourFactory

        class << self

          BEHAVIOUR_CLASSES = {
            :view       => Spec::Rails::DSL::ViewBehaviour,
            :helper     => Spec::Rails::DSL::HelperBehaviour,
            :controller => Spec::Rails::DSL::ControllerBehaviour,
            :model      => Spec::Rails::DSL::ModelBehaviour,
            :default    => Spec::DSL::Behaviour
          }

          # Kernel#describe calls this to create the appropriate extension of
          # Spec::DSL::Behaviour for Model, View, Controller and Helper behaviours.
          # In the spirit of Rails' convention
          # over configuration, putting the spec files in the right directory
          # will cause the BehaviourFactory to do the right thing:
          #
          #   spec/controllers => ControllerBehaviour
          #   spec/helpers => HelperBehaviour
          #   spec/models => ModelBehaviour
          #   spec/views => ViewBehaviour
          #
          # If you prefer or need configuration, you can use the options Hash submitted
          # to create as follows:
          # 
          #   describe "name", :behaviour_type => :controller do ...
          #   describe "name", :behaviour_type => :helper do ...
          #   describe "name", :behaviour_type => :model do ...
          #   describe "name", :behaviour_type => :view ...
          def create(*args, &block)
            opts = Hash === args.last ? args.last : {}
            if opts[:behaviour_type]
              key = opts[:behaviour_type]
            elsif opts[:spec_path] =~ /spec(\/|\\)+(view|helper|controller|model)s/
              key = $2.to_sym
            else
              key = :default
            end
            return BEHAVIOUR_CLASSES[key].new(*args, &block)
          end
          
        end
        
      end
    end
  end
end