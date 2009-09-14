module Spec # :nodoc:
  module VERSION # :nodoc:
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 2
      TINY   = 9
      PRE    = 'rc1'
      
      STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')

      SUMMARY = "rspec #{STRING}"
    end
  end
end