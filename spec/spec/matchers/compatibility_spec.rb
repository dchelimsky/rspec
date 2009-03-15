require File.dirname(__FILE__) + '/../../spec_helper.rb'

Spec::Matchers.create :have_public_instance_method do |method|
  match do |klass|
    klass.public_instance_methods.include?(method)
  end
end

module Spec
  module Matchers
    describe Spec::Matchers do
      (Spec::Matchers.constants.sort).each do |c|
        if (Class === (klass = Spec::Matchers.const_get(c)))
          describe klass do
            if klass.public_instance_methods.include?('failure_message_for_should')
              describe "called with should" do
                subject { klass }
                it { should have_public_instance_method('failure_message_for_should')}
                it { should have_public_instance_method('failure_message')}
              end
            end
            if klass.public_instance_methods.include?('failure_message_for_should_not')
              describe "called with should not" do
                subject { klass }
                it { should have_public_instance_method('failure_message_for_should_not')}
                it { should have_public_instance_method('negative_failure_message')}
              end
            end
          end
        end
      end
    end
  end
end
