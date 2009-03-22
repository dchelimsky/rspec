module Spec
  module Runner
    module Formatter
      # Formatter base-class, which implements all required methods.
      # Almost all of the implementations are no-ops, with the exception
      # of +add_example_group+ (see below).
      class BaseFormatter
        attr_accessor :example_group, :options, :where
        def initialize(options, where)
          @options = options
          @where = where
        end
        
        # This method is invoked before any examples are run, right after
        # they have all been collected. This can be useful for special
        # formatters that need to provide progress on feedback (graphical ones)
        #
        # This method will only be invoked once, and the next one to be invoked
        # is #add_example_group
        def start(example_count)
        end

        # This method is invoked at the beginning of the execution of each example_group.
        # +example_group_proxy+ is an instance of Spec::Example::ExampleGroupProxy, and
        # is assigned as the value returned by subsequent calls to +example_group()+
        #
        # The next method to be invoked after this is #example_started
        def add_example_group(example_group_proxy)
          @example_group = example_group_proxy
        end

        # This method is invoked when an +example+ starts.
        # +example_proxy+ is an instance of Spec::Example::ExampleProxy
        #
        # The next method to be invoked after this is #example_passed, #example_failed,
        # or #example_pending
        def example_started(example_proxy)
        end

        # This method is invoked when an +example+ passes.
        # +example_proxy+ is the same instance of Spec::Example::ExampleProxy
        # that was passed to example_started
        def example_passed(example_proxy)
        end

        # This method is invoked when an +example+ fails, i.e. an exception occurred
        # inside it (such as a failed should or other exception). +counter+ is the 
        # sequence number of the failure (starting at 1) and +failure+ is the associated 
        # Failure object.
        # +example_proxy+ is the same instance of Spec::Example::ExampleProxy
        # that was passed to example_started
        def example_failed(example_proxy, counter, failure)
        end
        
        # This method is invoked when an example is not yet implemented (i.e. has not
        # been provided a block), or when an ExamplePendingError is raised.
        # +message+ is the message from the ExamplePendingError, if it exists, or the
        # default value of "Not Yet Implemented"
        # +pending_caller+ is the file and line number of the spec which
        # has called the pending method
        # +example_proxy+ is the same instance of Spec::Example::ExampleProxy
        # that was passed to example_started
        def example_pending(example_proxy, message, pending_caller)
        end

        # This method is invoked after all of the examples have executed. The next method
        # to be invoked after this one is #dump_failure (once for each failed example),
        def start_dump
        end

        # Dumps detailed information about an example failure.
        # This method is invoked for each failed example after all examples have run. +counter+ is the sequence number
        # of the associated example. +failure+ is a Failure object, which contains detailed
        # information about the failure.
        def dump_failure(counter, failure)
        end
      
        # This method is invoked after the dumping of examples and failures.
        def dump_summary(duration, example_count, failure_count, pending_count)
        end
        
        # This gets invoked after the summary if option is set to do so.
        def dump_pending
        end

        # This method is invoked at the very end. Allows the formatter to clean up, like closing open streams.
        def close
        end
      end
    end
  end
end
