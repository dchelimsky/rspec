# This should only get included if there is
# a call to require 'mocha' somewhere up the
# chain.
require 'rubygems'
gem 'mocha'
require 'mocha/standalone'

module Spec
  module Plugins
    module MockMethods
      include Mocha::Standalone
      def setup_mocks
        mocha_setup
      end
      def teardown_mocks
        mocha_verify
        mocha_teardown
      end
    end
  end
end