module Spec
  module Runner
    class BacktraceTweaker
      def tweak_backtrace error, spec_name
        return if error.backtrace.nil?
        tweaked_backtrace = []
        error.backtrace.each do |line|
          if line.include?('__instance_exec')
            line = line.split(':in')[0] + ":in `#{spec_name}'"
          end
          tweaked_backtrace.push line
        end
        error.set_backtrace tweaked_backtrace
      end
    end
  end
end