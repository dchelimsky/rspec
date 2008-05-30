describe Spec::Adapters::RubyEngine do
  it "should default to MRI" do
    Spec::Adapters::RubyEngine.adapter.should be_an_instance_of(Spec::Adapters::RubyEngine::MRI)
  end
  
  it "should provide Rubinius for rbx" do
    Spec::Adapters::RubyEngine.stub!(:engine).and_return('rbx')
    Spec::Adapters::RubyEngine.adapter.should be_an_instance_of(Spec::Adapters::RubyEngine::Rubinius)
  end
end