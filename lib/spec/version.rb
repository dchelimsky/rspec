module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR = 0
      MINOR = 5
      TINY  = 6

      STRING = [MAJOR, MINOR, TINY].join('.')

      NAME = "RSpec"
      URL = "http://rspec.rubyforge.org/"  
    
      DESCRIPTION = "#{NAME}-#{STRING} - BDD for Ruby\n#{URL}"
    end
  end
end