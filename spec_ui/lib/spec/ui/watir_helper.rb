require File.dirname(__FILE__) + '/webapp_helper'
require 'rubygems'

if RUBY_PLATFORM =~ /darwin/
  require 'safariwatir'
  Watir::Browser = Watir::Safari
else
  require 'watir'
  Watir::Browser = Watir::IE
end

class Watir::Browser
  def kill!
    close
  end
  
  alias contain_text? contains_text

  alias old_goto goto
  # Redefinition of Watir's original goto, which gives a better
  # exception message (the URL is in the message)
  def goto(url)
    begin
      old_goto(url)
    rescue => e
      e.message << "\nURL: #{url}"
      raise e
    end
  end
end

module Spec
  # Matchers for Watir
  module Watir
    class HaveText
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

    class HaveHtml
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

    class HaveLink
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

    class HaveTextField
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
  end
end

def have_text(text)
  Spec::Watir::HaveText.new(text)
end

def have_html(text)
  Spec::Watir::HaveHtml.new(text)
end

def have_link(how, what)
  Spec::Watir::HaveLink.new(how, what)
end

def have_text_field(how, what)
  Spec::Watir::HaveTextField.new(how, what)
end
