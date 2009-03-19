module Spec
  module Runner
    module Formatter
      module NOOPMethodMissing
        def respond_to?(message, include_private = false)
          if include_private
            true
          else
            !private_methods.include?(message.to_s)
          end
        end

      private
        
        def method_missing(sym, *args)
          # a no-op
        end
      end
    end
  end
end
