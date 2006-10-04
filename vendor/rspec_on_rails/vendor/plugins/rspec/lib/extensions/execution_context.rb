module Spec
  module Runner

    class ExecutionContext
      include ActionController::TestProcess

      def tag(*opts)
        opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
        tag = find_tag(opts)
      end
    end
  end
end