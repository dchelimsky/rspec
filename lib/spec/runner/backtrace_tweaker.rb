module Spec
  module Runner
    class NoisyBacktraceTweaker
      def tweak_instance_exec_line line, spec_name
        line = line.split(':in')[0] + ":in `#{spec_name}'" if line.include?('__instance_exec')
        line
      end
      def tweak_backtrace(error, spec_name)
        return if error.backtrace.nil?
        error.backtrace.collect! do |line|
          tweak_instance_exec_line line, spec_name
        end
        error.backtrace.compact!
      end
    end

    # Tweaks raised Exceptions to mask noisy (unneeded) parts of the backtrace
    class QuietBacktraceTweaker
      def tweak_instance_exec_line line, spec_name
        line = line.split(':in')[0] if line.include?('__instance_exec')
        line
      end
      def tweak_backtrace(error, spec_name)
        return if error.backtrace.nil?
        error.backtrace.collect! do |line|
          line = tweak_instance_exec_line line, spec_name
          line = nil if line =~ /\/lib\/ruby\//
          line = nil if line =~ /\/lib\/spec\/expectations\//
          line = nil if line =~ /\/lib\/spec\/mocks\//
          line = nil if line =~ /\/lib\/spec\/rake\//
          line = nil if line =~ /\/lib\/spec\/runner\//
          line = nil if line =~ /bin\/spec:/
          line = nil if line =~ /bin\/rcov:/
          line = nil if line =~ /lib\/rspec_on_rails/
          line = nil if line =~ /vendor\/rails/
          line = nil if line =~ /script\/rails_spec/
          # TextMate's Ruby and RSpec plugins
          line = nil if line =~ /Ruby\.tmbundle\/Support\/tmruby.rb:/
          line = nil if line =~ /RSpec\.tmbundle\/Support\/lib/
          line = nil if line =~ /temp_textmate\./
          line
        end
        error.backtrace.compact!
      end
    end
  end
end