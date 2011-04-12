module Spec # :nodoc:
  module VERSION # :nodoc:
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 3
      TINY   = 2
      PRE    = nil

      STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')

      SUMMARY = "rspec #{STRING}"
    end
  end
end
