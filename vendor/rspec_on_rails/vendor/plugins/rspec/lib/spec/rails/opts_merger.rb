module Spec
  module Rails
    class OptsMerger
      def initialize opts
        @opts = opts
      end
  
      def merge key
        return {} if @opts.nil? || @opts.empty?
        if @opts.first.is_a? String
          first = { key => @opts.first }
          return @opts.size > 1 ? @opts.last.merge(first) : first
        else
          return @opts.last
        end
      end
    end
  end
end