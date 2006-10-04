class Object
  def stub!(method_name)
    ::Spec::Stubs::StubMethod.new(self, method_name)
  end
end