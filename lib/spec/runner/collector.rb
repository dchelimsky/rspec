require 'spec'

module Spec
	class Collector

		def self.collection
			collection = []
			ObjectSpace.each_object(Class) do |cls|
				collection << cls.collection if cls < Spec::Context
			end
			collection.flatten
		end

	end
end

