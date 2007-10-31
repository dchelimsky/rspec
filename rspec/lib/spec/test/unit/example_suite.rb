module Spec
  module DSL
    class ExampleSuite
      alias_method :rspec_run, :run
      def run(*args)
        return true unless args.empty? # Return if we are called from Test::Unit
        rspec_run
      end
    end
  end
end