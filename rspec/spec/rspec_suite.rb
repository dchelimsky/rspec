dir = File.dirname(__FILE__)
Dir["#{dir}/**/spec/*_spec.rb"].each do |file|
  require file
end
