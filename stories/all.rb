require File.join(File.dirname(__FILE__), *%w[helper])

%w[interop stories].each do |dir|
  require File.join(File.dirname(__FILE__), "#{dir}/stories")
end
