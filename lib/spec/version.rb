module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR  = 0
      MINOR  = 6
      TINY   = 3

      STRING = [MAJOR, MINOR, TINY].join('.')
      TAG    = "REL_" + [MAJOR, MINOR, TINY].join('_')

      NAME   = "RSpec"
      URL    = "http://rspec.rubyforge.org/"  
    
      DESCRIPTION = "#{NAME}-#{STRING} - BDD for Ruby\n#{URL}"
    end
  end
end