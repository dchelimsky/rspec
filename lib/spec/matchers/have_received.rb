module Spec
  module Matchers
    def have_received(sym_, *args_, &block_)
      Matcher.new :have_received, sym_, args_, block_ do |sym, args, block|
        match do |actual|
          actual.received_message?(sym, *args, &block)
        end

        failure_message_for_should do |actual|
          "expected #{actual.inspect} to have received #{sym.inspect} with #{args.inspect}"
        end

        failure_message_for_should_not do |actual|
          "expected #{actual.inspect} to not have received #{sym.inspect} with #{args.inspect}, but did"
        end

        description do
          "to have received #{sym.inspect} with #{args.inspect}"
        end
      end
    end
  end
end

