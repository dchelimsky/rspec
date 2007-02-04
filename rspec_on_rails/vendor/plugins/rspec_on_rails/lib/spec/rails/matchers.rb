dir = File.dirname(__FILE__)
require "spec/rails/matchers/assert_select"
require "spec/rails/matchers/have_text"
require "spec/rails/matchers/redirect_to"
require "spec/rails/matchers/render_template"

module Spec
  module Rails
    # == Expectation Matchers
    #
    # ExpectationMatchers are methods (with classes underlying) that allow you
    # set expectations on objects. For example, if you expect the value of an
    # object to be 37 after some calculation, you could say:
    #
    #   result.should equal(37)
    #
    # In this example, "should equal(37)" is an expectation, with "equal(37)" being
    # the ExpecationMatcher.
    #
    # RSpec on Rails sports several expectation matchers specifically intended to work with Rails
    # components like responses. For example:
    #
    #   response.should be_redirect #be_redirect() is the matcher.
    #
    # == Isolation and Integration modes
    #
    # RSpec on Rails lets you run your controller specs in isolation or integration modes.
    # In isolation mode, no templates are rendered. In fact, they are not even used at all.
    # This allows you to spec your controllers even when there are no templates present.
    #
    # Isolation mode is somewhat risky unless you are also doing some sort of integration
    # testing.
    #
    # In integration mode, controller specs work just like rails functional tests, invoking
    # the views as expected.
    module Matchers
      # :call-seq:
      #   response.should have_tag(selector, equality?, message?)
      #   response.should have_tag(element, selector, equality?, message?)
      #   response.should_not have_tag(selector, equality?, message?)
      #   response.should_not have_tag(element, selector, equality?, message?)
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
      #   response.should have_tag("ol>li") { |elements|
      #     elements.each do |element|
      #       element.should have_tag("li")
      #     end
      #   end
      # Or for short:
      #   response.should have_tag("ol>li") {
      #     with_tag("li")
      #   }
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
      #   response.should be_rjs(id?) { |elements| ... }
      #   response.should be_rjs(statement, id?) { |elements| ... }
      #   response.should be_rjs(:insert, position, id?) { |elements| ... }
      #   response.should_not be_rjs(id?) { |elements| ... }
      #   response.should_not be_rjs(statement, id?) { |elements| ... }
      #   response.should_not be_rjs(:insert, position, id?) { |elements| ... }
      #
      # This is a wrapper for assert_select_rjs and works the same way
      # but with rspec-friendly syntax
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
      # Without a block, response.should be_rjs merely expects that the response
      # contains one or more RJS statements that replace or update content.
      #
      # With a block, response.should be_rjs also selects all elements used in
      # these statements and passes them to the block. Nested expectations are
      # supported.
      #
      # Calling response.should be_rjs with no arguments and using nested expectations
      # expects that the HTML content is returned by one or more RJS statements.
      # Using #with_tag directly makes the same assertion on the content,
      # but without distinguishing whether the content is returned in an HTML
      # or JavaScript.
      #
      # === Examples
      #
      #   # Updating the element foo.
      #   response.should be_rjs(:update, "foo")
      #
      #   # Inserting into the element bar, top position.
      #   response.should be_rjs(:insert, :top, "bar")
      #
      #   # Changing the element foo, with an image.
      #   response.should be_rjs("foo") {
      #     with_tag("img[src=/images/logo.gif"")
      #   }
      #
      #   # RJS inserts or updates a list with four items.
      #   response.should be_rjs {
      #     with_tag("ol>li", 4)
      #   }
      #
      #   # The same, but shorter.
      #   response.should be_rjs("ol>li", 4)
      def be_rjs(*args, &block)
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
      # This is used within a block to set expectations about specific
      # tags nested within the element selected before the block.
      #
      # === Example
      #  
      #  # Defining a login form
      #  response.should have_tag("form[action=/login]") {
      #    with_tag("input[type=text][name=email]")
      #    with_tag("input[type=password][name=password]")
      #    with_tag("input[type=submit][value=Login]")
      #  }
      def with_tag(*args, &block)
        AssertSelect.selected.should have_tag(*args, &block)
      end

      # :call-seq:
      #   with_encoded(element?) { |elements| ... }
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
      #   response.should be_feed(:rss, 2.0) {
      #     with_tag("channel>item>description") {
      #       with_encoded {
      #         with_tag("p")
      #       }
      #     }
      #   }
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
      # This is used within a block to expect a specific tag
      # to NOT be nested within the selected element.
      #
      # === Example
      #  
      #  # A list of users in which the logged in user can edit her own record
      # response.should have_tag("div#users") {
      #   with_tag("div#user_1") {
      #     with_tag("a")
      #   }
      #   with_tag("div#user_2") {
      #     #user 2 is logged in and gets a link to edit record
      #     without_tag("a[href=/users/2;edit]")
      #   }
      #   with_tag("div#user_3") {
      #     with_tag("a")
      #   }
      # }
      def without_tag(*args, &block)
        AssertSelect.selected.should_not have_tag(*args, &block)
      end
      
      # :call-seq:
      #   response.should be_feed(type, version?) { ... }
      #   response.should_not be_feed(type, version?) { ... }
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
      # Extracts the body of an email and runs nested expectations on it.
      #
      # You must enable deliveries for this assertion to work, use:
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
      
      # :call-seq:
      #   response.should redirect_to(url)
      #   response.should redirect_to(:action => action_name)
      #   response.should redirect_to(:controller => controller_name, :action => action_name)
      #   response.should_not redirect_to(url)
      #   response.should_not redirect_to(:action => action_name)
      #   response.should_not redirect_to(:controller => controller_name, :action => action_name)
      #
      # Passes if the response is a redirect to the url, action or controller/action.
      # Useful in controller specs (integration or isolation mode).
      #
      # == Examples
      #
      #   response.should redirect_to("path/to/action")
      #   response.should redirect_to("http://test.host/path/to/action")
      #   response.should redirect_to(:action => 'list')
      def redirect_to(opts)
        RedirectTo.new(request, opts)
      end
      
      # :call-seq:
      #   response.should render_template(path)
      #   response.should_not render_template(path)
      #
      # Passes if the specified template is rendered by the response.
      # Useful in controller specs (integration or isolation mode).
      #
      # <code>path</code> can include the controller path or not. It
      # can also include an optional extension (no extension assumes .rhtml).
      #
      # Note that partials must be spelled with the preceding underscore.
      #
      # == Examples
      #
      #   response.should render_template('list')
      #   response.should render_template('same_controller/list')
      #   response.should render_template('other_controller/list')
      #
      #   #rjs
      #   response.should render_template('list.rjs')
      #   response.should render_template('same_controller/list.rjs')
      #   response.should render_template('other_controller/list.rjs')
      #
      #   #partials
      #   response.should render_template('_a_partial')
      #   response.should render_template('same_controller/_a_partial')
      #   response.should render_template('other_controller/_a_partial')
      def render_template(path)
        RenderTemplate.new(path.to_s)
      end
      
      # :call-seq:
      #   response.should have_text(expected)
      #   response.should_not have_text(expected)
      #
      # Accepts a String or a Regexp, matching a String using ==
      # and a Regexp using =~.
      #
      # Use this as a lightweight version of response.should have_tag().
      #
      # == Examples
      #
      #   response.should have_text("This is the expected text")
      def have_text(text)
        HaveText.new(text)
      end
    end
  end
end