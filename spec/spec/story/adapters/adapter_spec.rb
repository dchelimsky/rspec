describe Spec::RubyEngine do
  it "should default to MRI" do
    Spec::RubyEngine.adapter.should be_an_instance_of(Spec::RubyEngine::MRI)
  end
  
  it "should provide Rubinius for rbx" do
    Spec::RubyEngine.stub!(:engine).and_return('rbx')
    Spec::RubyEngine.adapter.should be_an_instance_of(Spec::RubyEngine::Rubinius)
  end
end