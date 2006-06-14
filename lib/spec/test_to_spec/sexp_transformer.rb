require 'sexp_processor'

module Spec
  module TestToSpec
    # Transforms a Sexp tree (produced by ParseTree) for a Test::Unit class
    # to an Sexp tree representing an RSpec context
    class SexpTransformer < SexpProcessor
      TRANSLATIONS = {
        :assert_equal          => :should_equal,
        :assert_not_equal      => :should_not_equal,
        :assert_same           => :should_be,
        :assert_not_same       => :should_not_be,
        :assert_instance_of    => :should_be_instance_of,
        :assert_kind_of        => :should_be_kind_of,
        :assert_match          => :should_match,
        :assert_no_match       => :should_not_match,
        :assert_respond_to     => :should_respond_to,
        :assert                => :should_be,
        :assert_nil            => :should_be,
        :assert_not_nil        => :should_not_be,
        :assert_in_delta       => :should_be_close,
        :assert_block          => :should_be,
        :assert_raise          => :should_raise,
        :assert_raises         => :should_raise,
        :assert_nothing_raised => :should_not_raise,
        :assert_throws         => :should_throw,
        :assert_nothing_thrown => :should_not_throw,
      }

      def initialize
        super
        self.expected = Array
      end
      
      def process(exp)
#puts "PROCESS:#{exp[0]}"
super
      end
      
      def process_class(exp)
        # Get the class header
        exp.shift
        class_name = exp.shift.to_s.split("::").last
        context_name = class_name.match(/(.*)Test/)[1]
        exp.shift

        # Partition all methods (and other stuff) into chunks, as we're
        # going to handle them a bit differently
        rest = exp
        setup,    rest = rest.partition{|e| e[0] == :defn && e[1].to_s == "setup"}
        teardown, rest = rest.partition{|e| e[0] == :defn && e[1].to_s == "teardown"}
        tests,    rest = rest.partition{|e| e[0] == :defn && e[1].to_s =~ /^test/}
        methods,  rest = rest.partition{|e| e[0] == :defn}
        
        if !methods.empty? && setup.empty?
          # We have some methods, but no setup to put them in. Create empty setup
          setup[0] = [:defn, :setup, [:scope, [:block, [:args], [:nil]]]]
        end
        
        context_body = []
        unless setup.empty?
          setup_block = process(setup.shift)
          unless methods.empty?
            if setup_block.length == 3
              setup_block += methods
            else
              setup_block[3] += methods
            end
          end
          context_body << setup_block
        end
        context_body << process(teardown.shift) until teardown.empty?
        context_body << process(tests.shift)    until tests.empty?
        context_body << process(rest.shift)     until rest.empty?
        exp.clear

        result = [:iter, [:fcall, :context, [:array, [:str, context_name]]], nil]
        if context_body.length > 1
          result << [:block] + context_body 
        else
          result += context_body
        end
        [result]
      end
      
      def process_defn(exp)
        method_name = exp[1].to_s
        if method_name =~ /^test_(.*)/
          spec_name = $1.gsub(/_/, " ")

          test_body = exp[2][1][2..-1]
          exp.clear
          block_body = []
          @dasgn_decl = []
          block_body << process(test_body.shift) until test_body.empty?
          result = [:iter, [:fcall, :specify, [:array, [:str, spec_name]]], nil]
          result << [:block] unless block_body == [[:nil]]
          result[-1] += @dasgn_decl unless @dasgn_decl.empty?
          result[-1] += block_body unless block_body == [[:nil]]
          result
        elsif method_name == "setup" || method_name == "teardown"
          test_body = exp[2][1][2..-1]
          exp.clear
          block_body = []
          @dasgn_decl = []
          block_body << process(test_body.shift) until test_body.empty?
          result = [:iter, [:fcall, method_name.to_sym], nil]
          result << [:block] unless block_body == [[:nil]]
          result[-1] += @dasgn_decl unless @dasgn_decl.empty?
          result[-1] += block_body unless block_body == [[:nil]]
          result
        end
      end
      
      def process_lasgn(exp)
        result = exp.dup
        result[0] = :dasgn_curr
        decl = result[0..1].dup
        if @dasgn_decl.empty?
          @dasgn_decl += [decl]
        else
          @dasgn_decl_tail << decl
        end
        @dasgn_decl_tail = decl
        exp.clear
        result
      end

      # Handles 'block' assert_ calls
      def process_iter(exp)
        test_unit_fcall = exp[1][1]
        rspec_should = TRANSLATIONS[test_unit_fcall]
        unless rspec_should.nil?
          body = exp[3]
          args = exp[1][2]
          args.delete_at(2) unless args.nil? # get rid of the message arg
          result = [:call, [:iter, [:fcall, :lambda], nil, body], rspec_should]
          result << args unless args.nil?
          result << [:array, [:true]] if test_unit_fcall == :assert_block
          exp.clear
          result
        else
          exp.shift
          result = [:iter]
          result << process(exp.shift) until exp.empty?
          result
        end
      end

      # Handles regular assert_ calls
      def process_fcall(exp)
        test_unit_fcall = exp[1]
        rspec_should = TRANSLATIONS[test_unit_fcall]
        unless rspec_should.nil?
          args = exp[2]
          actual_index = [:assert, :assert_not_nil, :assert_nil, :assert_respond_to].index(test_unit_fcall) ? 1 : 2
          actual = args.delete_at(actual_index)
          expected = args
          if test_unit_fcall == :assert_in_delta
            expected.delete_at(3)
            expected << args.delete_at(2)
          else
            msg_index = (test_unit_fcall == :assert_respond_to) ? 2 : actual_index
            expected.delete_at(msg_index)
          end
          expected << [:true] if test_unit_fcall == :assert
          expected << [:nil] if [:assert_not_nil, :assert_nil].index(test_unit_fcall)
          
          actual = process(actual)
          
          result = [:call, actual, rspec_should, expected]
          exp.clear
          result
        else
          result = exp.dup
          exp.clear
          result
        end
      end
      
      def process_lvar(exp)
        result = exp.dup
        result[0] = :dvar
        exp.clear
        result
      end
    end
  end
end