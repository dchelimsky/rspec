module Spec
  module Tool
    # Translates Test::Unit tests to RSpec specs.
    class TestUnitConverter
      ONE_ARG_TRANSLATIONS = {
        "assert"                => "should.not.be nil",
        "assert_nil"            => "should.be nil",
        "assert_not_nil"        => "should.not.be nil"
        
      }
      TWO_ARG_TRANSLATIONS = {
        "assert_equal"          => "should.equal",
        "assert_instance_of"    => "should.be.instance.of",
        "assert_kind_of"        => "should.be.kind.of",
        "assert_match"          => "should.match",
        "assert_no_match"       => "should.not.match",
        "assert_not_equal"      => "should.not.equal",
        "assert_not_same"       => "should.not.be",
        "assert_same"           => "should.be"
      }
      RAISE_TRANSLATIONS = {
        "assert_nothing_raised" => "should.not.raise",
        "assert_nothing_thrown" => "should.not.throw",
        "assert_raise"          => "should.raise",
        "assert_raises"         => "should.raise",
        "assert_throws"         => "should.throw",
      }
    
      def translate(test_unit_file)
        end_replacement = nil
        translated = ""
        test_unit_file.each do |line|
          if line =~ /^require .*test.*/
            line = "require 'spec'\n"
          elsif line =~ /^(\s+)class\s+(.*)\s+<\s+Test::Unit::TestCase/
            spaces = $1
            class_name = $2

            context_name = class_name.match(/(.*)Test/)[1]
            line = "#{spaces}context \"#{context_name}\" do\n"
            
          elsif line =~ /(\s+)def\s+test_(.*)/
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
              line = "#{spaces}#{actual}.should.respond.to #{method}\n"
              
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
              line = "#{spaces}lambda #{suffix}.should.be true\n"
              
            elsif assertion == "assert_block"
              line = "#{spaces}lambda do\n"
              end_replacement = "should.be true\n"
              
            elsif assertion == "assert_in_delta"
              expected, actual, delta, message = args.split(",").collect{|arg| arg.strip}
              line = "#{spaces}#{actual}.should.be.close #{expected}, #{delta}\n"
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