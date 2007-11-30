require File.dirname(__FILE__) + '/../../../../spec_helper'

describe "Test::Unit interop", :shared => true do
  def run_script(file_name)
    output = `ruby #{file_name}`
    if !$?.success? || output.include?("FAILED") || output.include?("Error")
      raise output
    end
  end  
end