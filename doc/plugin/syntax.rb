module Tags
  # gem install syntax
  require 'syntax/convertors/html'

  # prints out nicely formatted ruby code in html
  class RubyInliner < DefaultTag
    summary "renders a ruby file in html and inserts it"
    depends_on "Tags"
    add_param 'filename', nil, 'The File to insert'
    set_mandatory 'filename', true
    
    CONVERTOR = Syntax::Convertors::HTML.for_syntax "ruby"
    
    def initialize
      super
      register_tag( 'ruby_inline')
    end

    def process_tag( tag, node, refNode)
      content = ''
      begin
				filename=get_param('filename')
				if !File.exists?(filename)
					if filename[0...1] == "~"
						filename = File.expand_path(filename)
					else
						filename = refNode.parent.recursive_value( 'src' ) + get_param( 'filename' )
					end
				end
        self.logger.debug { "File location: <#{filename}>" }
        content = File.read( filename )
      rescue
        self.logger.error { "Given file <#{filename}> does not exist (tag specified in <#{refNode.recursive_value( 'src' )}>" }
      end
      CONVERTOR.convert(content)
    end
  end
end