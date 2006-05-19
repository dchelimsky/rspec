module Kernel
  def context(name, &block)
    context = Spec::Runner::Context.new(name, &block)
    runner = context_runner
    runner.add_context(context)
    runner.run(false) if runner.standalone
  end
  
private
  
  def context_runner
    $context_runner || ::Spec::Runner::OptionParser.create_context_runner(ARGV.dup, true, STDERR, STDOUT)
  end
end
