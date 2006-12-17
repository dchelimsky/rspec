module Spec
  module Runner
    class BacktraceTweaker
      def clean_up_double_slashes(line)
        line.gsub!('//','/')
      end
    end

    class NoisyBacktraceTweaker < BacktraceTweaker
      def tweak_backtrace(error, spec_name)
        return if error.backtrace.nil?
        error.backtrace.each do |line|
          clean_up_double_slashes(line)
        end
      end
    end

    # Tweaks raised Exceptions to mask noisy (unneeded) parts of the backtrace
    class QuietBacktraceTweaker < BacktraceTweaker
      def tweak_backtrace(error, spec_name)
        return if error.backtrace.nil?
        error.backtrace.collect! do |line|
          clean_up_double_slashes(line)
          line = nil if line =~ /\/lib\/ruby\//
          line = nil if line =~ /\/lib\/spec\//
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