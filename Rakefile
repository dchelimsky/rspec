task :default => :pre_commit

desc "Runs pre_commit_core and pre_commit_rails"
task :pre_commit => [
  :touch_revision_storing_files,
  :pre_commit_core,
  :update_dependencies,
  :pre_commit_rails,
  :ok_to_commit
]

desc "Runs pre_commit against rspec (core)"
task :pre_commit_core do
  Dir.chdir 'rspec' do
    rake = (PLATFORM == "i386-mswin32") ? "rake.cmd" : "rake"
    system("#{rake} pre_commit --verbose")
    raise "RSpec Core pre_commit failed" if $? != 0
  end
end

desc "Runs pre_commit against example_rails_app (against all supported Rails versions)"
task :pre_commit_rails do
  Dir.chdir 'example_rails_app' do
    rake = (PLATFORM == "i386-mswin32") ? "rake.cmd" : "rake"
    cmd = "#{rake} -f Multirails.rake pre_commit"
    system(cmd)
    if $? != 0
      raise <<-EOF
############################################################
RSpec on Rails Plugin pre_commit failed. For more info:

  cd example_rails_app
  #{cmd}

############################################################
EOF
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
    'rspec_on_rails/lib/spec/rails/version.rb'
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

RSPEC_DEPS = [
  # checkout path,                      name,         url,                                                    tagged?
  ["example_rails_app/vendor/rails/1.1.6", "rails 1.1.6", "http://dev.rubyonrails.org/svn/rails/tags/rel_1-1-6", true],
  ["example_rails_app/vendor/rails/1.2.1", "rails 1.2.1", "http://dev.rubyonrails.org/svn/rails/tags/rel_1-2-1", true],
  ["example_rails_app/vendor/rails/1.2.2", "rails 1.2.2", "http://dev.rubyonrails.org/svn/rails/tags/rel_1-2-2", true],
  ["example_rails_app/vendor/rails/edge", "edge rails", "http://svn.rubyonrails.org/rails/trunk", false],
  ["example_rails_app/vendor/plugins/assert_select", "assert_select", "http://labnotes.org/svn/public/ruby/rails_plugins/assert_select", false],
]

desc "Installs dependencies for development environment"
task :install_dependencies do
  Dir.chdir 'example_rails_app' do
    RSPEC_DEPS.each do |dep|
      puts "\nChecking for #{dep[1]} ..."
      dest = File.expand_path(File.join(File.dirname(__FILE__), dep[0]))
      if File.exists?(dest)
        puts "#{dep[1]} already installed"
      else
        cmd = "svn co #{dep[2]} #{dest}"
        puts "Installing #{dep[1]}"
        puts "This may take a while."
        puts cmd
        system(cmd)
        puts "Done!"
      end
    end
    puts
  end
end

desc "Updates dependencies for development environment"
task :update_dependencies do
  RSPEC_DEPS.each do |dep|
    raise "There is no checkout of #{dep[0]}. Please run rake install_dependencies" unless File.exist?(dep[0])
    # Verify that the current working copy is right
    if `svn info #{dep[0]}` =~ /^URL: (.*)/
      actual_url = $1
      if actual_url != dep[2]
        raise "Your working copy in #{dep[0]} points to \n#{actual_url}\nIt has moved to\n#{dep[2]}\nPlease delete the working copy and run rake install_dependencies"
      end
    end
    next if dep[3] #
    puts "\nUpdating #{dep[1]} ..."
    dest = File.expand_path(File.join(File.dirname(__FILE__), dep[0]))
    system("svn cleanup #{dest}")
    cmd = "svn up #{dest}"
    puts cmd
    system(cmd)
    puts "Done!"
  end
end