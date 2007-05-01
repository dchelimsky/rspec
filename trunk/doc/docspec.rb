# Helper for webgen doco that works on both windows and posix
# cd ../rspec && ruby bin/spec
Dir.chdir(File.dirname(__FILE__) + '/../rspec') do
  puts `ruby bin/spec #{ARGV.join(" ")}`
end