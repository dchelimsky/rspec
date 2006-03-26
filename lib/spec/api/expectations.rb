module Spec
  module ObjectExpectations
		def should
			ShouldHelper.new self
		end
	end
end

class Object
  include Spec::ObjectExpectations
end

