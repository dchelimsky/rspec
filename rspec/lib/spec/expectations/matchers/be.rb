module Spec
  module Expectations
    module Matchers
      
      class Be #:nodoc:
        def initialize(expected=nil, *args)
          @expected = parse_expected(expected)
          @args = args
          @comparison = ""
        end
        
        def matches?(actual)
          @actual = actual
          return true if match_or_compare unless handling_predicate?
          if handling_predicate?
            Spec::Expectations.fail_with("target does not respond to ##{predicate}") unless @actual.respond_to?(predicate)
            return actual.__send__(predicate, *@args) if actual.respond_to?(predicate)
          end
          return false
        end
        
        def failure_message
          return "expected #{@comparison}#{expected}, got #{@actual.inspect}" unless handling_predicate?
          return "expected #{predicate}#{args_to_s} to return true, got false"
        end
        
        def negative_failure_message
          return "expected not #{expected}, got #{@actual.inspect}" unless handling_predicate?
          return "expected #{predicate}#{args_to_s} to return false, got true"
        end
        
        def expected
          return true if @expected == :true?
          return false if @expected == :false?
          return "nil" if @expected == :nil?
          return @expected.inspect
        end
        
        def match_or_compare
          return @actual == true if @expected == :true?
          return @actual == false if @expected == :false?
          return @actual.nil? if @expected == :nil?
          return @actual < @expected if @less_than
          return @actual <= @expected if @less_than_or_equal
          return @actual >= @expected if @greater_than_or_equal
          return @actual > @expected if @greater_than
          return @actual.equal?(@expected)
        end

        def <(expected)
          @less_than = true
          @comparison = "< "
          @expected = expected
          self
        end

        def <=(expected)
          @less_than_or_equal = true
          @comparison = "<= "
          @expected = expected
          self
        end

        def >=(expected)
          @greater_than_or_equal = true
          @comparison = ">= "
          @expected = expected
          self
        end

        def >(expected)
          @greater_than = true
          @comparison = "> "
          @expected = expected
          self
        end

        private
          def parse_expected(expected)
            if Symbol === expected
              ["be_an_","be_a_","be_"].each do |prefix|
                return "#{expected.to_s.sub(prefix,"")}?".to_sym if expected.starts_with?(prefix)
              end
            end
            return expected
          end

          def predicate
            "#{@expected.to_s}".to_sym
          end
          
          def args_to_s
            return "" if @args.empty?
            transformed_args = @args.collect{|a| a.inspect}
            return "(#{transformed_args.join(', ')})"
          end
          
          def handling_predicate?
            return false if [:true?, :false?, :nil?].include?(@expected)
            return @expected.is_a?(Symbol) && @expected.to_s =~ /\?$/
          end
      end
   
    end
  end
end