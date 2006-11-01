module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR  = 0
      MINOR  = 7
      TINY   = 0
      # 
      REV    = "$LastChangedRevision$"

      STRING = [MAJOR, MINOR, TINY].join('.')
      TAG    = "REL_" + [MAJOR, MINOR, TINY].join('_')

      NAME   = "RSpec"
      URL    = "http://rspec.rubyforge.org/"  
    
      DESCRIPTION = "#{NAME}-#{STRING} - BDD for Ruby\n#{URL}"
    end
  end
end