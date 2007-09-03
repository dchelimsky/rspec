dir = File.expand_path(File.join(File.dirname(__FILE__), '/behaviour'))

require "#{dir}/render_observer"
require "#{dir}/rails_test_case"

require "#{dir}/rails_example"
require "#{dir}/model_example"
require "#{dir}/functional_example"
require "#{dir}/controller_example"
require "#{dir}/helper_example"
require "#{dir}/view_example"
