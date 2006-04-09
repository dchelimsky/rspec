module Spec
  module Runner
    class BacktraceTweaker
      def tweak_backtrace error, spec_name
        return if error.backtrace.nil?
        tweaked_backtrace = []
        error.backtrace.collect! do |line|
          line = line.split(':in')[0] + ":in `#{spec_name}'" if line.include?('__instance_exec')
          line = nil if line.include? '/lib/spec/api/helper/should_base.rb'
          line = nil if line.include? '/lib/spec/api/helper/should_negator.rb' unless line.nil?
          line
        end
        error.backtrace.compact!
      end
    end
  end
end