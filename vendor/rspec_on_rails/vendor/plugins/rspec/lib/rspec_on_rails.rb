require 'application'

silence_warnings { RAILS_ENV = "test" }
require 'action_controller/test_process'
require 'action_controller/integration'
require 'active_record/base'
require 'active_record/fixtures'
require 'spec'

dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/spec/rails/version")
require File.expand_path("#{dir}/spec/rails/opts_merger")
require File.expand_path("#{dir}/spec/rails/response_body")
require File.expand_path("#{dir}/spec/rails/rjs_expectations")
require File.expand_path("#{dir}/spec/rails/tag_expectations")
require File.expand_path("#{dir}/spec/rails/render_matcher")
require File.expand_path("#{dir}/extensions/test/rails")
require File.expand_path("#{dir}/extensions/active_record/base")
require File.expand_path("#{dir}/extensions/active_record/has_many_association")
require File.expand_path("#{dir}/extensions/action_controller/base")
require File.expand_path("#{dir}/extensions/action_controller/test_response")
require File.expand_path("#{dir}/extensions/nil_class")
require File.expand_path("#{dir}/extensions/kernel")
require File.expand_path("#{dir}/spec/rails/context")
