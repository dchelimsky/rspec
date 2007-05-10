# Matchers for Watir::IE/Watir::Safari instances
module Spec::Matchers::Watir
  class ContentMatcher # :nodoc
    def initialize(kind, text_or_regexp)
      @kind, @text_or_regexp = kind, text_or_regexp
    end
    
    def matches?(container)
      @container = container
      @content = container.__send__(@kind)
      if @text_or_regexp.is_a?(Regexp)
        !!@content =~ @text_or_regexp
      else
        !!@content.index(@text_or_regexp.to_s)
      end
    end
    
    def failure_message
      "Expected #{@container.class} to have #{@kind} matching #{@text_or_regexp}, but it was not found in:\n#{@content}"
    end

    def negative_failure_message
      "Expected #{@container.class} to not have #{@kind} matching #{@text_or_regexp}, but it was found in:\n#{@content}"
    end
  end

  # RSpec matcher that passes if @container#text matches +text_or_regexp+ (String or Regexp) 
  def have_text(text_or_regexp)
    ContentMatcher.new(:text, text_or_regexp)
  end

  # RSpec matcher that passes if @container#html matches +text_or_regexp+ (String or Regexp) 
  def have_html(text_or_regexp)
    ContentMatcher.new(:html, text_or_regexp)
  end

  class ElementMatcher # :nodoc
    def initialize(kind, *args)
      @kind, @args = kind, args
    end
    
    def matches?(container)
      @container = container
      begin
        element = @container.__send__(@kind, *@args)
        if element.respond_to?(:assert_exists)
          # IE
          element.assert_exists
          true
        else
          # Safari
          element.exists?
        end
      rescue ::Watir::Exception::UnknownObjectException => e
        false
      end
    end
    
    def failure_message
      "Expected #{@container.class} to have #{@kind}(#{arg_string}), but it was not found"
    end

    def negative_failure_message
      "Expected #{@container.class} to not have #{@kind}(#{arg_string}), but it was found"
    end
    
    def arg_string
      @args.map{|a| a.inspect}.join(", ")
    end
  end

  # All the xxx(what, how) methods in Watir
  [
    :button, 
    :cell, 
    :checkbox, 
    :div, 
    :file_field, 
    :form, 
    :hidden, 
    :image, 
    :label,
    :link,
    :p, 
    :radio, 
    :row, 
    :select_list,
    :span,
    :table,
    :text_field
  ].each do |kind|
    # RSpec matcher that passes if container##{kind}(*args) returns an existing #{kind} element.
    define_method("have_#{kind}".to_sym) do |*args|
      ElementMatcher.new(kind, *args)
    end
  end
end
