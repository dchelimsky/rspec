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
end

module Spec
  # Matchers for Watir
  module Watir
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
        "Expected browser to have HTML matching #{@text_or_regexp}, but it was not found in:\n#{@browser.text}"
      end
    end
  end
end

def have_html(text)
  Spec::Watir::HaveHtml.new(text)
end
