require File.dirname(__FILE__) + '/../../spec_helper'
require File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "autotest", "rails_rspec")

describe Autotest::RailsRspec, "file mapping" do
  before(:each) do
    @autotest = Autotest::RailsRspec.new
    @autotest.output = StringIO.new
    @autotest.files.clear
    @autotest.last_mtime = Time.at(0)
  end
  
  def ensure_mapping(examples, impl)
    @autotest.files[@impl] = Time.at(0)
    examples.each do |example|
      @autotest.files[example] = Time.at(0)
    end
    @autotest.tests_for_file(impl).should == examples
  end
  
  it "should map model example to model" do
    ensure_mapping(['spec/models/thing_spec.rb'], 'app/models/thing.rb')
  end
  
  it "should map controller example to controller" do
    ensure_mapping(['spec/controllers/things_controller_spec.rb'], 'app/controllers/things_controller.rb')
  end
  
  it "should map view.rhtml" do
    ensure_mapping(['spec/views/things/index.rhtml_spec.rb'], 'app/views/things/index.rhtml')
  end
  
  it "should map view.rhtml with underscores in example filename" do
    ensure_mapping(['spec/views/things/index_rhtml_spec.rb'], 'app/views/things/index.rhtml')
  end
  
  it "should map view.html.erb" do
    ensure_mapping(['spec/views/things/index.html.erb_spec.rb'], 'app/views/things/index.html.erb')
  end
end
