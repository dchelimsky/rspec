def get_classes
  classes = []
  ObjectSpace.each_object(Class) {|cls| classes << cls.to_s}
  classes
end

