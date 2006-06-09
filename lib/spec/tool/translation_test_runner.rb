require 'spec/tool/test_unit_translator'
require 'fileutils'

module Spec
  module Tool
    # A Test::Unit runner that doesn't run tests, but translates them instead!
    class TranslationTestRunner
      include FileUtils

      def self.run(suite, output_level)
        self.new(suite)
      end
      
      def initialize(suite)
        puts "Writing translated specs to #{$test2spec_options[:specdir]}"
        translator = TestUnitTranslator.new
        ObjectSpace.each_object(Class) do |klass|
          if klass < ::Test::Unit::TestCase
            begin
              translation = translator.translate(klass)
              
              unless $test2spec_options[:dry_run]
                relative_path = underscore(klass.name)
                relative_path.gsub! /_test$/, "_spec"
                relative_path.gsub! /\/test_/, ""
                relative_path += ".rb"
                write(translation, relative_path)
              else
                puts "Successfully translated #{klass}"
              end
            rescue SexpProcessorError => e
              puts "Failed to translate     #{klass}"
            end
          end
        end
        puts "\nDone"
      end
      
      def passed?
        true
      end

    private

      def destination_path(relative_destination)
        File.join($test2spec_options[:specdir], relative_destination)
      end

      def write(source, relative_destination)
        destination         = destination_path(relative_destination)
        destination_exists  = File.exists?(destination)
        if destination_exists and identical?(source, destination)
          return puts("Identical : #{relative_destination}")
        end

        if destination_exists
          choice = case ($test2spec_options[:collision]).to_sym #|| :ask
            when :ask   then force_file_collision?(relative_destination)
            when :force then :force
            when :skip  then :skip
            else raise "Invalid collision option: #{$test2spec_options[:collision].inspect}"
          end

          case choice
            when :force then puts("Forcing   : #{relative_destination}")
            when :skip  then return(puts("Skipping  : #{relative_destination}"))
            else raise "Invalid collision choice: #{choice}.inspect"
          end
        else
          dir = File.dirname(destination)
          unless File.directory?(dir)
            puts "Creating  : #{dir}"
            mkdir_p dir
          end
          puts "Creating  : #{destination}"
        end

        File.open(destination, 'w') do |df|
          df.write(source)
        end

        if $test2spec_options[:chmod]
puts $test2spec_options[:chmod]
          chmod($test2spec_options[:chmod], destination)
        end
      
        system("svn add #{destination}") if $test2spec_options[:svn]
      end

      def identical?(source, destination, &block)
        return false if File.directory? destination
        destination = IO.read(destination)
        source == destination
      end
      
      def force_file_collision?(destination)
        $stdout.print "overwrite #{destination}? [Ynaq] "
        case $stdin.gets
          when /a/i
            $test2spec_options[:collision] = :force
            $stdout.puts "Forcing ALL"
            :force
          when /q/i
            $stdout.puts "Quitting"
            raise SystemExit
          when /n/i then :skip
          else :force
        end
      end

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