module Spec
  module Ruby
    class << self
      def version
        RUBY_VERSION
      end

      def require_with_rubygems_fallback(file)
        begin
          require file
        rescue LoadError
          require 'rubygems'
          require file
        end
      end
    end
  end
end
