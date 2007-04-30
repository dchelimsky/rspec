Spec::DSL::BehaviourFactory.add_behaviour_class(:view, Spec::Rails::DSL::ViewBehaviour)
Spec::DSL::BehaviourFactory.add_behaviour_class(:helper, Spec::Rails::DSL::HelperBehaviour)
Spec::DSL::BehaviourFactory.add_behaviour_class(:controller, Spec::Rails::DSL::ControllerBehaviour)
Spec::DSL::BehaviourFactory.add_behaviour_class(:model, Spec::Rails::DSL::ModelBehaviour)

module Spec
  module DSL
    class BehaviourFactory

      class << self

        alias_method :original_create, :create

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
          if opts[:shared]
            key = :default
          elsif opts[:behaviour_type]
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