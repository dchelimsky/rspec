module Spec
  module Api

    class DuckType
      def initialize(*methods_to_respond_do)
        @methods_to_respond_do = methods_to_respond_do
      end
  
      def walks_like?(obj)
        @methods_to_respond_do.each { |sym| return false unless obj.respond_to? sym }
        return true
      end
    end
  
  end
end