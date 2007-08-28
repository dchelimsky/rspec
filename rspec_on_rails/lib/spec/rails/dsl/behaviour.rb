dir = File.expand_path(File.join(File.dirname(__FILE__), '/behaviour'))

require "#{dir}/render_observer"
require "#{dir}/rails_test_case"

require "#{dir}/rails_behaviour"
require "#{dir}/model_behaviour"
require "#{dir}/functional_behaviour"
require "#{dir}/controller_behaviour"
require "#{dir}/helper_behaviour"
require "#{dir}/view_behaviour"
