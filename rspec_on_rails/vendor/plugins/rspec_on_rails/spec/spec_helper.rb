$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../../rspec/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../spec_resources/controllers')
require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
require File.dirname(__FILE__) + '/../spec_resources/controllers/render_spec_controller.rb'
require File.dirname(__FILE__) + '/../spec_resources/controllers/rjs_spec_controller.rb'
require File.dirname(__FILE__) + '/../spec_resources/controllers/redirect_spec_controller.rb'

module Spec
  module Rails
    module Runner
      class ViewSpecController
        self.template_root = File.join(File.dirname(__FILE__), "..", "spec_resources", "views")
      end
    end
  end
end


class Proc
  def should_fail
    lambda { self.call }.should_raise(Spec::Expectations::ExpectationNotMetError)
  end
  def should_fail_with message
    lambda { self.call }.should_raise(Spec::Expectations::ExpectationNotMetError, message)
  end
  def should_pass
    lambda { self.call }.should_not_raise
  end
end
