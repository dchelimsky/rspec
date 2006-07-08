require 'application'

silence_warnings { RAILS_ENV = "test" }

require 'active_record/base'
require 'active_record/fixtures'
require 'action_controller/test_process'
require 'action_controller/integration'
require 'spec'

require File.dirname(__FILE__) + '/fixture_loading.rb'
require File.dirname(__FILE__) + '/controller_mixin.rb'

module Spec
  module Runner

    class ExecutionContext
      include Spec::ControllerExecution
      include ActionController::TestProcess

      def tag(*opts)
        opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
        tag = find_tag(opts)
      end
    end

    class Context
      include Spec::ControllerContext

      # entry point into rspec
      # Keep it sync'ed!
      def run(reporter,dry_run=false)
        ctx = self

        reporter.add_context(@name)

        @specifications.each do |specification|

          specification.run( reporter,
            lambda do
              @fixture_cache = Hash.new
              ctx.setup_with_fixtures
              setup_with_controller(ctx.controller_name)

              specification.loaded_fixtures = ctx.loaded_fixtures

              self.instance_exec(&ctx.setup_block) unless ctx.setup_block.nil?
            end,
            lambda do
              self.instance_exec(&ctx.teardown_block) unless ctx.teardown_block.nil?

              teardown_with_controller
              ctx.teardown_with_fixtures
            end,
            dry_run
          )

        end
      end

      def helper(name, &block)
        self.class.helper(name, &block)
      end

      def self.helper(name, &block)
        Spec::Runner::ExecutionContext.send :define_method, name.to_sym, &block
      end

    end # Context

  end
end

module ActionController
  class TestResponse
    def should_render(expected=nil)
      expected = expected.to_s unless expected.nil?
      rendered = expected ? rendered_file(!expected.include?('/')) : rendered_file
      expected.should_equal rendered
    end
  end
end

class String
  def should_have_tag(*opts)
    opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
    begin
      HTML::Document.new(self).find(opts).should_not_be_nil
    rescue
      self.should_include opts.inspect
    end
  end
end
