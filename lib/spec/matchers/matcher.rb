module InstanceExec
  module InstanceExecHelper; end
  include InstanceExecHelper
  def instance_exec(*args, &block) # !> method redefined; discarding old instance_exec
    mname = "__instance_exec_#{Thread.current.object_id.abs}_#{object_id.abs}"
    InstanceExecHelper.module_eval{ define_method(mname, &block) }
    begin
      ret = send(mname, *args)
    ensure
      InstanceExecHelper.module_eval{ undef_method(mname) } rescue nil
    end
    ret
  end
end

module Spec
  module Matchers
    module DSL
      def create(name, &block)
        define_method name do |expected|
          Spec::Matchers::Matcher.new(name, expected, &block)
        end
      end
    end
    
    extend Spec::Matchers::DSL
    
    class Matcher
      include InstanceExec
      def initialize(name, *expected, &block)
        @name = name
        @expected = expected
        @block = block
        @messages = {
          :should => lambda {"expected #{@actual} to #{to_sentence(@name)} #{@expected}"},
          :should_not => lambda {"expected #{@actual} to not #{to_sentence(@name)} #{@expected}"},
        }
      end
      
      def matches?(actual)
        @actual = actual
        instance_exec actual, *@expected, &@block
        @match_block.call
      end
      
      def match &block
        @match_block = block
      end
      
      def failure_message_for(should_or_should_not, &block)
        @messages[should_or_should_not] = block
      end
      
      def failure_message
        instance_exec @actual, *@expected,&@messages[:should]
      end
      
      def negative_failure_message
        instance_exec @actual, *@expected,&@messages[:should_not]
      end
      
      def description(&block)
        if block
          @description = block
        else
          @description ?
            instance_exec(@actual, *@expected,&@description) :
            "#{to_sentence(@name)} #{@expected}"
        end
      end
      
    private
    
      def to_sentence(text)
        text.to_s.gsub(/_/,' ')
      end
    end
  end
end