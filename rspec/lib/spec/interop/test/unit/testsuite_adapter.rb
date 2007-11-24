module Test
  module Unit
    
    class TestSuiteAdapter < Spec::Example::ExampleSuite
      alias_method :rspec_run, :run
      def run(*args)
        return true unless args.empty?
        rspec_run
      end
    end

  end
end

