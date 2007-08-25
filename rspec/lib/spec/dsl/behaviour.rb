module Spec
  module DSL
    class Behaviour < Module
      extend Forwardable
      extend BehaviourCallbacks
      include BehaviourMethods
      public :include
    end
  end
end
