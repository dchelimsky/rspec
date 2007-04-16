require 'redcloth'
require 'syntax/convertors/html'
RUBY2HTML = Syntax::Convertors::HTML.for_syntax "ruby"

module RSpec
  module SyntaxConverter 
    # ruby/html content.  Initialize with the full
    # <ruby>...</ruby> string                       
    class RubyHtml < String     
      def initialize(content)
        @content = remove_ruby_tags(content)
      end
      
      attr_reader :content
      def to_s; @content.to_s; end
      alias :inspect :to_s
          
      def to_html
        '<pre class="ruby"><code>' + RUBY2HTML.convert(self.content.to_s, false) + '</code></pre>'
      end
      
      def to_redcloth
        "<notextile>" + self.to_html + "</notextile>"
      end
    
    private     
      def remove_ruby_tags(content_with_tags)
        content_with_tags.gsub!(/<ruby>/, "")
        content_with_tags.gsub!(/<\/ruby>/, "")
      end  
    end                   

    # ruby/html content.  Initialize with
    # <ruby file="..." /> or <ruby file="..."/>
    class RubyHtmlFile < RubyHtml     
      def initialize(content)                               
        @content = find_file_contents(remove_ruby_tag(content))      
      end 
      
    private      
      def remove_ruby_tag(content_with_tag)      
        content_with_tag.gsub(/<ruby\sfile\=\"(.*?)\"\s*\/>/, '\1')  
      end                                                 
        
      def find_file_contents(filename)
        begin
          if !File.exists?(filename)
            if filename[0...1] == "~"
              filename = File.expand_path(filename)
            else
              # points to spec/doc/ with an absolute path
              # notice the extra slash at the end.  This is there because 
              # the docs, as they stand now assume the added slash
              # the added / *probably* should come out later,
              # depending on what David & Aslak think, since they are 
              # the ones generating the docs
              filename = File.expand_path(File.dirname(__FILE__) + "/../#{filename}")
            end  
          end    
          File.read( filename )
        rescue
          raise "Given file <#{filename}> does not exist"
        end                
      end    
    end

  
  
    class RSpecContent < String
      # Will parse the content for <ruby>...</ruby> html tags and
       # <ruby file="..." />.  Note that all other content will 
       # be assumed to be textile.   
      def initialize(content)
        @original_content = content
        @content = parse_to_redcloth_content(content)    
      end      
      
      attr_reader :original_content
      attr_reader :content
      alias :to_redcloth :content
      
      def to_html
        redcloth_to_html(@content)
      end
      
      alias :to_s :content 
      alias :inspect :content

    private   
      #once you start some *real* html, can't provide redcloth or
      # ruby tags inside an <tag>...</tag> entity.
      # the content parser does not allow <ruby file='' />, only
      # <ruby file="">.  please modify this at your will  
      def parse_to_redcloth_content(content)
        return "" if content.nil? || content.empty?
        
        pre_match, redcloth_content, post_match = match_content(content)  
      
        parse_to_redcloth_content(pre_match) +
          redcloth_content +
          parse_to_redcloth_content(post_match)
      end 
      
      def match_content(content)
        if real_content = content.match(/<ruby>(.|\n)*?<\/ruby>/) 
          redcloth_content = RubyHtml.new(real_content[0]).to_redcloth        
        elsif real_content = content.match(/<ruby file\=\".+?\"\s*\/>/)         
          redcloth_content = RubyHtmlFile.new(real_content[0]).to_redcloth  
        elsif invalid_content = content.match(/<ruby.*>/)
          raise "Invalid Ruby HTML tag.  The Ruby Html tag must be declared in one of " +
                "the two following ways: \n" +
                "  1. <ruby>...inline_ruby...</ruby>\n" +
                "  2. <ruby filename=\"filename\" />\n" +
                "But it was declared as #{invalid_content[0]}\n"
        else
          return [nil, content, nil]
        end                                                     
        
        return [real_content.pre_match, redcloth_content, real_content.post_match]
      end                
      
      def redcloth_to_html(content)
        return "" if content.nil? || content.empty?
        begin
          RedCloth.new( content ).to_html
        rescue Exception => e
          raise "Error converting Textile text to HTML: #{e.message}"   
        end
      end
    end
  end
end      