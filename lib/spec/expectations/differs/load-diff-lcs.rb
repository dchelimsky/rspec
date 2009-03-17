begin
  require 'diff/lcs'
rescue LoadError
  if ENV['DONT_MAKE_ME_USE_RUBYGEMS']
    raise <<-MESSAGE

We need to load the diff-lcs gem, but you've set
the DONT_MAKE_ME_USE_RUBYGEMS environment variable 
and failed to supply a means of loading diff-lcs.
MESSAGE
  end
  begin
    require 'rubygems'
    require 'diff/lcs'
  rescue LoadError
    raise "You must gem install diff-lcs to use diffing"
  end
end

require 'diff/lcs/hunk'
