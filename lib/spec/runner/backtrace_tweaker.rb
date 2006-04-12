module Spec
  module Runner
    # Tweaks raised Exceptions to mask noisy (unneeded) parts of the backtrace
    class BacktraceTweaker
      def tweak_backtrace(error, spec_name)
        return if error.backtrace.nil?
        error.backtrace.collect! do |line|
          line = line.split(':in')[0] + ":in `#{spec_name}'" if line.include?('__instance_exec')
          line = nil if line =~ /\/lib\/spec\/api\/helper\/.+[helper|base|negator].rb/
          line = nil if line =~ /\/lib\/spec\/api\/mock.rb/
          line
        end
        error.backtrace.compact!
      end
    end
  end
end