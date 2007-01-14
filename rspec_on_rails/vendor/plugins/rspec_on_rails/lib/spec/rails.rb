dir = File.dirname(__FILE__)
require 'application'

silence_warnings { RAILS_ENV = "test" }
require 'action_controller/test_process'
require 'action_controller/integration'
require 'active_record/base'
require 'active_record/fixtures'
require 'spec'

require File.expand_path("#{dir}/rails/context")
require File.expand_path("#{dir}/rails/ivar_proxy")
require File.expand_path("#{dir}/rails/functional_eval_context")

require File.expand_path("#{dir}/rails/version")
require File.expand_path("#{dir}/rails/opts_merger")
require File.expand_path("#{dir}/rails/response_body")
require File.expand_path("#{dir}/rails/rjs_expectations")
require File.expand_path("#{dir}/rails/tag_expectations")
require File.expand_path("#{dir}/rails/render_matcher")
require File.expand_path("#{dir}/rails/redirect_matcher")
require File.expand_path("#{dir}/rails/extensions")
require File.expand_path("#{dir}/rails/assert_select_wrapper")
require File.expand_path("#{dir}/rails/matchers")

Test::Unit.run = true
