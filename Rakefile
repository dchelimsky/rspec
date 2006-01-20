$:.unshift('lib')
require 'rubygems'
require 'meta_project'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/contrib/xforge'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

PKG_NAME = "rspec"
# Versioning scheme: MAJOR.MINOR.PATCH
# MAJOR bumps when API is broken backwards
# MINOR bumps when the API is broken backwards in a very slight/subtle (but not fatal) way
# -OR when a new release is made and propaganda is sent out.
# PATCH is bumped for every API addition and/or bugfix (ideally for every commit)
# Later DamageControl can bump PATCH automatically.
#
# (This is subject to change - AH)
#
# REMEMBER TO KEEP PKG_VERSION IN SYNC WITH CHANGELOG
PKG_VERSION = "0.3.2"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb', 
  'test/**/*.rb', 
  'examples/**/*.rb', 
  'doc/**/*'
]

task :default => [:test, :test_text_runner]

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['**/*_test.rb'].exclude("test/*_collector_test.rb",
		"test/rspec_*.rb", "test/text_runner_test.rb")
  t.verbose = true
end

# text runner tests need to run individually

Rake::TestTask.new(:test_text_runner) do |t|
	t.libs << "test"
	t.libs << "examples"
	t.test_files = FileList['test/text_runner_test.rb']
	t.verbose = true
end


# Create a task to build the RDOC documentation tree.
rd = Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.title    = "RSpec"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include('README', 'CHANGES', 'TUTORIAL')
  rdoc.rdoc_files.include('lib/**/*.rb', 'doc/**/*.rdoc')
  rdoc.rdoc_files.exclude('doc/**/*_attrs.rdoc')
end

# ====================================================================
# Create a task that will package the Rake software into distributable
# tar, zip and gem files.

spec = Gem::Specification.new do |s|

  #### Basic information.

  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "Behaviour Specification Framework for Ruby"
  s.description = <<-EOF
    RSpec is a behaviour specification framework for Ruby.  RSpec was created in
    response to Dave Astels' article _A New Look at Test Driven Development_ which
    can be read at: http://daveastels.com/index.php?p=5  RSpec is intended to
    provide the features discussed in Dave's article.
  EOF

  s.files = PKG_FILES.to_a
  s.require_path = 'lib'

  #### Documentation and testing.

  s.has_rdoc = true
  s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
  s.rdoc_options <<
    '--title' <<  'RSpec' <<
    '--main' << 'README' <<
    '--line-numbers'
  
  s.test_files = Dir.glob('test/tc_*.rb')

  #### Make executable
  s.require_path = 'lib'
  s.autorequire = 'spec'

  s.bindir = "bin"
  s.executables = ["spec"]
  s.default_executable = "spec"

  #### Author and project details.

  s.author = "Steven Baker" 
  s.email = "srbaker@pobox.com"
  s.homepage = "http://rspec.rubyforge.org"
  s.rubyforge_project = "rspec"
end

desc "Build Gem"
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
task :gem => [:test]

# Support Tasks ------------------------------------------------------

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
  egrep /#.*(FIXME|TODO|TBD)/
end

task :release => [:verify_env_vars, :release_files, :publish_doc, :publish_news]

task :verify_env_vars do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end

task :publish_doc => [:rdoc] do
  publisher = Rake::RubyForgePublisher.new(PKG_NAME, ENV['RUBYFORGE_USER'])
  publisher.upload
end

desc "Release gem to RubyForge. MAKE SURE PKG_VERSION is aligned with the CHANGELOG file"
task :release_files => [:gem] do
  release_files = FileList[
    "pkg/#{PKG_FILE_NAME}.gem"
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
task :publish_news => [:gem] do
  release_files = FileList[
    "pkg/#{PKG_FILE_NAME}.gem"
  ]

  Rake::XForge::NewsPublisher.new(MetaProject::Project::XForge::RubyForge.new(PKG_NAME)) do |news|
    # Never hardcode user name and password in the Rakefile!
    news.user_name = ENV['RUBYFORGE_USER']
    news.password = ENV['RUBYFORGE_PASSWORD']
  end
end
