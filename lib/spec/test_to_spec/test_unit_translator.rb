require 'spec/test_to_spec/ruby2ruby'

module Spec
  module TestToSpec
    # Translates Test::Unit tests to RSpec specs,
    # Using RubyToRuby and Sexp
    class TestUnitTranslator < RubyToRuby
      ONE_ARG_ASSERTIONS = ["assert", "assert_nil", "assert_not_nil"]
      
      PLAIN_TRANSLATIONS = {
        "assert"                => "should_be true",
        "assert_nil"            => "should_be nil",
        "assert_not_nil"        => "should_not_be nil",
        "assert_equal"          => "should_equal",
        "assert_in_delta"       => "should_be_close",
        "assert_instance_of"    => "should_be_instance_of",
        "assert_kind_of"        => "should_be_kind_of",
        "assert_match"          => "should_match",
        "assert_no_match"       => "should_not_match",
        "assert_not_equal"      => "should_not_equal",
        "assert_not_same"       => "should_not_be",
        "assert_respond_to"     => "should_respond_to",
        "assert_same"           => "should_be"
      }
      PLAIN_PATTERN = /^#{PLAIN_TRANSLATIONS.keys.join("$|^")}$/
      
      BLOCK_TRANSLATIONS = {
        "assert_block"          => "should_be true",
        "assert_nothing_raised" => "should_not_raise",
        "assert_nothing_thrown" => "should_not_throw",
        "assert_raise"          => "should_raise",
        "assert_raises"         => "should_raise",
        "assert_throws"         => "should_throw",
      }
      BLOCK_PATTERN = /^#{BLOCK_TRANSLATIONS.keys.join("$|^")}$/

      def translate(klass)
        tree = ParseTree.new.parse_tree(klass).first
        process(tree)
      end

      def process_class(exp)
        if(exp[1].to_s == "Test::Unit::TestCase")
          module_and_class_name = exp.shift.to_s.split("::")
          modules = module_and_class_name[0..-2]
          class_name = module_and_class_name[-1]
          super_class_name = exp.shift.to_s
          context_name = class_name.match(/(.*)Test/)[1]

          s = ""
          s << modules.collect{|m| "module #{m}\n"}.join("") unless modules.empty?
          s << "context \"#{context_name}\" do\n"
          body = ""
          body << "#{process exp.shift}\n\n" until exp.empty?
          s += indent(body) + "end\n"
          s += modules.collect{|m| "end\n"}.join("") unless modules.empty?
        else
          super
        end
      end

      def process_defn(exp)
        method_name = exp[0].to_s
        if exp[1].first != :cfunc
          if method_name == "setup" || method_name == "teardown"
            name = exp.shift
            body = process(exp.shift)
            return "#{method_name} do #{body}end".gsub(/\n\s*\n+/, "\n")
          elsif method_name =~ /^test_(.*)/
            exp.shift
            spec_name = $1.gsub(/_/, " ")
            body = process(exp.shift)
            return "specify \"#{spec_name}\" do #{body}end".gsub(/\n\s*\n+/, "\n")
          else
            super
          end
        else
          super
        end
      end

      def process_fcall(exp)
        if exp[0].to_s =~ PLAIN_PATTERN
          name = exp.shift.to_s
          args = exp.shift
          code = []
          unless args.nil?
            assert_type args, :array
            args.shift # :array
            until args.empty? do
              code << process(args.shift)
            end
          end
          
          if ONE_ARG_ASSERTIONS.index(name)
            expected = ""
            actual = code[0]
          elsif(name == "assert_in_delta")
            expected = " #{code[0]}, #{code[2]}"
            actual = code[1]
          elsif(name == "assert_respond_to")
            # test::unit got this wrong. we have to swap them
            expected = " #{code[1]}"
            actual = code[0]
          else
            expected = " #{code[0]}"
            actual = code[1]
          end
          translation = PLAIN_TRANSLATIONS[name]
          raise "No translation for '#{name}'" if translation.nil?
          return "#{actual}.#{translation}#{expected}"
        elsif exp[0].to_s =~ BLOCK_PATTERN
          name = exp.shift.to_s
          args = exp.shift
          code = []
          unless args.nil? then
            assert_type args, :array
            args.shift # :array
            until args.empty? do
              code << process(args.shift)
            end
          end
          suffix_arg = code.empty? ? "" : "(#{code[0]})"
          @lambda_suffix = "#{BLOCK_TRANSLATIONS[name]}#{suffix_arg}"
          return "lambda"
        else
          super
        end
      end
      
      def process_iter(exp)
        result = super
        if(@lambda_suffix)
          suffix = @lambda_suffix
          @lambda_suffix = nil
          "#{result}.#{suffix}"
        else
          result
        end
      end
    end
  end
end