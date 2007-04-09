module Kernel
  def describe(*args, &block)
    behaviour_runner.add_behaviour(
      Spec::DSL::Behaviour.new(Spec::DSL::Describable.new(*args), &block)
    )
  end
  alias :context :describe
  
  def respond_to(*names)
    Spec::Matchers::RespondTo.new(*names)
  end
  
private

  def behaviour_runner
    # TODO: Figure out a better way to get this considered "covered" and keep this statement on multiple lines 
    unless $behaviour_runner; \
      $behaviour_runner = ::Spec::Runner::OptionParser.new.create_behaviour_runner(ARGV.dup, STDERR, STDOUT, false); \
      at_exit { $behaviour_runner.run(nil, false) }; \
    end
    $behaviour_runner
  end
end
