require 'spec/runner/formatter/base_formatter'

module Spec
  module Runner
    module Formatter
      class SilentFormatter < BaseFormatter
        def initialize(options, output); end
      end
    end
  end
end
