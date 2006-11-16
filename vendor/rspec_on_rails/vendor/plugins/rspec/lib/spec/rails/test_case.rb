##
# Spec::Rails::TestCase is an abstract test case for Spec::Rails test cases.
#--
# Eventually this will hold the fixture setup stuff.

class Spec::Rails::TestCase < Test::Unit::TestCase

  undef_method :default_test

end

