module Kernel
  def describe(type_or_description, additional_description=nil, &block)
    description = "#{type_or_description.to_s}"
    description += "#{additional_description}" unless additional_description.nil?
    behaviour_runner.add_behaviour(Spec::DSL::Behaviour.new(description, &block))
  end
  alias :context :describe
  
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
