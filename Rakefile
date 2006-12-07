task :default => :pre_commit

desc "Runs pre_commit_core and pre_commit_rails"
task :pre_commit => [
  :touch_revision_storing_files,
  :pre_commit_core,
  :pre_commit_rails,
  :ok_to_commit
]

desc "Runs pre_commit against rspec (core)"
task :pre_commit_core do
  Dir.chdir 'rspec' do    
    IO.popen("rake pre_commit --verbose") do |io|
      io.each do |line|
        puts line
      end
    end
  end
  raise "RSpec Core pre_commit failed" if $? != 0
end

desc "Runs pre_commit against rspec_on_rails (against rails 1.1.6 and 1.2.0 RC 1)"
task :pre_commit_rails do
  Dir.chdir 'rspec_on_rails' do    
    IO.popen("rake rspec:pre_commit --verbose") do |io|
      io.each do |line|
        puts line
      end
    end
    if $? != 0
      message = <<EOF
############################################################
RSpec on Rails Plugin pre_commit failed. For more info:

  cd rspec_on_rails
  rake rspec:pre_commit

############################################################
EOF
      raise message
    end
  end
end

task :ok_to_commit do |t|
  puts "OK TO COMMIT"
end

desc "Touches files storing revisions so that svn will update $LastChangedRevision"
task :touch_revision_storing_files do
  # See http://svnbook.red-bean.com/en/1.0/ch07s02.html - the section on svn:keywords
  files = [
    'rspec/lib/spec/version.rb',
    'rspec_on_rails/vendor/plugins/rspec_on_rails/lib/spec/rails/version.rb'
  ]
  new_token = rand
  files.each do |path|
    abs_path = File.join(File.dirname(__FILE__), path)
    content = File.open(abs_path).read
    touched_content = content.gsub(/# RANDOM_TOKEN: (.*)\n/n, "# RANDOM_TOKEN: #{new_token}\n")
    File.open(abs_path, 'w') do |io|
      io.write touched_content
    end
  end
end

desc "Deletes generated documentation"
task :clobber do
  rm_rf 'doc/output'
end