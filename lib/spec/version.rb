module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 1
      TINY   = 8

      STRING = [MAJOR, MINOR, TINY].join('.')

      SUMMARY = "rspec #{STRING}"
    end
  end
end