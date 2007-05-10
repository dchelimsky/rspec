class Spec::DSL::Behaviour
  def before_eval #:nodoc:
    include Spec::Watir # This gives us Watir matchers
  end
end
