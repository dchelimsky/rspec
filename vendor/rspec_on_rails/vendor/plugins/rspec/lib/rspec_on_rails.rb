require 'application'

silence_warnings { RAILS_ENV = "test" }
require 'spec'
require 'active_record/base'
require 'active_record/fixtures'
require 'action_controller/test_process'
require 'action_controller/integration'
require 'tag_expectations'
require 'rjs_expectations'
dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/extensions/active_record/base")
require File.expand_path("#{dir}/response_body")
require File.expand_path("#{dir}/extensions/execution_context")
require File.expand_path("#{dir}/extensions/context_eval")
require File.expand_path("#{dir}/extensions/context")
require File.expand_path("#{dir}/extensions/nil_class")
