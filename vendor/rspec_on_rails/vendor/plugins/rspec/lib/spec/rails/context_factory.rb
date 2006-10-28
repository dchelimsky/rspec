module Spec
  module Rails
    class ContextFactory
      class << self
        def create(*args, &block)
          spec_path = args.last.is_a?(Hash) ? args.last[:spec_path] : nil
          context_type = args.last.is_a?(Hash) ? args.last[:context_type] : nil
          if (spec_path =~ /\/spec\/+views/) || (context_type == :view)
            return Spec::Rails::ViewContext.new(args[0], &block)
          elsif (spec_path =~ /\/spec\/+helpers/) || (context_type == :helper)
            return Spec::Rails::HelperContext.new(args[0], &block)
          elsif (spec_path =~ /\/spec\/+controllers/) || (context_type == :controller)
            return Spec::Rails::ControllerContext.new(args[0], &block)
          elsif (spec_path =~ /\/spec\/+integration/) || (context_type == :integration)
            return Spec::Rails::IntegrationContext.new(args[0], &block)
          else
            return Spec::Rails::ModelContext.new(args[0], &block)
          end
        end
      end
    end
  end
end