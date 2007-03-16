module Spec
  module Rails
    module Runner
      class ContextFactory

        class << self
          # Kernel#context calls this to create the appropriate extension of
          # Spec::DSL::Behaviour for Model, View, Controller and Helper specs.
          # In the spirit of Rails' convention
          # over configuration, putting the spec files in the right directory
          # will cause the ContextFactory to do the right thing:
          #
          #   spec/controllers => ControllerContext
          #   spec/helpers => HelperContext
          #   spec/models => ModelContext
          #   spec/views => ViewContext
          #
          # If you prefer or need configuration, you can use the options Hash submitted
          # to create as follows:
          # 
          #   context "name", :context_type => :controller do ...
          #   context "name", :context_type => :helper do ...
          #   context "name", :context_type => :model do ...
          #   context "name", :context_type => :view ...
          def create(*args, &block)
            spec_path = args.last.is_a?(Hash) ? args.last[:spec_path] : nil
            context_type = args.last.is_a?(Hash) ? args.last[:context_type] : nil
            if (spec_path =~ /spec(\/|\\)+views/) || (context_type == :view)
              return Spec::Rails::Runner::ViewContext.new(args[0], &block)
            elsif (spec_path =~ /spec(\/|\\)+helpers/) || (context_type == :helper)
              return Spec::Rails::Runner::HelperContext.new(args[0], &block)
            elsif (spec_path =~ /spec(\/|\\)+controllers/) || (context_type == :controller)
              return Spec::Rails::Runner::ControllerContext.new(args[0], &block)
            elsif (spec_path =~ /spec(\/|\\)+models/) || (context_type == :model)
              return Spec::Rails::Runner::ModelContext.new(args[0], &block)
            else
              return Spec::DSL::BehaviourOf.new(args[0], &block)
            end
          end
        end
      end
    end
  end
end