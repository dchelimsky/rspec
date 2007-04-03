# This should only get included if there is
# a call to require 'mocha' somewhere up the
# chain.
require 'rubygems'
gem 'mocha'
require 'mocha/standalone'
require 'mocha/object'

module Spec
  module Plugins
    module MockMethods
      include Mocha::Standalone
      def setup_mocks_for_rspec
        mocha_setup
      end
      def teardown_mocks_for_rspec
        begin
          mocha_verify
        ensure
          mocha_teardown
        end
      end
    end
  end
end