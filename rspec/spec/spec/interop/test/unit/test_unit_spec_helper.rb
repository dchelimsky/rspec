require File.dirname(__FILE__) + '/../../../../spec_helper'
require File.dirname(__FILE__) + '/../../../../ruby_forker'

describe "Test::Unit interop", :shared => true do
  include RubyForker
  
  def run_script(file_name)
    output = ruby(file_name)
    if !$?.success? || output.include?("FAILED") || output.include?("Error")
      raise output
    end
    output
  end  
end