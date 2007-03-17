module Spec
  module VERSION
    def self.build_tag
      tag = "REL_" + [MAJOR, MINOR, TINY].join('_')
      if defined?(RELEASE_CANDIDATE)
        tag << "_" << RELEASE_CANDIDATE
      end
      tag
    end

    unless defined? MAJOR
      MAJOR  = 0
      MINOR  = 9
      TINY   = 0
      # RELEASE_CANDIDATE = "RC1"
      
      # RANDOM_TOKEN: 0.596888887285001
      REV = "$LastChangedRevision$".match(/LastChangedRevision: (\d+)/)[1]

      STRING = [MAJOR, MINOR, TINY].join('.')
      FULL_VERSION = "#{STRING} (r#{REV})"
      TAG = build_tag

      NAME   = "RSpec"
      URL    = "http://rspec.rubyforge.org/"  
    
      DESCRIPTION = "#{NAME}-#{FULL_VERSION} - BDD for Ruby\n#{URL}"
    end
  end
end