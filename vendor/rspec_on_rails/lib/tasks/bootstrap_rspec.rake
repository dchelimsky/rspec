task :pre_commit => [:clobber_sqlite, :migrate, :generate_rspec, :spec]

task :clobber_sqlite do
  rm_rf 'db/*.db'
end

task :generate_rspec do
  `ruby script/generate rspec --force`
  raise "Failed to generate rspec environment" if $? != 0
end

