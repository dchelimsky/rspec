begin
  Spec::Ruby.require_with_rubygems_fallback 'diff/lcs'
rescue LoadError
  raise "You must gem install diff-lcs to use diffing"
end

require 'diff/lcs/hunk'
