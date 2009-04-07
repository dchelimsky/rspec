module Spec
  module Example
    module ArgsAndOptions
      def args_and_options(*args) # :nodoc:
        options = Hash === args.last ? args.pop : {}
        return args, options
      end
    end
  end
end
