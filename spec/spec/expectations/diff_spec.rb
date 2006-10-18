require File.dirname(__FILE__) + '/../../spec_helper.rb'

context "Diff" do
  specify "should output unified diff of two strings" do
    expected="foo\nbar\nzap\nthis\nis\nsoo\nvery\nvery\nequal\ninsert\na\nline\n"
    actual="foo\nzap\nbar\nthis\nis\nsoo\nvery\nvery\nequal\ninsert\na\nanother\nline\n"
    expected_diff="\n\n@@ -1,6 +1,6 @@\n foo\n-bar\n zap\n+bar\n this\n is\n soo\n@@ -9,5 +9,6 @@\n equal\n insert\n a\n+another\n line\n"
    diff=Spec::Expectations::Should::Base.new.diff_as_string(expected, actual)
    diff.should_eql(expected_diff)
  end
end
