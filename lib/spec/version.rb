module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 2
      TINY   = 0
      MINESCULE = nil
      

      STRING = [MAJOR, MINOR, TINY, MINESCULE].compact.join('.')

      SUMMARY = "rspec #{STRING}"
    end
  end
end