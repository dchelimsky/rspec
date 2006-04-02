require 'find'

module Spec
  module Tool
    class CommandLine
      def initialize(filesystem)
        @filesystem = filesystem.nil? ? self : filesystem
        @translator = TestUnitTranslator.new
      end
    
      def run(source, dest, out)
        if FileTest.directory?(source)
          raise "DEST must be a directory when SOURCE is a directory" if FileTest.file?(dest)
          Find.find(source) do |path|
            if FileTest.file?(path) and File.extname(path) == '.rb'
              relative_path = path[source.length+1..-1]
              dest_path = File.join dest, relative_path
              run path, dest_path, out
            end
          end
        else
          raise "DEST must be a file when SOURCE is a file" if FileTest.directory?(dest)
          out.puts "Writing: #{dest}"
          @filesystem.write_translation(source, dest)
        end
      end
      
      def write_translation(source, dest)
        return
        dir = File.dirname(dest)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        File.open(dest) do |io|
          translation = @translator.translate(source)
          io.write(translation)
        end
      end
    end
  end
end