module Spec
  module Rails
    class EvalContext < Test::Unit::TestCase
      include Spec::Rails::Matchers
      cattr_accessor :fixture_path, :use_transactional_fixtures, :use_instantiated_fixtures, :global_fixtures
      remove_method :default_test if respond_to?(:default_test)
      class << self
        def init_global_fixtures
          send :fixtures, self.global_fixtures if self.global_fixtures
        end
      end
    end

    class Context < Spec::Runner::Context
    end
  end
end