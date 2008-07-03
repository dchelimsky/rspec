module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 1
      TINY   = 4

      STRING = [MAJOR, MINOR, TINY].join('.')

      SUMMARY = "rspec version #{STRING}"
    end
  end
end