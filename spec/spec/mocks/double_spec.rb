require 'spec/spec_helper'

describe "double" do
  it "is an alias for stub and mock" do
    double().should be_a(Spec::Mocks::Mock)
  end
end