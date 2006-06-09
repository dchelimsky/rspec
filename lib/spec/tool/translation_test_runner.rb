require 'spec/tool/test_unit_translator'
require 'fileutils'

module Spec
  module Tool
    # A Test::Unit runner that doesn't run tests, but translates them instead!
    # TODO: give it the dir
    class TranslationTestRunner
      include FileUtils
      @@dir = "spec"

      def self.run(suite, output_level=NORMAL)
        self.new(suite, output_level)
      end
      
      def initialize(suite, output_level=NORMAL, io=STDOUT)
        puts "Translating Tests to RSpec"
        translator = TestUnitTranslator.new
        ObjectSpace.each_object(Class) do |klass|
          if klass < ::Test::Unit::TestCase
            relative_path = underscore(klass.name)
            relative_path.gsub! /_test$/, "_spec"
            relative_path.gsub! /\/test_/, ""
            relative_path += ".rb"
            path = File.join(@@dir, relative_path)
            begin
              translation = translator.translate(klass)
              dir = File.dirname(path)
              mkdir_p(dir) unless File.directory?(dir)
              File.open(path, "w") {|io| io.write translation}
              puts "Wrote               #{path}"
            rescue IOError => e
              puts "Failed to write to  #{path}"
            rescue SexpProcessorError => e
              puts "Failed to translate #{klass}"
            end
          end
        end
        puts "\nDone"
      end
      
      def passed?
        true
      end
      
      # Stolen from Rails' ActiveSupport
      def underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end