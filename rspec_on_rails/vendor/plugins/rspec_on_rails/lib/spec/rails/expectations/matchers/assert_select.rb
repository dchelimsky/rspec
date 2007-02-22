# This is a port of assert_select for rspec.
# Note that the docs are still in transition....

# assert_select plugins for Rails
#
# Copyright (c) 2006 Assaf Arkin, under Creative Commons Attribution and/or MIT License
# Developed for http://co.mments.com
# Code and documention: http://labnotes.org

module Spec # :nodoc:
  module Rails
    module Expectations
      module Matchers
      
        class AssertSelect  #:nodoc:

          cattr_accessor :selected
          attr_reader :failure_message, :negative_failure_message
        
          def initialize(*args, &block)
            @response = args.shift
            @select_type = determine_select_type(*args)
            @args = args
            @block = block
          end
        
          def matches?(target, &block)
            @block = block if block
            @@selected  = determine_selected(target)
            case @select_type
              when "rjs"
                assert_select_rjs(*@args, &@block)
              when "feed"
                if Hash === @args.last
                  @args.delete(@args.last)
                end
                assert_select_feed(*@args, &@block)
              when "encoded"
                if Hash === @args.last
                  @args.delete(@args.last)
                end
                assert_select_encoded(*@args, &@block)
              when "email"
                if Hash === @args.last
                  @args.delete(@args.last)
                end
                assert_select_email(*@args, &@block)
              else
                assert_select(*@args, &@block)
            end
          end
        
          def fail_with(failure_message, negative_failure_message=nil)
            @failure_message = failure_message
            @negative_failure_message = negative_failure_message
            return false
          end
        
          unless const_defined?(:NO_STRIP)
            NO_STRIP = %w{pre script style textarea}
          end

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
            elsif @@selected 
              root = HTML::Node.new(nil)
              root.children.concat @@selected 
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

            # If a block is given call that block. Set @@selected  to allow
            # nested assert_select, which can be nested several levels deep.
            unless matches.empty?
              if block_given?
                begin
                  in_scope, @@selected  = @@selected , matches
                  yield matches
                ensure
                  @@selected  = in_scope
                end
              end
            end
          
            if @@selected == @response
              @@selected = nil
            end

            # Returns all matches elements.
            matches
          end
        
          def assert_select_rjs(*args, &block)
            arg = args.shift
            rjs_type = arg
            # If the first argument is a symbol, it's the type of RJS statement we're looking
            # for (update, replace, insertion, etc). Otherwise, we're looking for just about
            # any RJS statement.
            if arg.is_a?(Symbol)
              if arg == :insert
                arg = args.shift
                insertion = "insert_#{arg}".to_sym
                raise ArgumentError, "Unknown RJS insertion type #{arg}" unless RJS_STATEMENTS[insertion]
                statement = "(#{RJS_STATEMENTS[insertion]})"
              elsif arg == :effect
                rjs_type = arg = args.shift
                if rjs_type.starts_with?("toggle")
                  effect = "effect_toggle".to_sym
                  toggle_type = rjs_type.to_s.split('_')[1].to_sym
                else
                  effect = "effect_#{arg}".to_sym
                end
                raise ArgumentError, "Unknown RJS effect type #{arg}" unless RJS_STATEMENTS[effect]
                statement = "(#{RJS_STATEMENTS[effect]})"
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

            matches = []
            matches.concat(match_rjs_with_html(@response, statement, id))
            matches.concat(match_page_rjs_with_html(@response, statement, id))
          
            if !matches.empty?
              if block_given?
                begin
                  in_scope, @@selected  = @@selected , matches
                  yield matches
                ensure
                  @@selected  = in_scope
                end
              end
              return matches
            elsif match_rjs_without_html(@response, statement, id) || match_page_rjs_without_html(@response, statement, id)
              true
            elsif match_effect_rjs(@response, statement, id)
              true
            elsif match_toggle_rjs(@response, statement, toggle_type, id)
              true
            else
              fail_with(args.shift || "No RJS statement with #{rjs_type.inspect}")
            end
          end
        
          def decode_rjs_html(html)
            html.gsub!(/\\"/, "\"")
            html.gsub!(/\\n/, "\n")
          end
        
          def match_rjs_with_html(response, statement, id)
            html_pattern = Regexp.new("#{statement}\\(\"#{id}\", #{RJS_PATTERN_HTML}\\)", Regexp::MULTILINE)
            matches = []
            response.body.dup.gsub(html_pattern) do
              if html = $2
                decode_rjs_html(html)
                matches.concat HTML::Document.new(html).root.children.select { |n| n.tag? }
              end
            end
            matches
          end
        
          def match_page_rjs_with_html(response, statement, id)
            pattern = Regexp.new("\\$\\(\"#{id}\"\\)\\.#{statement.gsub("Element\\.","")}\\(#{RJS_PATTERN_HTML}\\)", Regexp::MULTILINE)
            matches = []
            response.body.dup.gsub(pattern) do
              if html = $3
                decode_rjs_html(html)
                matches.concat HTML::Document.new(html).root.children.select { |n| n.tag? }
              end
            end
            matches
          end
        
          def match_rjs_without_html(response, statement, id)
            no_html_pattern = Regexp.new("#{statement}\\(\"#{id}\"\\)", Regexp::MULTILINE)
            @response.body.dup.gsub(no_html_pattern) { return [] }
            nil
          end
        
          def match_effect_rjs(response, statement, id)
            no_html_pattern = Regexp.new("#{statement}\\(\"#{id}\",\\{\\}\\)", Regexp::MULTILINE)
            @response.body.dup.gsub(no_html_pattern) { return [] }
            nil
          end
        
          def match_toggle_rjs(response, statement, toggle_type, id)
            pattern = Regexp.new("#{statement}\\(\"#{id}\",\'#{toggle_type.to_s}\',\\{\\}\\)", Regexp::MULTILINE)
            @response.body.dup.gsub(pattern) { return [] }
            nil
          end
        
          def match_page_rjs_without_html(response, statement, id)
            pattern = Regexp.new("\\$\\(\"#{id}\"\\)\\.#{statement.gsub("Element\\.","")}", Regexp::MULTILINE)
            @response.body.dup.gsub(pattern) { return true }
            false
          end
        
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

          def assert_select_encoded(element = nil, &block)
            case element
              when Array
                elements = element
              when HTML::Node
                elements = [element]
              when nil
                unless elements = @@selected 
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
              old_selected, @@selected  = @@selected , selected
              assert_select ":root", &block
            ensure
              @@selected  = old_selected
            end
          end

          def assert_select_email(&block)
            deliveries = ActionMailer::Base.deliveries
            return fail_with("No e-mail in delivery list") if deliveries.empty?
            for delivery in deliveries
              root = HTML::Document.new(delivery.body).root
              assert_select root, ":root", &block
            end
          end

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


        protected
          def html_document
            @html_document ||= HTML::Document.new(@response.body)
          end

          unless const_defined?(:RJS_STATEMENTS)
            RJS_STATEMENTS = {
              :replace      => /Element\.replace/,
              :replace_html => /Element\.update/,
              :hide => /Element\.hide/
            }
            RJS_INSERTIONS = [:top, :bottom, :before, :after]
            RJS_INSERTIONS.each do |insertion|
              RJS_STATEMENTS["insert_#{insertion}".to_sym] = Regexp.new(Regexp.quote("new Insertion.#{insertion.to_s.camelize}"))
            end
            [:fade, :puff, :highlight, :appear].each do |effect|
              RJS_STATEMENTS["effect_#{effect}".to_sym] = Regexp.new(Regexp.quote("new Effect.#{effect.to_s.camelize}"))
            end
            RJS_STATEMENTS[:effect_toggle] = Regexp.new(Regexp.quote("Effect.toggle"))
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
        
          private
            def determine_select_type(*args)
              if Hash === args.last
                select_type = args.last[:select_type]
              end
              return select_type ||= "tag"
            end
          
            def determine_selected(target)
              unless target.equal?(@response)
                if @@selected
                  return @@selected
                end
                if Array === target
                  return target
                else
                  return[target]
                end
              end
            end

          end
      
          # :call-seq:
          #   response.should have_tag(selector, equality?, message?)
          #   response.should have_tag(element, selector, equality?, message?)
          #   response.should_not have_tag(selector, equality?, message?)
          #   response.should_not have_tag(element, selector, equality?, message?)
          #
          # RSpec wrapper for <tt>assert_select</tt>
          #
          # Used to expect specific content in the response to an http request.
          #
          #   response.should have_tag("div", "Go Bears!")
          #
          # An expectation that selects elements and makes one or more equality comparisons.
          #
          # If the first argument is an element, selects all matching elements
          # starting from (and including) that element and all its children in
          # depth-first order.
          #
          # If no element if specified, calling #have_tag will select from the
          # response HTML. Calling #have_tag inside an #have_tag block will
          # run the assertion for each element selected by the enclosing assertion.
          #
          # For example:
          #   response.should have_tag("ol>li") do |elements|
          #     elements.each do |element|
          #       element.should have_tag("li")
          #     end
          #   end
          # Or for short:
          #   response.should have_tag("ol>li") do
          #     with_tag("li")
          #   end
          # The selector may be a CSS selector expression (+String+), an expression
          # with substitution values, or an HTML::Selector object.
          #
          # === Equality
          #
          # The equality test may be one of the following:
          # * <tt>true</tt> -- passes if at least one element selected.
          # * <tt>false</tt> -- passes if no element selected.
          # * <tt>String/Regexp</tt> -- passes if the text value of at least
          #   one element matches the string or regular expression.
          # * <tt>Integer</tt> -- passes if exactly that number of
          #   elements are selected.
          # * <tt>Range</tt> -- passes if the number of selected
          #   elements fit the range.
          # If no equality test specified, the expecatation passes if at least one
          # element selected.
          #
          # To set more than one equality expectation, use a hash with the following keys:
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
          # If the method is called with a block, once all expectations are
          # evaluated the block is called with an array of all selected elements.
          #
          # === Examples
          # 
          #   # At least one form element
          #   response.should have_tag("form")
          #
          #   # Form element includes four input fields
          #   response.should have_tag("form input", 4)
          #
          #   # Page title is "Welcome"
          #   response.should have_tag("title", "Welcome")
          #
          #   # Page title is "Welcome" and there is only one title element
          #   response.should have_tag("title", {:count=>1, :text=>"Welcome"},
          #       "Wrong title or more than one title element")
          #
          #   # Page contains no forms
          #   response.should have_tag("form", false, "This page must contain no forms")
          #
          #   # Test the content and style
          #   response.should have_tag("body div.header ul.menu")
          #
          #   # Use substitution values
          #   response.should have_tag("ol>li#?", /item-\d+/)
          #
          #   # All input fields in the form have a name
          #   response.should have_tag("form input") {
          #     with_tag("[name=?]", /.+/)
          #   }
          def have_tag(*args, &block)
            args.unshift(response)
            AssertSelect.new(*args, &block)
          end

          # :call-seq:
          #   response.should have_rjs(id?) { |elements| ... }
          #   response.should have_rjs(statement, id?) { |elements| ... }
          #   response.should have_rjs(:insert, position, id?) { |elements| ... }
          #   response.should_not have_rjs(id?) { |elements| ... }
          #   response.should_not have_rjs(statement, id?) { |elements| ... }
          #   response.should_not have_rjs(:insert, position, id?) { |elements| ... }
          #
          # RSpec wrapper for <tt>assert_select_rjs</tt>
          #
          # === Narrowing down
          #
          # With no arguments, expects that one or more elements are updated or
          # inserted by RJS statements.
          #
          # Use the +id+ argument to narrow down the expectation to only statements
          # that update or insert an element with that identifier.
          #
          # Use the first argument to narrow down expectations to only statements
          # of that type. Possible values are +:replace+, +:replace_html+ and
          # +:insert_html+.
          #
          # Use the argument +:insert+ followed by an insertion position to narrow
          # down the expectation to only statements that insert elements in that
          # position. Possible values are +:top+, +:bottom+, +:before+ and +:after+.
          #
          # === Using blocks
          #
          # Without a block, response.should have_rjs merely expects that the response
          # contains one or more RJS statements that replace or update content.
          #
          # With a block, response.should have_rjs also selects all elements used in
          # these statements and passes them to the block. Nested expectations are
          # supported.
          #
          # Calling response.should have_rjs with no arguments and using nested expectations
          # expects that the HTML content is returned by one or more RJS statements.
          # Using #with_tag directly makes the same assertion on the content,
          # but without distinguishing whether the content is returned in an HTML
          # or JavaScript.
          #
          # === Examples
          #
          #   # Updating the element foo.
          #   response.should have_rjs(:update, "foo")
          #
          #   # Inserting into the element bar, top position.
          #   response.should have_rjs(:insert, :top, "bar")
          #
          #   # Changing the element foo, with an image.
          #   response.should have_rjs("foo") do
          #     with_tag("img[src=/images/logo.gif"")
          #   end
          #
          #   # RJS inserts or updates a list with four items.
          #   response.should have_rjs do
          #     with_tag("ol>li", 4)
          #   end
          #
          #   # The same, but shorter.
          #   response.should have_rjs("ol>li", 4)
          #
          #   # RJS effects
          #   response.should have_rjs(:effect, :fade, "mydiv")
          #   response.should have_rjs(:effect, :toggle_blind, "mydiv")
          def have_rjs(*args, &block)
            args.unshift(response)
            case args.last
            when Hash
              args.last[:select_type] = "rjs"
            else
              args << {:select_type => "rjs"}
            end
            AssertSelect.new(*args, &block)
          end

          # :call-seq:
          #   with_tag(selector, equality?, message?)
          #
          # RSpec wrapper for a nested <tt>assert_select</tt>
          #
          # This is used within a block to set expectations about specific
          # tags nested within the element selected before the block.
          #
          # === Example
          #  
          #  # Defining a login form
          #  response.should have_tag("form[action=/login]") do
          #    with_tag("input[type=text][name=email]")
          #    with_tag("input[type=password][name=password]")
          #    with_tag("input[type=submit][value=Login]")
          #  end
          def with_tag(*args, &block)
            AssertSelect.selected.should have_tag(*args, &block)
          end

          # :call-seq:
          #   with_encoded(element?) { |elements| ... }
          #
          # RSpec wrapper for <tt>assert_select_encoded</tt>
          #
          # Extracts the content of an element, treats it as encoded HTML and runs
          # nested assertion on it.
          #
          # This is intended to called within another expectation to operate on
          # all currently selected elements.
          #
          # The content of each element is un-encoded, and wrapped in the root
          # element +encoded+. It then calls the block with all un-encoded elements.
          #
          # === Example
          #
          #   response.should be_feed(:rss, 2.0) do
          #     with_tag("channel>item>description") do
          #       with_encoded do
          #         with_tag("p")
          #       end
          #     end
          #   end
          def with_encoded(*args, &block)
            case args.last
            when Hash
              args.last[:select_type] = "encoded"
            else
              args << {:select_type => "encoded"}
            end
            AssertSelect.selected.should have_tag(*args, &block)
          end

          # :call-seq:
          #   without_tag(selector, equality?, message?)
          #
          # RSpec wrapper for a nested <tt>assert_select</tt>, allowing you
          # to specify the absence of a nested tag.
          #
          # === Example
          #  
          #  # A list of users in which the logged in user can edit her own record
          #   response.should have_tag("div#users") do
          #     with_tag("div#user_1") do
          #       with_tag("a")
          #     end
          #     with_tag("div#user_2") do
          #       #user 2 is logged in and gets a link to edit record
          #       without_tag("a[href=/users/2;edit]")
          #     end
          #     with_tag("div#user_3") do
          #       with_tag("a")
          #     end
          #   end
          def without_tag(*args, &block)
            AssertSelect.selected.should_not have_tag(*args, &block)
          end

          # :call-seq:
          #   response.should be_feed(type, version?) { ... }
          #   response.should_not be_feed(type, version?) { ... }
          #
          # RSpec wrapper for a <tt>assert_select_feed</tt>
          #
          # Selects root of the feed element. Calls the block for nested expectations.
          #
          # The feed type may be <tt>:atom</tt> or <tt>:rss</tt>. Currently supported
          # are versions 2.0 (default) and 0.92 for RSS and versions 0.3 and 1.0 (default)
          # for Atom.
          #
          # === Example
          #
          #   response.should be_feed(:rss, 2.0) {
          #     with_tag("title", "My feed")
          #     with_tag("item") { |items|
          #       . . .
          #     }
          #   }
          def be_feed(*args, &block)
            args.unshift(response)
            case args.last
            when Hash
              args.last[:select_type] = "feed"
            else
              args << {:select_type => "feed"}
            end
            AssertSelect.new(*args, &block)
          end

          # :call-seq:
          #   response.should send_email { }
          #   response.should_not send_email { }
          #
          # RSpec wrapper for a <tt>assert_select_email</tt>
          #
          # Extracts the body of an email and runs nested expectations on it.
          #
          # You must enable deliveries for this to work, use:
          #   ActionMailer::Base.perform_deliveries = true
          #
          # === Example
          #
          #   response.should send_mail {
          #     with_tag("h1", "Email alert")
          #   }
          def send_email(*args, &block)
            args.unshift(response)
            case args.last
            when Hash
              args.last[:select_type] = "email"
            else
              args << {:select_type => "email"}
            end
            AssertSelect.new(*args, &block)
          end

      end
    end
  end
end