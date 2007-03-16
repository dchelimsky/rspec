module Kernel
  def context(type_or_description, additional_description=nil, &block)
    description = "#{type_or_description.to_s}"
    description += " #{additional_description}" unless additional_description.nil?
    context_runner.add_context(Spec::DSL::BehaviourOf.new(description, &block))
  end
  alias :describe :context
  
private

  def context_runner
    # TODO: Figure out a better way to get this considered "covered" and keep this statement on multiple lines 
    unless $context_runner; \
      $context_runner = ::Spec::Runner::OptionParser.new.create_context_runner(ARGV.dup, STDERR, STDOUT, false); \
      at_exit { $context_runner.run(nil, false) }; \
    end
    $context_runner
  end
end
