begin
  require 'diff/lcs'
rescue LoadError
  begin
    require 'rubygems' unless ENV['DONT_MAKE_ME_USE_RUBYGEMS']
    require 'diff/lcs'
  rescue LoadError
    raise "You must gem install diff-lcs to use diffing"
  end
end

require 'diff/lcs/hunk'
