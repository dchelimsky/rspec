module Test
  module Unit
    
    # TODO - mid-refactoring - looking to eliminate ExampleSuite,
    # so this will be a pure adapter between TestSuite and ExampleGroup
    class TestSuiteAdapter < Spec::Example::ExampleSuite
      alias_method :rspec_run, :run
      def run(*args)
        return true unless args.empty?
        rspec_run
      end
    end

  end
end

