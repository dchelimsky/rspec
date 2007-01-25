#Based on patch from 

module Spec
  module Expectations
    module Matchers
      
      class Change #:nodoc:
        def initialize(receiver=nil, message=nil, &block)
          @receiver = receiver
          @message = message
          @block = block
        end
        
        def matches?(target)
          @target = target
          execute_change
          return false if @from && (@from != @before)
          return false if @to && (@to != @after)
          return (@before + @amount == @after) if @amount
          return @before != @after
        end
        
        def execute_change
          @before = @block.nil? ? @receiver.send(@message) : @block.call
          @target.call
          @after = @block.nil? ? @receiver.send(@message) : @block.call
        end
        
        def failure_message
          if @to
            "#{result} should have been changed to #{@to.inspect}, but is now #{@after.inspect}"
          elsif @from
            "#{result} should have initially been #{@from.inspect}, but was #{@before.inspect}"
          elsif @amount
            "#{result} should have been changed by #{@amount.inspect}, but was changed by #{actual_delta.inspect}"
          else
            "#{result} should have changed, but is still #{@before.inspect}"
          end
        end
        
        def result
          @message || "result"
        end
        
        def actual_delta
          @after - @before
        end
        
        def negative_failure_message
        end
        
        def by(amount)
          @amount = amount
          self
        end
        
        def to(to)
          @to = to
          self
        end
        
        def from (from)
          @from = from
          self
        end
      end
      
    end
  end
end
