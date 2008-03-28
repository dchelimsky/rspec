require File.join(File.dirname(__FILE__), *%w[.. helper])

with_steps_for :running_rspec do
  run File.dirname(__FILE__) + "/nested_groups"
  # Dir["#{File.dirname(__FILE__)}/*"].each do |file|
  #   run file if File.file?(file) && !(file =~ /\.rb$/)
  # end
end