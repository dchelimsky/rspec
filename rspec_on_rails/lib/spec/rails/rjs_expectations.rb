module Spec
  module Rails
    module RjsExpectations
      include ActionView::Helpers::PrototypeHelper

      def should_have_rjs(action, *args, &block)
        respond_to?("should_#{action}") ?
          send("should_#{action}", *args) :
          lined_response.should_include(create_generator.send(action, *args, &block))
      end

      def should_not_have_rjs(action, *args, &block)
        respond_to?("should_not_#{action}") ?
          send("should_not_#{action}", *args) :
          lined_response.should_not_include(create_generator.send(action, *args, &block))
      end
      
      def to_s
        @response_body.to_s
      end

      protected
      
      def should_page(*args)
        content = build_method_chain!(args)
        @response_body.should_match Regexp.new(Regexp.escape(content))
      end

      def should_not_page(*args)
        content = build_method_chain!(args)
        @response_body.should_not_match Regexp.new(Regexp.escape(content))
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

      def should_effect(*args)
        should_effect_helper('', *args)
      end
      
      def should_not_effect(*args)
        should_effect_helper('not_', *args)
      end
      
      def should_insert_html(*args)
        should_insert_html_helper('', *args)
      end

      def should_not_insert_html(*args)
        should_insert_html_helper('not_', *args)
      end

      def should_replace_html(*args)
        should_replace_html_helper('', *args)
      end
      
      def should_not_replace_html(*args)
        should_replace_html_helper('not_', *args)
      end
      
      def should_replace(*args)
        should_replace_helper('', *args)
      end

      def should_not_replace(*args)
        should_replace_helper('not_', *args)
      end

      private

      def should_effect_helper(predicate, *args)
        effect = args.shift
        div = args.shift
        regex = if ActionView::Helpers::ScriptaculousHelper::TOGGLE_EFFECTS.include? effect
          Regexp.new("Effect.toggle(.*#{div}.*'#{effect.to_s.gsub(/^toggle_/,'')}'.*);")
        else
          Regexp.new("Effect.#{effect.to_s.camelize}(.*#{div}.*);")
        end
        @response_body.__send__ "should_#{predicate}match", regex
      end
      
      def should_insert_html_helper(predicate, *args)
        position = args.shift
        item_id = args.shift
        content = extract_matchable_content(args)
        
        unless content.blank?
          case content
            when Regexp
              @response_body.__send__ "should_#{predicate}match", Regexp.new("new Insertion\.#{position.to_s.camelize}(.*#{item_id}.*,.*#{content.source}.*);")
            when String
              lined_response.__send__ "should_#{predicate}include", ("new Insertion.#{position.to_s.camelize}(\"#{item_id}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          @response_body.__send__ "should_#{predicate}match", Regexp.new("new Insertion\.#{position.to_s.camelize}(.*#{item_id}.*,.*?);")
        end
      end

      def should_replace_html_helper(predicate, *args)
        div = args.shift
        content = extract_matchable_content(args)

        unless content.blank?
          case content
            when Regexp
              self.to_s.__send__ "should_#{predicate}match", Regexp.new("Element.update(.*#{div}.*,.*#{content.source}.*);")
            when String
              lined_response.__send__ "should_#{predicate}include", ("Element.update(\"#{div}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          @response_body.__send__ "should_#{predicate}match", Regexp.new("Element.update(.*#{div}.*,.*?);")
        end
      end
      
      def should_replace_helper(predicate, *args)
        div = args.shift
        content = extract_matchable_content(args)

        unless content.blank?
          case content
            when Regexp
              self.to_s.__send__ "should_#{predicate}match", Regexp.new("Element.replace(.*#{div}.*,.*#{content.source}.*);")
            when String
              lined_response.__send__ "should_#{predicate}include", ("Element.replace(\"#{div}\", #{content});")
            else
              raise "Invalid content type"
          end
        else
          @response_body.__send__ "should_#{predicate}match", Regexp.new("Element.replace(.*#{div}.*,.*?);")
        end
      end

      def lined_response
        @response_body.split("\n")
      end

      def create_generator
        block = Proc.new { |*args| yield *args if block_given? } 
        JavaScriptGenerator.new @response_body, &block
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