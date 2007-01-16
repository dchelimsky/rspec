# assert_select plugins for Rails
#
# Copyright (c) 2006 Assaf Arkin, under Creative Commons Attribution and/or MIT License
# Developed for http://co.mments.com
# Code and documention: http://labnotes.org


module Spec #:nodoc:
  module Rails #:nodoc:
    module Matchers

      # Adds the #assert_select method for use in Rails functional
      # test cases.
      #
      # Use #assert_select to make assertions on the response HTML of a controller
      # action. You can also call #assert_select within another #assert_select to
      # make assertions on elements selected by the enclosing assertion.
      #
      # Use #css_select to select elements without making an assertions, either
      # from the response HTML or elements selected by the enclosing assertion.
      #
      # In addition to HTML responses, you can make the following assertions:
      # * #assert_select_rjs    -- Assertions on HTML content of RJS update and
      #     insertion operations.
      # * #assert_select_feed   -- Assertions on the response Atom or RSS feed,
      #     using CSS selectors to select XML elements.
      # * #assert_select_encoded  -- Assertions on HTML encoded inside XML,
      #     for example for dealing with feed item descriptions.
      # * #assert_select_email    -- Assertions on the HTML body of an e-mail.
      # 
      # Also see HTML::Selector for learning how to use selectors.
      class AssertSelect 
        attr_reader :response, :failure_message, :negative_failure_message
        
        def initialize(*args, &block)
          @args = args
          @block = block
        end
        
        def met_by?(target)
          @response = target
          assert_select(*@args, &@block)
        end
        
        def fail_with(failure_message, negative_failure_message)
          @failure_message = failure_message
          @negative_failure_message = negative_failure_message
          return false
        end
        
        unless const_defined?(:NO_STRIP)
          NO_STRIP = %w{pre script style textarea}
        end

        # :call-seq:
        #   css_select(selector) => array
        #   css_select(element, selector) => array
        #
        # Select and return all matching elements.
        #
        # If called with a single argument, uses that argument as a selector
        # to match all elements of the current page. Returns an empty array
        # if no match is found.
        #
        # If called with two arguments, uses the first argument as the base
        # element and the second argument as the selector. Attempts to match the
        # base element and any of its children. Returns an empty array if no
        # match is found.
        #
        # The selector may be a CSS selector expression (+String+), an expression
        # with substitution values (+Array+) or an HTML::Selector object.
        #
        # For example:
        #   forms = css_select("form")
        #   forms.each do |form|
        #     inputs = css_select(form, "input")
        #     ...
        #   end
        def css_select(*args)
          # See assert_select to understand what's going on here.
          arg = args.shift
          if arg.is_a?(HTML::Node)
            root = arg
            arg = args.shift
          elsif arg == nil
            raise ArgumentError, "First arugment is either selector or element to select, but nil found. Perhaps you called assert_select with an element that does not exist?"
          elsif @selected
            matches = []
            @selected.each do |selected|
              subset = css_select(selected, HTML::Selector.new(arg.dup, args.dup))
              subset.each do |match|
                matches << match unless matches.any? { |m| m.equal?(match) }
              end
            end
            return matches
          else
            root = response_from_page_or_rjs
          end
          case arg
            when String
              selector = HTML::Selector.new(arg, args)
            when Array
              selector = HTML::Selector.new(*arg)
            when HTML::Selector 
              selector = arg
            else raise ArgumentError, "Expecting a selector as the first argument"
          end

          selector.select(root)  
        end


        # :call-seq:
        #   assert_select(selector, equality?, message?)
        #   assert_select(element, selector, equality?, message?)
        #
        # An assertion that selects elements and makes one or more equality tests.
        #
        # If the first argument is an element, selects all matching elements
        # starting from (and including) that element and all its children in
        # depth-first order.
        #
        # If no element if specified, calling #assert_select will select from the
        # response HTML. Calling #assert_select inside an #assert_select block will
        # run the assertion for each element selected by the enclosing assertion.
        #
        # For example:
        #   assert_select "ol>li" do |elements|
        #     elements.each do |element|
        #       assert_select element, "li"
        #     end
        #   end
        # Or for short:
        #   assert_select "ol>li" do
        #     assert_select "li"
        #   end
        #
        # The selector may be a CSS selector expression (+String+), an expression
        # with substitution values, or an HTML::Selector object.
        #
        # === Equality Tests
        #
        # The equality test may be one of the following:
        # * <tt>true</tt> -- Assertion is true if at least one element selected.
        # * <tt>false</tt> -- Assertion is true if no element selected.
        # * <tt>String/Regexp</tt> -- Assertion is true if the text value of at least
        #   one element matches the string or regular expression.
        # * <tt>Integer</tt> -- Assertion is true if exactly that number of
        #   elements are selected.
        # * <tt>Range</tt> -- Assertion is true if the number of selected
        #   elements fit the range.
        # If no equality test specified, the assertion is true if at least one
        # element selected.
        #
        # To perform more than one equality tests, use a hash with the following keys:
        # * <tt>:text</tt> -- Narrow the selection to elements that have this text
        #   value (string or regexp).
        # * <tt>:html</tt> -- Narrow the selection to elements that have this HTML
        #   content (string or regexp).
        # * <tt>:count</tt> -- Assertion is true if the number of selected elements
        #   is equal to this value.
        # * <tt>:minimum</tt> -- Assertion is true if the number of selected
        #   elements is at least this value.
        # * <tt>:maximum</tt> -- Assertion is true if the number of selected
        #   elements is at most this value.
        #
        # If the method is called with a block, once all equality tests are
        # evaluated the block is called with an array of all selected elements.
        #
        # === Examples
        # 
        #   # At least one form element
        #   assert_select "form"
        #
        #   # Form element includes four input fields
        #   assert_select "form input", 4
        #
        #   # Page title is "Welcome"
        #   assert_select "title", "Welcome"
        #
        #   # Page title is "Welcome" and there is only one title element
        #   assert_select "title", {:count=>1, :text=>"Welcome"},
        #       "Wrong title or more than one title element"
        #
        #   # Page contains no forms
        #   assert_select "form", false, "This page must contain no forms"
        #
        #   # Test the content and style
        #   assert_select "body div.header ul.menu"
        #
        #   # Use substitution values
        #   assert_select "ol>li#?", /item-\d+/
        #
        #   # All input fields in the form have a name
        #   assert_select "form input" do
        #     assert_select "[name=?]", /.+/  # Not empty
        #   end
        def assert_select(*args, &block)
          # Start with optional element followed by mandatory selector.
          element = arg = args.shift
          if arg.is_a?(HTML::Node)
            # First argument is a node (tag or text, but also HTML root),
            # so we know what we're selecting from.
            root = arg
            arg = args.shift
          elsif arg == nil
            # This usually happens when passing a node/element that
            # happens to be nil.
            raise ArgumentError, "First arugment is either selector or element to select, but nil found. Perhaps you called assert_select with an element that does not exist?"
          elsif @selected
            root = HTML::Node.new(nil)
            root.children.concat @selected
          else
            # Otherwise just operate on the response document.
            root = response_from_page_or_rjs
          end

          # First or second argument is the selector: string and we pass
          # all remaining arguments. Array and we pass the argument. Also
          # accepts selector itself.
          case arg
            when String
              selector = HTML::Selector.new(arg, args)
            when Array
              selector = HTML::Selector.new(*arg)
            when HTML::Selector 
              selector = arg
            else raise ArgumentError, "Expecting a selector as the first argument"
          end

          # Next argument is used for equality tests.
          equals = {}
          case arg = args.shift
            when Hash
              equals = arg
            when String, Regexp
              equals[:text] = arg
            when Integer
              equals[:count] = arg
            when Range
              equals[:minimum] = arg.begin
              equals[:maximum] = arg.end
            when FalseClass
              equals[:count] = 0
            when NilClass, TrueClass
              equals[:minimum] = 1
            else raise ArgumentError, "I don't understand what you're trying to match"
          end

          # By default we're looking for at least one match.
          if equals[:count]
            equals[:minimum] = equals[:maximum] = equals[:count]
          else
            equals[:minimum] = 1 unless equals[:minimum]
          end

          # Last argument is the message we use if the assertion fails.
          message = args.shift
          #- message = "No match made with selector #{selector.inspect}" unless message
          if args.shift
            raise ArgumentError, "Not expecting that last argument, you either have too many arguments, or they're the wrong type"
          end

          matches = selector.select(root)
          # If text/html, narrow down to those elements that match it.
          content_mismatch = nil
          if match_with = equals[:text]
            matches.delete_if do |match|
              text = ""
              stack = match.children.reverse
              while node = stack.pop
                if node.tag?
                  stack.concat node.children.reverse
                else
                  text << node.content
                end
              end
              text.strip! unless NO_STRIP.include?(match.name)
              unless match_with.is_a?(Regexp) ? (text =~ match_with) : (text == match_with.to_s)
                content_mismatch ||= "Expected <#{element}> with #{match_with.is_a?(Regexp) ? "text matching " : ""}#{match_with.inspect}"
                true
              end
            end
          elsif match_with = equals[:html]
            matches.delete_if do |match|
              html = match.children.map(&:to_s).join
              html.strip! unless NO_STRIP.include?(match.name)
              unless match_with.is_a?(Regexp) ? (html =~ match_with) : (html == match_with.to_s)
                content_mismatch ||= "Expected <#{element}> with #{match_with.is_a?(Regexp) ? "text matching " : ""}#{match_with.inspect}"
                true
              end
            end
          end
          # Expecting foo found bar element only if found zero, not if
          # found one but expecting two.
          message ||= content_mismatch if matches.empty?
          # Test minimum/maximum occurrence.
          if equals[:minimum]
            unless matches.size >= equals[:minimum]
              return fail_with(
                message || "Expected at least #{equals[:minimum]} <#{element}> tag#{equals[:minimum] > 1 ? 's' : ''}, found #{matches.size}",
                nil
              )
            end
          end
          if equals[:maximum]
            unless matches.size <= equals[:maximum]
              return fail_with(
                message || "Expected at most #{equals[:maximum]} <#{element}> tag#{equals[:maximum] == 1 ? '' : 's'}, found #{matches.size}",
                nil
              )
            end
          end

          # If a block is given call that block. Set @selected to allow
          # nested assert_select, which can be nested several levels deep.
          if block_given? and !matches.empty?
            begin
              in_scope, @selected = @selected, matches
              yield matches
            ensure
              @selected = in_scope
            end
          end

          # Returns all matches elements.
          matches
        end

        # :call-seq:
        #   assert_select_rjs(id?) { |elements| ... }
        #   assert_select_rjs(statement, id?) { |elements| ... }
        #   assert_select_rjs(:insert, position, id?) { |elements| ... }
        #
        # Selects content from the RJS response.
        #
        # === Narrowing down
        #
        # With no arguments, asserts that one or more elements are updated or
        # inserted by RJS statements.
        #
        # Use the +id+ argument to narrow down the assertion to only statements
        # that update or insert an element with that identifier.
        #
        # Use the first argument to narrow down assertions to only statements
        # of that type. Possible values are +:replace+, +:replace_html+ and
        # +:insert_html+.
        #
        # Use the argument +:insert+ followed by an insertion position to narrow
        # down the assertion to only statements that insert elements in that
        # position. Possible values are +:top+, +:bottom+, +:before+ and +:after+.
        #
        # === Using blocks
        #
        # Without a block, #assert_select_rjs merely asserts that the response
        # contains one or more RJS statements that replace or update content.
        #
        # With a block, #assert_select_rjs also selects all elements used in
        # these statements and passes them to the block. Nested assertions are
        # supported.
        #
        # Calling #assert_select_rjs with no arguments and using nested asserts
        # asserts that the HTML content is returned by one or more RJS statements.
        # Using #assert_select directly makes the same assertion on the content,
        # but without distinguishing whether the content is returned in an HTML
        # or JavaScript.
        #
        # === Examples
        #
        #   # Updating the element foo.
        #   assert_select_rjs :update, "foo"
        #
        #   # Inserting into the element bar, top position.
        #   assert_select rjs, :insert, :top, "bar"
        #
        #   # Changing the element foo, with an image.
        #   assert_select_rjs "foo" do
        #     assert_select "img[src=/images/logo.gif""
        #   end
        #
        #   # RJS inserts or updates a list with four items.
        #   assert_select_rjs do
        #     assert_select "ol>li", 4
        #   end
        #
        #   # The same, but shorter.
        #   assert_select "ol>li", 4
        def assert_select_rjs(*args, &block)
          arg = args.shift
          # If the first argument is a symbol, it's the type of RJS statement we're looking
          # for (update, replace, insertion, etc). Otherwise, we're looking for just about
          # any RJS statement.
          if arg.is_a?(Symbol)
            if arg == :insert
              arg = args.shift
              insertion = "insert_#{arg}".to_sym
              raise ArgumentError, "Unknown RJS insertion type #{arg}" unless RJS_STATEMENTS[insertion]
              statement = "(#{RJS_STATEMENTS[insertion]})"
            else
              raise ArgumentError, "Unknown RJS statement type #{arg}" unless RJS_STATEMENTS[arg]
              statement = "(#{RJS_STATEMENTS[arg]})"
            end
            arg = args.shift
          else
            statement = "#{RJS_STATEMENTS[:any]}"
          end

          # Next argument we're looking for is the element identifier. If missing, we pick
          # any element.
          if arg.is_a?(String)
            id = Regexp.quote(arg)
            arg = args.shift
          else
            id = "[^\"]*"
          end

          pattern = Regexp.new("#{statement}\\(\"#{id}\", #{RJS_PATTERN_HTML}\\)", Regexp::MULTILINE)
          
          # Duplicate the body since the next step involves destroying it.
          matches = nil
          @response.body.dup.gsub(pattern) do |match|
            html = $2
            # RJS encodes double quotes and line breaks.
            html.gsub!(/\\"/, "\"")
            html.gsub!(/\\n/, "\n")
            matches ||= []
            matches.concat HTML::Document.new(html).root.children.select { |n| n.tag? }
            ""
          end
          if matches
            if block_given?
              begin
                in_scope, @selected = @selected, matches
                yield matches
              ensure
                @selected = in_scope
              end
            end
            matches
          else
            # RJS statement not found.
            flunk args.shift || "No RJS statement that replaces or inserts HTML content."
          end
        end


        # :call-seq:
        #   assert_select_feed(type, version?) { ... }
        #
        # Selects root of the feed element. Calls the block for nested assertions.
        #
        # The feed type may be <tt>:atom</tt> or <tt>:rss</tt>. Currently supported
        # are versions 2.0 (default) and 0.92 for RSS and versions 0.3 and 1.0 (default)
        # for Atom.
        #
        # === Example
        #
        #   assert_select_feed :rss, 2.0 do
        #     assert_select "title", "My feed"
        #     assert_select "item" do |items|
        #       . . .
        #     end
        #   end
        def assert_select_feed(type, version = nil, &block)
          root = HTML::Document.new(@response.body, true, true).root
          case [type.to_sym, version && version.to_s]
            when [:rss, "2.0"], [:rss, "0.92"], [:rss, nil]
              version = "2.0" unless version
              selector = HTML::Selector.new("rss:root[version=?]", version)
            when [:atom, "0.3"]
              selector = HTML::Selector.new("feed:root[version=0.3]")
            when [:atom, "1.0"], [:atom, nil]
              selector = HTML::Selector.new("feed:root[xmlns='http://www.w3.org/2005/Atom']")
            else
              raise ArgumentError, "Unsupported feed type #{type} #{version}"
          end
          assert_select root, selector, &block
        end


        # :call-seq:
        #   assert_select_encoded(element?) { |elements| ... }
        #
        # Extracts the content of an element, treats it as encoded HTML and runs
        # nested assertion on it.
        #
        # You typically call this method within another assertion to operate on
        # all currently selected elements. You can also pass an element or array
        # of elements.
        #
        # The content of each element is un-encoded, and wrapped in the root
        # element +encoded+. It then calls the block with all un-encoded elements.
        #
        # === Example
        #
        #   assert_select_feed :rss, 2.0 do
        #     # Select description element of each feed item. 
        #     assert_select "channel>item>description" do
        #       # Run assertions on the encoded elements.
        #       assert_select_encoded do
        #         assert_select "p"
        #       end
        #     end
        #   end
        def assert_select_encoded(element = nil, &block)
          case element
            when Array
              elements = element
            when HTML::Node
              elements = [element]
            when nil
              unless elements = @selected
                raise ArgumentError, "First argument is optional, but must be called from a nested assert_select"
              end
            else
              raise ArgumentError, "Argument is optional, and may be node or array of nodes"
          end
          fix_content = lambda do |node|
            # Gets around a bug in the Rails 1.1 HTML parser.
            node.content.gsub(/<!\[CDATA\[(.*)(\]\]>)?/m) { CGI.escapeHTML($1) }
          end

          selected = elements.map do |element|
            text = element.children.select{ |c| not c.tag? }.map{ |c| fix_content[c] }.join
            root = HTML::Document.new(CGI.unescapeHTML("<encoded>#{text}</encoded>")).root
            css_select(root, "encoded:root", &block)[0]
          end
          begin
            old_selected, @selected = @selected, selected
            assert_select ":root", &block
          ensure
            @selected = old_selected
          end
        end


        # :call-seq:
        #   assert_select_email { }
        #
        # Extracts the body of an email and runs nested assertions on it.
        #
        # You must enable deliveries for this assertion to work, use:
        #   ActionMailer::Base.perform_deliveries = true
        #
        # === Example
        #
        # assert_select_email do
        #   assert_select "h1", "Email alert"
        # end
        def assert_select_email(&block)
          deliveries = ActionMailer::Base.deliveries
          assert !deliveries.empty?, "No e-mail in delivery list"
          for delivery in deliveries
            root = HTML::Document.new(delivery.body).root
            assert_select root, ":root", &block
          end
        end


      protected
        def html_document
          @html_document ||= HTML::Document.new(response.body)
        end


        unless const_defined?(:RJS_STATEMENTS)
          RJS_STATEMENTS = {
            :replace      => /Element\.replace/,
            :replace_html => /Element\.update/
          }
          RJS_INSERTIONS = [:top, :bottom, :before, :after]
          RJS_INSERTIONS.each do |insertion|
            RJS_STATEMENTS["insert_#{insertion}".to_sym] = Regexp.new(Regexp.quote("new Insertion.#{insertion.to_s.camelize}"))
          end
          RJS_STATEMENTS[:any] = Regexp.new("(#{RJS_STATEMENTS.values.join('|')})")
          RJS_STATEMENTS[:insert_html] = Regexp.new(RJS_INSERTIONS.collect do |insertion|
            Regexp.quote("new Insertion.#{insertion.to_s.camelize}")
          end.join('|'))
          RJS_PATTERN_HTML = /"((\\"|[^"])*)"/
          RJS_PATTERN_EVERYTHING = Regexp.new("#{RJS_STATEMENTS[:any]}\\(\"([^\"]*)\", #{RJS_PATTERN_HTML}\\)",
                                              Regexp::MULTILINE)
        end


        # #assert_select and #css_select call this to obtain the content in the HTML
        # page, or from all the RJS statements, depending on the type of response.
        def response_from_page_or_rjs()
          content_type = @response.headers["Content-Type"]
          if content_type and content_type =~ /text\/javascript/
            body = @response.body.dup
            root = HTML::Node.new(nil)
            while true
              next if body.sub!(RJS_PATTERN_EVERYTHING) do |match|
                # RJS encodes double quotes and line breaks.
                html = $3
                html.gsub!(/\\"/, "\"")
                html.gsub!(/\\n/, "\n")
                matches = HTML::Document.new(html).root.children.select { |n| n.tag? }
                root.children.concat matches
                ""
              end
              break
            end
            root
          else
            html_document.root
          end
        end

      end
    end
  end
end