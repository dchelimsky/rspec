module Spec

	class KindNegator < ShouldBase
	
		def initialize(target)
			@target = target
		end
		
		def of(expected_class)
			fail_with_message(default_message("should not be a kind of", expected_class)) if @target.kind_of? expected_class
		end
		
	end

end