# You don't need these lines of you've got RSpec and spec/ui installed from gems
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../../../../rspec/lib"))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../../../lib"))

require 'rubygems'
require 'spec/ui/watir_helper'

module Spec
  module Runner
    class Context
      def before_context_eval #:nodoc:
        include Spec::Ui::WebappHelper
      end
    end
  end
end
