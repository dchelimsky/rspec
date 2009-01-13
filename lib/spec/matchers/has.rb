module Spec
  module Matchers
    def has(sym, *args) # :nodoc:
      simple_matcher do |actual, matcher|
        def matcher.predicate(sym)
          "#{sym.to_s.sub("have_","has_")}?".to_sym
        end
        matcher.failure_message          = "expected ##{matcher.predicate(sym)}(#{args[0].inspect}) to return true, got false"
        matcher.negative_failure_message = "expected ##{matcher.predicate(sym)}(#{args[0].inspect}) to return false, got true"
        matcher.description              = "have key #{args[0].inspect}"
        actual.__send__(matcher.predicate(sym), *args)
      end
    end
  end
end
