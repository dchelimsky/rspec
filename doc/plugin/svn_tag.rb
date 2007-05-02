require File.dirname(__FILE__) + '/../../rspec/lib/spec/version'

class VersionTag < Tags::DefaultTag
  infos(:name => "CustomTag/SvnTagTag",
        :summary => "Puts the svn tag URL on the page")
        
  register_tag 'svn_tag'

  def process_tag(tag, node)
    return Spec::VERSION::TAG
  end
end
