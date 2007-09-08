# add ensure_that(..)
module Spec::Expectations::ObjectExpectations
  def ensure_that(obj, expr)
    obj.should expr
  end
end

def exception_from(&block)
  begin
    yield
  rescue StandardError => e
    e
  end
end

# simplify matchers


# custom matchers

def contain(string)
  return Spec::Matchers::SimpleMatcher.new(%[string containing "#{string}"]) do |actual|
    actual.include? string
  end
end

alias :contains :contain

def is(expected)
  return Spec::Matchers::SimpleMatcher.new("equal to #{expected}") do |actual| actual == expected end
end

alias :are :is

def is_a(type)
  return Spec::Matchers::SimpleMatcher.new("object of type #{type}") do |actual|
    actual.is_a? type
  end
end

alias :is_an :is_a

def matches(pattern)
  return Spec::Matchers::SimpleMatcher.new("string matching #{pattern}") do |actual|
    actual =~ pattern
  end
end
