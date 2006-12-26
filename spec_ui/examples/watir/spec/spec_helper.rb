# You don't need these lines of you've got RSpec and spec/ui installed from gems
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../../../../rspec/lib"))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../../../lib"))

require 'spec/ui/watir_helper'
