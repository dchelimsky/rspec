require 'webgen/plugins/tags/tags'
require File.dirname(__FILE__) + '/../../lib/spec/version'

module Tags

  class VersionTag < DefaultTag

    summary "Puts the version on the page" 
    depends_on 'Tags'

    tag 'version'

    def process_tag(tag, node, refNode)
      return Spec::VERSION::STRING
    end

  end

end