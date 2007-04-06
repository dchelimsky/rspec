require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "mocks"))

module Spec
  module Plugins
    module MockMethods
      include Spec::Mocks::SpecMethods
    end
  end
end