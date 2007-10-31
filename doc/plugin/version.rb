require File.dirname(__FILE__) + '/../../rspec/lib/spec/version'

class VersionTag < Tags::DefaultTag
  infos(:name => "CustomTag/VersionTag",
        :summary => "Puts the version on the page")
        
  register_tag 'version'

  def process_tag(tag, node)
    return Spec::VERSION::STRING
  end
end
