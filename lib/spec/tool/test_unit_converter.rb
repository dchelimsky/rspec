module Spec
  module Tool
    # Translates Test::Unit style tests to RSpec style specs.
    class TestUnitConverter
      def translate(test_unit_file)
        translated = File.open(test_unit_file).collect do |line|
          if line =~ /^(\s+)class\s+(.*)\s+<\s+Test::Unit::TestCase/
            spaces = $1
            class_name = $2

            context_name = class_name.match(/(.*)Test/)[1]
            line = "#{spaces}context \"#{context_name}\" do\n"
          elsif line =~ /(\s+)def\s+test_(.*)/
            spaces = $1
            method_meaning = $2

            specification_name = method_meaning.gsub(/_/, " ").capitalize
            line = "#{spaces}specify \"#{specification_name}\" do\n"
          end
          line
        end
        
        translated
      end
    end
  end
end