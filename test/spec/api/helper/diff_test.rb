require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  class DiffTest < Test::Unit::TestCase
    def test_should_output_unified_diff_of_two_strings
      expected = <<-EOF
foo
bar
zap
this
is
soo
very
very
equal
insert
a
line
EOF

      actual = <<-EOF
foo
zap
bar
this
is
soo
very
very
equal
insert
a
another
line
EOF

      expected_diff = <<-EOF


@@ -1,6 +1,6 @@
 foo
-bar
 zap
+bar
 this
 is
 soo
@@ -9,5 +9,6 @@
 equal
 insert
 a
+another
 line
EOF

      diff = ShouldBase.new.diff_as_string(expected, actual)
      assert_equal expected_diff, diff
    end
  end
end