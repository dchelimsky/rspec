module Spec
  module Extensions
    module Main
      # Creates and registers an instance of a Spec::DSL::Example (or a subclass).
      # The instantiated behaviour class depends on the directory of the file
      # calling this method. For example, Spec::Rails will use different
      # classes for specs living in <tt>spec/models</tt>, <tt>spec/helpers</tt>, 
      # <tt>spec/views</tt> and <tt>spec/controllers</tt>.
      #
      # It is also possible to override autodiscovery of the behaviour class 
      # with an options Hash as the last argument:
      #
      #   describe "name", :behaviour_type => :something_special do ...
      #
      # The reason for using different behaviour classes is to have
      # different matcher methods available from within the <tt>describe</tt>
      # block.
      #
      # See Spec::DSL::ExampleFactory#register for details about
      # how to register special Spec::DSL::Example implementations.
      #
      def describe(*args, &block)
        raise ArgumentError if args.empty?
        raise ArgumentError unless block
        args << {} unless Hash === args.last
        args.last[:spec_path] = caller(0)[1]
        behaviour = Spec::DSL::BehaviourFactory.create(*args, &block)
        behaviour.register
        behaviour
      end
      alias :context :describe
      
      def run_story(*args, &block)
        runner = Spec::Story::Runner::PlainTextStoryRunner.new(*args)
        runner.instance_eval(&block) if block
        runner.run
      end
      
      def steps_for(tag, &block)
        steps = rspec_story_steps[tag]
        steps.instance_eval(&block) if block
        steps
      end
      
      def with_steps_for(tag, &block)
        steps = Spec::Story::StepGroup.new
        steps << rspec_story_steps[tag]
        steps.instance_eval(&block) if block
        steps
      end

    private
    
      def rspec_story_steps
        $rspec_story_steps ||= step_group_hash
      end
      
      def step_group_hash
        Hash.new do |h,k|
          h[k] = Spec::Story::StepGroup.new
        end
      end
    
      def rspec_options
        $rspec_options ||= begin; \
          parser = ::Spec::Runner::OptionParser.new(STDERR, STDOUT); \
          parser.order!(ARGV); \
          $rspec_options = parser.options; \
        end
        $rspec_options
      end
      
      def init_rspec_options(options)
        $rspec_options = options if $rspec_options.nil?
      end
    end
  end
end

include Spec::Extensions::Main