module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR  = 0
      MINOR  = 9
      TINY   = 0
      RELEASE_CANDIDATE = nil #{}"RC1"
      
      # RANDOM_TOKEN: 0.653481804878764
      REV = "$LastChangedRevision$".match(/LastChangedRevision: (\d+)/)[1]

      STRING = [MAJOR, MINOR, TINY, RELEASE_CANDIDATE].compact.join('.')
      TAG = "REL_" + STRING.gsub(/\./, '_')
      FULL_VERSION = "#{STRING} (r#{REV})"

      NAME   = "RSpec"
      URL    = "http://rspec.rubyforge.org/"  
    
      DESCRIPTION = "#{NAME}-#{FULL_VERSION} - BDD for Ruby\n#{URL}"
    end
  end
end