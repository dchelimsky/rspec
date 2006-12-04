# This overrides Rails' Proc#bind, which sometimes causes spec runs
# to fail with errors like "undefined method `xyz' for 25913344:Fixnum"
# and "expected bind argument to be XYZ"

# This has been submitted as a patch [6703] to Rails (with test/unit tests, of course)
# and will be removed from here if accepted

class Proc #:nodoc:
  
  @@__bind_index = 0

  def bind(object)
    block, index = self, (@@__bind_index = @@__bind_index + 1)
    (class << object; self end).class_eval do
      method_name = "__bind_#{index}"
      define_method(method_name, &block)
      method = instance_method(method_name)
      remove_method(method_name)
      method
    end.bind(object)
  end
end
