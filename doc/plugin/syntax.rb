require File.dirname(__FILE__) + "/rspec_content"

class RSpecContentConverter < ContentConverters::DefaultContentConverter
  include ::RSpec::SyntaxConverter
  
  infos(:name => "ContentConverter/Rspec", 
        :author => "Rspec / Scott Taylor", 
        :summary => "Redcloth + Ruby HTML tag syntax converter") 
        
  register_handler 'rspec'
  
  def call(content)
    RSpecContent.new(content).to_html
  end
  
end
