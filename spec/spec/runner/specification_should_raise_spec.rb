require File.dirname(__FILE__) + '/../../spec_helper.rb'

context "a Specification declared with {:should_raise => " do
  setup do
    @reporter = mock("reporter")
    @reporter.stub!(:spec_started)
  end

  specify "true} should pass when there is an ExpectationNotMetError" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => true) do
      raise Spec::Expectations::ExpectationNotMetError
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be nil
    end
    spec.run(@reporter)
  end

  specify "true} should fail if nothing is raised" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => true) {}
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be_an_instance_of Spec::Expectations::ExpectationNotMetError
      error.message.should_eql "Spec::Expectations::ExpectationNotMetError"
    end
    spec.run(@reporter)
  end

  specify "NameError} should pass when there is a NameError" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => NameError) do
      raise NameError
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be nil
    end
    spec.run(@reporter)
  end

  specify "NameError} should fail when there is no error" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => NameError) do
      #do nothing
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be_an_instance_of Spec::Expectations::ExpectationNotMetError
    end
    spec.run(@reporter)
  end

  specify "NameError} should fail when there is the wrong error" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => NameError) do
      raise RuntimeError
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be_an_instance_of Spec::Expectations::ExpectationNotMetError
    end
    spec.run(@reporter)
  end

  specify "[NameError]} should pass when there is a NameError" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => [NameError]) do
      raise NameError
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be nil
    end
    spec.run(@reporter)
  end

  specify "[NameError]} should fail when there is no error" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => [NameError]) do
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be_an_instance_of Spec::Expectations::ExpectationNotMetError
    end
    spec.run(@reporter)
  end

  specify "[NameError]} should fail when there is the wrong error" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => [NameError]) do
      raise RuntimeError
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be_an_instance_of Spec::Expectations::ExpectationNotMetError
    end
    spec.run(@reporter)
  end

  specify "[NameError, 'got an error'} should pass when there is a NameError with the right message" do
    spec = Spec::Runner::Specification.new("spec", :should_raise => [NameError, 'expected']) do
      raise NameError, 'expected'
    end
    @reporter.should_receive(:spec_finished) do |spec_name, error|
      error.should_be nil
    end
    spec.run(@reporter)
  end
end
