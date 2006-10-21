module Kernel
  def context(name, &block)
    context = Spec::Runner::Context.new(name, &block)
    runner = context_runner
    runner.add_context(context)
  end
  
private
  
  def context_runner
    if $context_runner.nil?; $context_runner = ::Spec::Runner::OptionParser.create_context_runner(ARGV.dup, true, STDERR, STDOUT); at_exit { $context_runner.run(false) }; end
    $context_runner
  end
end
