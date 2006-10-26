require 'spec/runner/formatter/base_text_formatter'

# Example of a custom formatter. Run me with:
# bin/spec examples -r examples/custom_formatter.rb -f CustomFormatter
# bin/spec failing_examples -r examples/custom_formatter.rb -f CustomFormatter
class CustomFormatter < Spec::Runner::Formatter::BaseTextFormatter
  def add_context(name, first)
    @output.print "\n" if first
  end
  
  def spec_failed(name, counter, failure)
    @output.print 'X'
  end
  
  def spec_passed(name)
    @output.print '_'
  end
  
  def start_dump
    @output.print "\n"
  end
end
