module Spec
  module Expectations
    module TagExpectations
      def should_have_tag(*opts)
        raise_rspec_error(" should include ", opts) if find_tag(*opts).nil?
      end

      def should_not_have_tag(*opts)
        raise_rspec_error(" should not include ", opts) unless find_tag(*opts).nil?
      end

      private 

      def raise_rspec_error(message, *opts)
        Kernel::raise(Spec::Expectations::ExpectationNotMetError.new(self + message + opts.inspect))
      end

      def find_tag(*opts)
        opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
        HTML::Document.new(self).find(opts)
      end
    end
  end
end

module Spec
  module Expectations
    module RjsExpectations
      include ActionView::Helpers::PrototypeHelper

      def should_have_rjs(action, *args, &block)
        respond_to?("should_#{action}")?
          send("should_#{action}", *args) :
          lined_response.should_include(create_generator.send(action, *args, &block))
      end

      def should_not_have_rjs(action, *args, &block)
        respond_to?("should_not_#{action}")?
          send("should_not_#{action}", *args) :
          lined_response.should_not_include(create_generator.send(action, *args, &block))
      end

      protected

      def should_page(*args)
        content = build_method_chain!(args)
        self.to_s.should_match Regexp.new(Regexp.escape(content))
      end

      def should_not_page(*args)
        content = build_method_chain!(args)
        self.to_s.should_not_match Regexp.new(Regexp.escape(content))
      end

      def build_method_chain!(args)
        content = create_generator.send(:[], args.shift) # start $('some_id')....

        while !args.empty?
          if (method = args.shift.to_s) =~ /(.*)=$/
            content = content.__send__(method, args.shift)
            break
          else
            content = content.__send__(method)
            content = content.__send__(:function_chain).first if args.empty?
          end
        end

        content
      end

      def should_insert_html(*args)
        position = args.shift
        item_id = args.shift
        content = extract_matchable_content(args)
        
        unless content.blank?
          case content
            when Regexp
              self.to_s.should_match Regexp.new("new Insertion\.#{position.to_s.camelize}(.*#{item_id}.*,.*#{content.source}.*);")
            when String
              lined_response.should_include("new Insertion.#{position.to_s.camelize}(\"#{item_id}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          self.to_s.should_match Regexp.new("new Insertion\.#{position.to_s.camelize}(.*#{item_id}.*,.*?);")
        end
      end

      def should_not_insert_html(*args)
        position = args.shift
        item_id = args.shift
        content = extract_matchable_content(args)

        unless content.blank?
          case content
            when Regexp
              self.to_s.should_not_match Regexp.new("new Insertion\.#{position.to_s.camelize}(.*#{item_id}.*,.*#{content.source}.*);")
            when String
              lined_response.should_not_include("new Insertion.#{position.to_s.camelize}(\"#{item_id}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          self.to_s.should_not_match Regexp.new("new Insertion\.#{position.to_s.camelize}(.*#{item_id}.*,.*?);")
        end
      end

      def should_replace_html(*args)
        div = args.shift
        content = extract_matchable_content(args)

        unless content.blank?
          case content
            when Regexp
              self.to_s.should_match Regexp.new("Element.update(.*#{div}.*,.*#{content.source}.*);")
            when String
              lined_response.should_include("Element.update(\"#{div}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          self.to_s.should_match Regexp.new("Element.update(.*#{div}.*,.*?);")
        end
      end
      
      def should_not_replace_html(*args)
        div = args.shift
        content = extract_matchable_content(args)

        unless content.blank?
          case content
            when Regexp
              self.to_s.should_not_match Regexp.new("Element.update(.*#{div}.*,.*#{content.source}.*);")
            when String
              lined_response.should_not_include("Element.update(\"#{div}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          self.to_s.should_not_match Regexp.new("Element.update(.*#{div}.*,.*?);")
        end
      end
      
      def should_replace(*args)
        div = args.shift
        content = extract_matchable_content(args)

        unless content.blank?
          case content
            when Regexp
              self.to_s.should_match Regexp.new("Element.replace(.*#{div}.*,.*#{content.source}.*);")
            when String
              lined_response.should_include("Element.replace(\"#{div}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          self.to_s.should_match Regexp.new("Element.replace(.*#{div}.*,.*?);")
        end
      end

      def should_not_replace(*args)
        div = args.shift
        content = extract_matchable_content(args)

        unless content.blank?
          case content
            when Regexp
              self.to_s.should_not_match Regexp.new("Element.replace(.*#{div}.*,.*#{content.source}.*);")
            when String
              lined_response.should_not_include("Element.replace(\"#{div}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          self.to_s.should_not_match Regexp.new("Element.replace(.*#{div}.*,.*?);")
        end
      end

      private

      def lined_response
        self.to_s.split("\n")
      end

      def create_generator
        block = Proc.new { |*args| yield *args if block_given? } 
        JavaScriptGenerator.new self, &block
      end

      def extract_matchable_content(args)
        if args.size == 1 and args.first.is_a? Regexp
          return args.first
        else
          return create_generator.send(:arguments_for_call, args)
        end
      end

    end
  end
end

class ResponseBody < String
  include Spec::Expectations::TagExpectations
  include Spec::Expectations::RjsExpectations
end

module ActionController
  class TestResponse
    def should_render(expected=nil)
      expected = expected.to_s unless expected.nil?
      rendered = expected ? rendered_file(!expected.include?('/')) : rendered_file
      expected.should_equal rendered
    end
    
    def should_have_rjs element, *args
      ResponseBody.new(self.body).should_have_rjs element, *args
    end

    def should_not_have_rjs element, *args
      ResponseBody.new(self.body).should_not_have_rjs element, *args
    end

    def should_have_tag tag, *opts
      ResponseBody.new(self.body).should_have_tag tag, *opts
    end

    def should_not_have_tag tag, *opts
      ResponseBody.new(self.body).should_not_have_tag tag, *opts
    end
  end
end