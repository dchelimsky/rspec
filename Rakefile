$:.unshift('lib')
require 'rubygems'
require 'meta_project'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/contrib/xforge'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'lib/spec/version'
require 'lib/spec/rake/spectask'
require 'test/rake/rcov_testtask'

PKG_NAME = "rspec"
# Versioning scheme: MAJOR.MINOR.PATCH
# MAJOR bumps when API is broken backwards
# MINOR bumps when the API is broken backwards in a very slight/subtle (but not fatal) way
# -OR when a new release is made and propaganda is sent out.
# PATCH is bumped for every API addition and/or bugfix (ideally for every commit)

PKG_VERSION   = Spec::VERSION::STRING
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb', 
  'test/**/*.rb', 
  'examples/**/*.rb', 
  'doc/**/*'
]

task :default => [:test] #, :test_text_runner]

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['examples/**/*_spec.rb']
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

# Generates the HTML documentation
desc 'Generate documentation'
task :doc do
  sh %{pushd doc; webgen; popd }
end

desc 'Generate RDoc'
rd = Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'doc/output/rdoc'
  rdoc.title    = "RSpec"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include('CHANGES')
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
  s.executables = ["spec", "test2rspec"]
  s.default_executable = "spec"

  #### Author and project details.

  s.author = "Steven Baker" 
  s.email = "srbaker@pobox.com"
  s.homepage = "http://rspec.rubyforge.org"
  s.rubyforge_project = "rspec"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

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

task :clobber do
  rm_rf 'coverage'
  rm_rf 'doc/output'
end

task :release => [:clobber, :test, :verify_env_vars, :upload_releases, :publish_website, :publish_news]

desc "Builds the website with rdoc and rcov, but does not publish it"
task :website => [:clobber, :test, :doc, :rdoc, :rcov]

task :rcov => [:test] do
  rm_rf 'doc/output/coverage'
  mkdir 'doc/output' unless File.exists? 'doc/output'
  mv 'coverage', 'doc/output'
end

task :verify_env_vars do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end

desc "Upload Website to RubyForge"
task :publish_website => [:website] do
  publisher = Rake::SshDirPublisher.new(
    "#{ENV['RUBYFORGE_USER']}@rubyforge.org",
    "/var/www/gforge-projects/#{PKG_NAME}",
    "doc/output"
  )

  publisher.upload
end

desc "Release gem to RubyForge. You must make sure lib/version.rb is aligned with the CHANGELOG file"
task :upload_releases => :package do

  release_files = FileList[
    "pkg/#{PKG_FILE_NAME}.gem",
    "pkg/#{PKG_FILE_NAME}.tgz",
    "pkg/#{PKG_FILE_NAME}.zip"
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
task :publish_news do
  Rake::XForge::NewsPublisher.new(MetaProject::Project::XForge::RubyForge.new(PKG_NAME)) do |news|
    # Never hardcode user name and password in the Rakefile!
    news.user_name = ENV['RUBYFORGE_USER']
    news.password = ENV['RUBYFORGE_PASSWORD']
  end
end
