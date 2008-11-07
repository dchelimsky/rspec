module Spec
  module Matchers
    module GeneratedDescriptions
      attr_accessor :last_matcher, :last_should

      def clear_generated_description
        self.last_matcher = nil
        self.last_should = nil
      end
    
      def generated_description
        last_should.nil? ? nil :
          "#{last_should} #{last_matcher.respond_to?(:description) ? last_matcher.description : 'NO NAME'}"
      end
    end
    
    extend GeneratedDescriptions
  end
end
  