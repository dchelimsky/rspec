require 'test/unit/ui/console/testrunner'

module Test
  module Unit
    module UI
      module Console
        class TestRunner
          alias_method :test_finished_without_rspec, :test_finished
          def test_finished_with_rspec(name)
            test_finished_without_rspec(name)
            @ran_test = true
          end
          alias_method :test_finished, :test_finished_with_rspec

          alias_method :finished_without_rspec, :finished
          def finished_with_rspec(elapsed_time)
            if @ran_test
              finished_without_rspec(elapsed_time)
            end
          end
          alias_method :finished, :finished_with_rspec
        end
      end
    end
  end
end
