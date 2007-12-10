task :rebuild => :clobber
task :clobber do
  rm_rf SITE.output_dir
end