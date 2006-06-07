module Spec
  module Tool
    # Translates Test::Unit tests to RSpec specs.
    class TestUnitTranslator
      ONE_ARG_TRANSLATIONS = {
        "assert"                => "should_not_be nil",
        "assert_nil"            => "should_be nil",
        "assert_not_nil"        => "should_not_be nil"
        
      }
      TWO_ARG_TRANSLATIONS = {
        "assert_equal"          => "should_equal",
        "assert_instance_of"    => "should_be_instance_of",
        "assert_kind_of"        => "should_be_kind_of",
        "assert_match"          => "should_match",
        "assert_no_match"       => "should_not_match",
        "assert_not_equal"      => "should_not_equal",
        "assert_not_same"       => "should_not_be",
        "assert_same"           => "should_be"
      }
      RAISE_TRANSLATIONS = {
        "assert_nothing_raised" => "should_not_raise",
        "assert_nothing_thrown" => "should_not_throw",
        "assert_raise"          => "should_raise",
        "assert_raises"         => "should_raise",
        "assert_throws"         => "should_throw",
      }
    
      def translate(test_unit_file)
        content = File.open(test_unit_file)
        end_replacement = nil
        translated = ""
        content.each do |line|
          if line =~ /^require .*test.*/
            line = "require 'spec'\n"
          elsif line =~ /^(\s*)def\s+setup/
            spaces = $1
            line = "#{spaces}setup do\n"
          elsif line =~ /^(\s*)def\s+teardown/
            spaces = $1
            line = "#{spaces}teardown do\n"
          elsif line =~ /^(\s*)class\s+(.*)\s+<\s+Test::Unit::TestCase/
            spaces = $1
            class_name = $2

            context_name = class_name.match(/(.*)Test/)[1]
            line = "#{spaces}context \"#{context_name}\" do\n"
            
          elsif line =~ /(\s*)def\s+test_(.*)/
            spaces = $1
            method_meaning = $2

            specification_name = method_meaning.gsub(/_/, " ").capitalize
            line = "#{spaces}specify \"#{specification_name}\" do\n"
            
          elsif line =~ /(\s*)(assert[^\s$\(]*)\s*\(?([^\)^\{]*)\)?\s*(.*)/
            spaces = $1
            assertion = $2
            args = $3
            suffix = $4
            
            if(args =~ /^do/n and suffix =="")
              # hack to handle methods taking no args and do at the end
              args = ""
              suffix = "do"
            end

            if translation = TWO_ARG_TRANSLATIONS[assertion]
              expected, actual, message = args.split(",").collect{|arg| arg.strip}
              line = "#{spaces}#{actual}.#{translation} #{expected}\n"
              
            elsif assertion == "assert_respond_to"
              actual, method, message = args.split(",").collect{|arg| arg.strip}
              line = "#{spaces}#{actual}.should_respond_to #{method}\n"
              
            elsif translation = ONE_ARG_TRANSLATIONS[assertion]
              actual, message = args.split(",").collect{|arg| arg.strip}
              line = "#{spaces}#{actual}.#{translation}\n"
              
            elsif translation = RAISE_TRANSLATIONS[assertion] and suffix =~ /\{.*\}/
              expected, message = args.split(",").collect{|arg| arg.strip}
              line = "#{spaces}lambda #{suffix}.#{translation} #{expected}\n"
              
            elsif translation = RAISE_TRANSLATIONS[assertion]
              expected, message = args.split(",").collect{|arg| arg.strip}
              line = "#{spaces}lambda do\n"
              end_replacement = "#{translation} #{expected}\n"
              
            elsif assertion == "assert_block" and suffix =~ /\{.*\}/
              line = "#{spaces}lambda #{suffix}.should_be true\n"
              
            elsif assertion == "assert_block"
              line = "#{spaces}lambda do\n"
              end_replacement = "should_be true\n"
              
            elsif assertion == "assert_in_delta"
              expected, actual, delta, message = args.split(",").collect{|arg| arg.strip}
              line = "#{spaces}#{actual}.should_be_close #{expected}, #{delta}\n"
            end
          elsif end_replacement && line =~ /(\s+)end/
            spaces = $1
            line = "#{spaces}end.#{end_replacement}"
            end_replacement = nil
          end
          
          translated += line unless line.nil?
        end
        translated
      end
    end
  end
end