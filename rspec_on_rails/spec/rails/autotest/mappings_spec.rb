require File.dirname(__FILE__) + '/../../spec_helper'
require File.join(File.dirname(__FILE__), *%w[.. .. .. lib autotest rails_rspec])
require File.join(File.dirname(__FILE__), *%w[.. .. .. .. rspec spec autotest_helper])

describe Autotest::RailsRspec, "file mapping" do
  before(:each) do
    @autotest = Autotest::RailsRspec.new
    @autotest.hook :initialize
  end
  
  it "should map model example to model" do
    @autotest.should map_specs(['spec/models/thing_spec.rb']).to('app/models/thing.rb')
  end
  
  xit "should map controller example to controller" do
    ensure_mapping(['spec/controllers/things_controller_spec.rb'], 'app/controllers/things_controller.rb')
  end
  
  xit "should map view.rhtml" do
    ensure_mapping(['spec/views/things/index.rhtml_spec.rb'], 'app/views/things/index.rhtml')
  end
  
  xit "should map view.rhtml with underscores in example filename" do
    ensure_mapping(['spec/views/things/index_rhtml_spec.rb'], 'app/views/things/index.rhtml')
  end
  
  xit "should map view.html.erb" do
    ensure_mapping(['spec/views/things/index.html.erb_spec.rb'], 'app/views/things/index.html.erb')
  end
  
end
