module Spec
  module DSL
    class Configuration
      
      def mock_with(mock_framework)
        @mock_framework = case mock_framework
        when Symbol
          mock_framework_path(mock_framework.to_s)
        else
          mock_framework
        end
      end
      
      def mock_framework
        @mock_framework ||= mock_framework_path("rspec")
      end
      
      # Declares modules to be included in all behaviours (<tt>describe</tt> blocks).
      #
      #   config.include(My::Bottle, My::Cup)
      #
      # If you want to restrict the inclusion to a subset of all the behaviours then
      # specify this in a Hash as the last argument:
      #
      #   config.include(My::Pony, My::Horse, :behaviour_type => :farm)
      #
      # Only behaviours that have that type will get the modules included:
      #
      #   describe "Downtown", :behaviour_type => :city do
      #     # Will *not* get My::Pony and My::Horse included
      #   end
      #
      #   describe "Old Mac Donald", :behaviour_type => :farm do
      #     # *Will* get My::Pony and My::Horse included
      #   end
      #
      def include(*args)
        included_modules.push(*args)
      end
      
      def included_modules
        @included_modules ||= []
      end
      
      def predicate_matchers
        @predicate_matchers ||= {}
      end
      
    private
    
      def mock_framework_path(framework_name)
        File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "plugins", "mock_frameworks", framework_name))
      end
      
    end
  end
end