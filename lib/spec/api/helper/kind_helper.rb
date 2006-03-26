module Spec

	class KindHelper < ShouldBase
	
		def initialize(target)
			@target = target
		end
		
		def of(expected_class)
			fail_with_message(default_message("should be a kind of", expected_class)) unless @target.kind_of? expected_class
		end
		
	end

end