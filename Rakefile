$:.unshift('lib')
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'
require 'rake/rdoctask'
require 'spec/version'

# Some of the tasks are in separate files since they are also part of the website documentation
load File.dirname(__FILE__) + '/tasks/examples.rake'
load File.dirname(__FILE__) + '/tasks/examples_specdoc.rake'
load File.dirname(__FILE__) + '/tasks/examples_with_rcov.rake'
load File.dirname(__FILE__) + '/tasks/failing_examples_with_html.rake'
load File.dirname(__FILE__) + '/tasks/verify_rcov.rake'

PKG_NAME = "rspec"
PKG_VERSION   = Spec::VERSION::STRING
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb', 
  'test/**/*.rb', 
  'examples/**/*',
  'vendor/watir/*.rb',
  'vendor/watir/*.txt',
  'vendor/selenium/*.rb',
  'vendor/selenium/*.patch',
  'vendor/selenium/*.txt'
]

task :default => [:spec, :verify_rcov]

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb', 'vendor/RSpec.tmbundle/Support/spec/*_spec.rb']
  t.spec_opts = ['--diff','--color','--backtrace']
  t.rcov = true
  t.rcov_dir = 'doc/output/coverage'
  t.rcov_opts = ['--exclude', 'spec\/spec,bin\/spec,bin\/drbspec,examples']
end

desc "Run all failing examples"
Spec::Rake::SpecTask.new('failing_examples') do |t|
  t.spec_files = FileList['failing_examples/**/*_spec.rb']
end

desc 'Verify that no warnings occur'
task :verify_warnings do
  `ruby -w #{File.dirname(__FILE__) + '/bin/spec'} --help 2> warnings.txt`
  warnings = File.open('warnings.txt').read
  File.rm 'warnings.txt'
  raise "There were warnings:\n#{warnings}" if warnings =~ /warning/n
end

desc 'Generate HTML documentation for website'
task :webgen do
  Dir.chdir 'doc' do
    output = nil
    IO.popen('webgen 2>&1') do |io|
      output = io.read
    end
    raise "ERROR while running webgen: #{output}" if output =~ /ERROR/n || $? != 0
  end
end

desc 'Generate RDoc'
rd = Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/output/rdoc'
  rdoc.options << '--title' << 'RSpec' << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include('README', 'CHANGES', 'EXAMPLES.rd', 'lib/**/*.rb')
end
task :rdoc => :examples_specdoc # We generate EXAMPLES.rd

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = Spec::VERSION::DESCRIPTION
  s.description = <<-EOF
    RSpec is a behaviour driven development (BDD) framework for Ruby.  RSpec was 
    created in response to Dave Astels' article _A New Look at Test Driven Development_ 
    which can be read at: http://daveastels.com/index.php?p=5  RSpec is intended to
    provide the features discussed in Dave's article.
  EOF

  s.files = PKG_FILES.to_a
  s.require_path = 'lib'

  s.has_rdoc = true
  s.rdoc_options = rd.options
  s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$|^EXAMPLES.rd$/ }.to_a
  
  s.test_files = Dir.glob('test/*_test.rb')
  s.require_path = 'lib'
  s.autorequire = 'spec'
  s.bindir = 'bin'
  s.executables = ['spec', 'drbspec']
  s.default_executable = 'spec'
  s.author = ["Steven Baker", "Aslak Hellesoy", "Dave Astels", "David Chelimsky", "Brian Takita"]
  s.email = "rspec-devel@rubyforge.org"
  s.homepage = "http://rspec.rubyforge.org"
  s.rubyforge_project = "rspec"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

def egrep(pattern)
  Dir['**/*.rb'].each do |fn|
    count = 0
    open(fn) do |f|
      while line = f.gets
        count += 1
        if line =~ pattern
          puts "#{fn}:#{count}:#{line}"
        end
      end
    end
  end
end

desc "Look for TODO and FIXME tags in the code"
task :todo do
  egrep /(FIXME|TODO|TBD)/
end

task :clobber do
  rm_rf 'doc/output'
end

