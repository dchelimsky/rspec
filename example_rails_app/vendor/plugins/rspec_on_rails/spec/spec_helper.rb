$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../../rspec/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../spec_resources/controllers')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../spec_resources/helpers')
require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
require File.dirname(__FILE__) + '/../spec_resources/controllers/render_spec_controller'
require File.dirname(__FILE__) + '/../spec_resources/controllers/rjs_spec_controller'
require File.dirname(__FILE__) + '/../spec_resources/controllers/redirect_spec_controller'
require File.dirname(__FILE__) + '/../spec_resources/helpers/explicit_helper'
require File.dirname(__FILE__) + '/../spec_resources/helpers/more_explicit_helper'
require File.dirname(__FILE__) + '/../spec_resources/helpers/view_spec_helper'
require File.dirname(__FILE__) + '/../spec_resources/helpers/plugin_application_helper'

module Spec
  module Rails
    module DSL
      class ViewExampleController
        self.template_root = File.join(File.dirname(__FILE__), "..", "spec_resources", "views")
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
