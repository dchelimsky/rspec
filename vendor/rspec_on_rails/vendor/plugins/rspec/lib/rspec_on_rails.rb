require 'application'

silence_warnings { RAILS_ENV = "test" }
require 'spec'
require 'active_record/base'
require 'active_record/fixtures'
require 'action_controller/test_process'
require 'action_controller/integration'

dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/spec/expectations/tag_expectations")
require File.expand_path("#{dir}/spec/expectations/rjs_expectations")
require File.expand_path("#{dir}/spec/expectations/response_body")
require File.expand_path("#{dir}/extensions/active_record/base")
require File.expand_path("#{dir}/extensions/action_controller/test_response")
require File.expand_path("#{dir}/extensions/context_eval")
require File.expand_path("#{dir}/extensions/context")
require File.expand_path("#{dir}/extensions/nil_class")
