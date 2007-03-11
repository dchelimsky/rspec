module Kernel
  def context(type_or_description, &block)
    context_runner.add_context(Spec::Runner::Context.new(type_or_description.to_s, &block))
  end
  alias :describe :context

private

  def context_runner
    # TODO: Figure out a better way to get this considered "covered" and keep this statement on multiple lines 
    unless $context_runner; \
      $context_runner = ::Spec::Runner::OptionParser.new.create_context_runner(ARGV.dup, STDERR, STDOUT, false); \
      at_exit { $context_runner.run(false) }; \
    end
    $context_runner
  end
end
