context "Big Strings" do
  specify "should have diff printed to stdout when different" do
    uk = <<-EOF
Rspec is a
behaviour driven development
framework for Ruby
EOF
    usa = <<-EOF
Rspec is a
behavior driven development
framework for Ruby
EOF
    usa.should_equal uk
  end
end