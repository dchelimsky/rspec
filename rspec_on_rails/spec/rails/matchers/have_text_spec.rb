require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "should have_text where response is a string" do
  it 'should should match submitted text using a regex' do
    response = 'foo'
    response.should have_text(/fo*/)
  end
  
  it 'should match submitted text using a string' do
    response = 'foo'
    response.should have_text('foo')
  end
end