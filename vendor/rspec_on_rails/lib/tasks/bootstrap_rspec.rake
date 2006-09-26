task :pre_commit => [:clobber_sqlite, :migrate, :generate_rspec, :specs, :spec]

task :clobber_sqlite do
  rm_rf 'db/*.db'
end

task :generate_rspec do
  `ruby script/generate rspec --force`
  raise "Failed to generate rspec environment" if $? != 0
end

task :specs do
  command = "spec specs spec"
  `#{command}`
  raise "rspec_on_rails specs failed (stand in ~/vendor/rspec_on_rails and run '#{command}' to see details)" if $? != 0
end
  
