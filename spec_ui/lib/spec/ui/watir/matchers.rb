# Matchers for Watir::IE/Watir::Safari instances
module Spec::Matchers::Watir
  class HaveText # :nodoc
    def initialize(text_or_regexp)
      @text_or_regexp = text_or_regexp
    end
    
    def matches?(browser)
      @browser = browser
      if @text_or_regexp.is_a?(Regexp)
        !!browser.text =~ @text_or_regexp
      else
        !!browser.text.index(@text_or_regexp.to_s)
      end
    end
    
    def failure_message
      "Expected browser to have text matching #{@text_or_regexp}, but it was not found in:\n#{@browser.text}"
    end

    def negative_failure_message
      "Expected browser to not have text matching #{@text_or_regexp}, but it was found in:\n#{@browser.text}"
    end
  end

  # RSpec matcher that passes if @browser#text matches +text+ (String or Regexp) 
  def have_text(text)
    HaveText.new(text)
  end

  class HaveHtml # :nodoc
    def initialize(text_or_regexp)
      @text_or_regexp = text_or_regexp
    end
    
    def matches?(browser)
      @browser = browser
      if @text_or_regexp.is_a?(Regexp)
        !!browser.html =~ @text_or_regexp
      else
        !!browser.html.index(@text_or_regexp.to_s)
      end
    end
    
    def failure_message
      "Expected browser to have HTML matching #{@text_or_regexp}, but it was not found in:\n#{@browser.html}"
    end

    def negative_failure_message
      "Expected browser to not have HTML matching #{@text_or_regexp}, but it was found in:\n#{@browser.html}"
    end
  end

  # RSpec matcher that passes if @browser#html matches +text+ (String or Regexp) 
  def have_html(text)
    HaveHtml.new(text)
  end

  class HaveLink # :nodoc
    def initialize(how, what)
      @how, @what = how, what
    end
    
    def matches?(browser)
      @browser = browser
      begin
        link = @browser.link(@how, @what)
        if link.respond_to?(:assert_exists)
          # IE
          link.assert_exists
          true
        else
          # Safari
          link.exists?
        end
      rescue ::Watir::Exception::UnknownObjectException => e
        false
      end
    end
    
    def failure_message
      "Expected browser to have link(#{@how}, #{@what}), but it was not found"
    end

    def negative_failure_message
      "Expected browser not to have link(#{@how}, #{@what}), but it was found"
    end
  end

  # RSpec matcher that passes if @browser#link(+how+,+what+) returns an existing link.
  def have_link(how, what)
    HaveLink.new(how, what)
  end

  class HaveTextField # :nodoc
    def initialize(how, what)
      @how, @what = how, what
    end
    
    def matches?(browser)
      @browser = browser
      begin
        text_field = @browser.text_field(@how, @what)
        text_field.assert_exists
        true
      rescue ::Watir::Exception::UnknownObjectException => e
        false
      end
    end
    
    def failure_message
      "Expected browser to have text_field(#{@how}, #{@what}), but it was not found"
    end

    def negative_failure_message
      "Expected browser not to have text_field(#{@how}, #{@what}), but it was found"
    end
  end

  # RSpec matcher that passes if @browser#text_field(+how+,+what+) returns an existing text field.
  def have_text_field(how, what)
    HaveTextField.new(how, what)
  end

end
