module Spec
  module Runner
    class BacktraceTweaker
      def tweak_instance_exec_line line, spec_name
        line = line.split(':in')[0] + ":in `#{spec_name}'" if line.include?('__instance_exec')
        line
      end
    end

    # Tweaks raised Exceptions to mask noisy (unneeded) parts of the backtrace
    class NoisyBacktraceTweaker < BacktraceTweaker
      def tweak_backtrace(error, spec_name)
        return if error.backtrace.nil?
        error.backtrace.collect! do |line|
          tweak_instance_exec_line line, spec_name
        end
        error.backtrace.compact!
      end
    end

    # Tweaks raised Exceptions to mask noisy (unneeded) parts of the backtrace
    class QuietBacktraceTweaker < BacktraceTweaker
      def tweak_backtrace(error, spec_name)
        return if error.backtrace.nil?
        error.backtrace.collect! do |line|
          line = tweak_instance_exec_line line, spec_name
          line = nil if line =~ /\/lib\/spec\/api\//
          line = nil if line =~ /\/lib\/spec\/runner\//
          line = nil if line =~ /bin\/spec:/
          # TextMate's Ruby plugin
          line = nil if line =~ /Ruby\.tmbundle\/Support\/tmruby.rb:/
          line
        end
        error.backtrace.compact!
      end
    end
  end
end