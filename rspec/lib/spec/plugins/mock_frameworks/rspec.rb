require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "mocks"))

module Spec
  module Plugins
    module MockMethods
      include Spec::Mocks::SpecMethods
      def setup_mocks_for_rspec
        $rspec_mocks ||= Spec::Mocks::Space.new
      end
      def teardown_mocks_for_rspec
        begin
          $rspec_mocks.verify_all
        ensure
          $rspec_mocks.reset_all
        end
      end
    end
  end
end
