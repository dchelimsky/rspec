module Spec
  module Rails
    class Context < Spec::Runner::Context
      class << self
        attr_writer :fixture_path
        def fixture_path
          @fixture_path ||= RAILS_ROOT + '/spec/fixtures'
        end
      end
    end
  end
end

