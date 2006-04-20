# gem install syntax
require 'syntax/convertors/html'
RUBY2HTML = Syntax::Convertors::HTML.for_syntax "ruby"

class ERB
  class Compiler
    alias old_compile compile
  
    def compile(s)
      s.gsub! /<ruby>/n, "<notextile><%= ruby <<-EOR"
      s.gsub! /<\/ruby>/n, "EOR\n%></notextile>"
      s.gsub! /<ruby\s+file="(.*)"\s*\/>/, "{ruby_inline: {filename: \\1}}"
      old_compile(s)
    end
  end
end

module FileHandlers
  class PageFileHandler < DefaultFileHandler
    def ruby(code)
      RUBY2HTML.convert(code)
    end
  end
end

module Tags

  # prints out nicely formatted ruby code in html
  class RubyInliner < DefaultTag
    summary "renders a ruby file in html and inserts it"
    depends_on "Tags"
    add_param 'filename', nil, 'The File to insert'
    set_mandatory 'filename', true
    
    
    def initialize
      super
      register_tag('ruby_inline')
    end

    def process_tag(tag, node, ref_node)
      content = ''
      begin
				filename = get_param('filename')
				if !File.exists?(filename)
					if filename[0...1] == "~"
						filename = File.expand_path(filename)
					else
						filename = ref_node.parent.recursive_value( 'src' ) + get_param( 'filename' )
					end
				end
        self.logger.debug { "File location: <#{filename}>" }
        content = File.read( filename )
      rescue
        self.logger.error { "Given file <#{filename}> does not exist (tag specified in <#{ref_node.recursive_value( 'src' )}>" }
      end
      RUBY2HTML.convert(content)
    end
  end
end