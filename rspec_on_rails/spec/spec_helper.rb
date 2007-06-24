dir = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{dir}/../../../../../rspec/lib")
$LOAD_PATH.unshift("#{dir}/../spec_resources/controllers")
$LOAD_PATH.unshift("#{dir}/../spec_resources/helpers")
require "#{dir}/../../../../spec/spec_helper"
require "#{dir}/../spec_resources/controllers/render_spec_controller"
require "#{dir}/../spec_resources/controllers/rjs_spec_controller"
require "#{dir}/../spec_resources/controllers/redirect_spec_controller"
require "#{dir}/../spec_resources/controllers/action_view_base_spec_controller"
require "#{dir}/../spec_resources/helpers/explicit_helper"
require "#{dir}/../spec_resources/helpers/more_explicit_helper"
require "#{dir}/../spec_resources/helpers/view_spec_helper"
require "#{dir}/../spec_resources/helpers/plugin_application_helper"

if Rails::VERSION::MINOR >= 2
  ActionController::Routing.controller_paths << "#{dir}/../spec_resources/controllers"
end

module Spec
  module Rails
    module DSL
      class ViewExampleController
        set_view_path File.join(File.dirname(__FILE__), "..", "spec_resources", "views")
      end
    end
  end
end

def fail()
  raise_error(Spec::Expectations::ExpectationNotMetError)
end
  
def fail_with(message)
  raise_error(Spec::Expectations::ExpectationNotMetError,message)
end

class Proc
  def should_pass
    lambda { self.call }.should_not raise_error
  end
end
