Spec::Matchers.constants.each do |c|
  if Class === (klass = Spec::Matchers.const_get(c))
    if klass.public_instance_methods.include?('failure_message_for_should')
      klass.__send__ :alias_method, :failure_message, :failure_message_for_should
    end
    if klass.public_instance_methods.include?('failure_message_for_should_not')
      klass.__send__ :alias_method, :negative_failure_message, :failure_message_for_should_not
    end
  end
end