desc "Touches files storing revisions so that svn will update $LastChangedRevision"
task :touch_revision_storing_files do
  # See http://svnbook.red-bean.com/en/1.0/ch07s02.html - the section on svn:keywords
  files = [
    'lib/spec/version.rb', 
    'vendor/rspec_on_rails/vendor/plugins/rspec/lib/spec/rails/version.rb'
  ]
  touch_needed = false
  IO.popen('svn stat') do |io|
    io.each_line do |line|
      if line =~ /^M\s*(.*)/
        touch_needed = !files.index($1)
        break if touch_needed
      end
    end
  end
  
  if touch_needed
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
end

task :release => [:clobber, :verify_committed, :verify_user, :verify_password, :spec, :publish_packages, :tag, :publish_website, :publish_news]

desc "Verifies that there is no uncommitted code"
task :verify_committed do
  IO.popen('svn stat') do |io|
    io.each_line do |line|
      raise "\n!!! Do a svn commit first !!!\n\n" if line =~ /^\s*M\s*/
    end
  end
end

desc "Creates a tag in svn"
task :tag do
  puts "Creating tag in SVN"
  `svn cp svn+ssh://#{ENV['RUBYFORGE_USER']}@rubyforge.org/var/svn/rspec/trunk svn+ssh://#{ENV['RUBYFORGE_USER']}@rubyforge.org/var/svn/rspec/tags/#{Spec::VERSION::TAG} -m "Tag release #{Spec::VERSION::STRING}"`
  puts "Done!"
end

desc "Run this task before you commit. You should see 'OK TO COMMIT'"
task :pre_commit => [
  :touch_revision_storing_files, 
  :verify_warnings, 
  :website, 
  :examples, 
  :failing_examples_with_html, 
  :rails_pre_commit, 
  :commit_ok]

task :rails_pre_commit do
  Dir.chdir 'vendor/rspec_on_rails' do    
    IO.popen("rake pre_commit --verbose") do |io|
      io.each do |line|
        puts line
      end
    end
    raise "RSpec on Rails pre_commit failed" if $? != 0
  end
end

task :commit_ok do |t|
  puts "OK TO COMMIT"
end

desc "Build the website, but do not publish it"
task :website => [:clobber, :verify_rcov, :webgen, :failing_examples_with_html, :spec, :examples_specdoc, :rdoc]

task :verify_user do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
end

task :verify_password do
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end

desc "Upload Website to RubyForge"
task :publish_website => [:verify_user, :website] do
  publisher = Rake::SshDirPublisher.new(
    "rspec-website@rubyforge.org",
    "/var/www/gforge-projects/#{PKG_NAME}",
    "doc/output"
  )

  publisher.upload
end

desc "Package the RSpec.tmbundle"
task :package_tmbundle => :pkg do
  rm_rf 'pkg/RSpec.tmbundle'
  `svn export vendor/RSpec.tmbundle pkg/RSpec.tmbundle`
  Dir.chdir 'pkg' do
    `tar cvzf RSpec-#{PKG_VERSION}.tmbundle.tgz RSpec.tmbundle`
  end
end
task :package => :package_tmbundle

desc "Publish gem+tgz+zip on RubyForge. You must make sure lib/version.rb is aligned with the CHANGELOG file"
task :publish_packages => [:verify_user, :verify_password, :package] do
  require 'meta_project'
  require 'rake/contrib/xforge'
  release_files = FileList[
    "pkg/#{PKG_FILE_NAME}.gem",
    "pkg/#{PKG_FILE_NAME}.tgz",
    "pkg/#{PKG_FILE_NAME}.zip",
    "pkg/RSpec-#{PKG_VERSION}.tmbundle.tgz"
  ]

  Rake::XForge::Release.new(MetaProject::Project::XForge::RubyForge.new(PKG_NAME)) do |xf|
    # Never hardcode user name and password in the Rakefile!
    xf.user_name = ENV['RUBYFORGE_USER']
    xf.password = ENV['RUBYFORGE_PASSWORD']
    xf.files = release_files.to_a
    xf.release_name = "RSpec #{PKG_VERSION}"
  end
end

desc "Publish news on RubyForge"
task :publish_news => [:verify_user, :verify_password] do
  require 'meta_project'
  require 'rake/contrib/xforge'
  Rake::XForge::NewsPublisher.new(MetaProject::Project::XForge::RubyForge.new(PKG_NAME)) do |news|
    # Never hardcode user name and password in the Rakefile!
    news.user_name = ENV['RUBYFORGE_USER']
    news.password = ENV['RUBYFORGE_PASSWORD']
  end
end
