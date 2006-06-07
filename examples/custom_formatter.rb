require 'spec/runner/base_text_formatter'

# Example of a custom formatter. Run me with:
# bin/spec examples -r examples/custom_formatter.rb -f CustomFormatter
class CustomFormatter < Spec::Runner::BaseTextFormatter
  def add_context(name, first)
    @output << "\n" if first
  end
  
  def spec_failed(name, counter)
    @output << 'X'
  end
  
  def spec_passed(name)
    @output << '_'
  end
  
  def start_dump
    @output << "\n"
  end
end
