dir = File.dirname(__FILE__)

require File.expand_path("#{dir}/expectations/ivar_proxy")
require File.expand_path("#{dir}/expectations/opts_merger")
require File.expand_path("#{dir}/expectations/redirect_matcher")
require File.expand_path("#{dir}/expectations/rjs_expectations")
require File.expand_path("#{dir}/expectations/tag_expectations")
require File.expand_path("#{dir}/expectations/render_matcher")
require File.expand_path("#{dir}/expectations/response_body")

module Spec
  module Rails
    # Spec::Rails::Expectations provides Rails-specific extensions to Spec::Expectations
    # (RSpec's core Expectations module)
    #
    # See Spec::Rails::Expectations::Matchers for more information.
    module Expectations
    end
  end
end
