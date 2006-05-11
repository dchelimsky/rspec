$:.unshift('lib')
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/version'
require 'spec/rake/spectask'
require 'spec/rake/rcov_verify'
require 'test/rcov/rcov_testtask'

# Some of the tasks are in separate files since they are also part of the website documentation
load File.dirname(__FILE__) + '/test/tasks/examples.rake'
load File.dirname(__FILE__) + '/test/tasks/examples_specdoc.rake'
load File.dirname(__FILE__) + '/test/tasks/examples_with_rcov.rake'
load File.dirname(__FILE__) + '/test/tasks/rcov_verify.rake'

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

task :default => [:test]

desc "Run all failing examples"
Spec::Rake::SpecTask.new('failing_examples') do |t|
  t.spec_files = FileList['failing_examples/**/*_spec.rb']
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

RCov::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc 'Generate HTML documentation'
task :doc do
  sh %{pushd doc; webgen; popd}
end

desc 'Generate RDoc'
rd = Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'doc/output/rdoc'
  rdoc.title    = "RSpec"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include('README', 'CHANGES', 'EXAMPLES.rd', 'lib/**/*.rb')
end

spec = Gem::Specification.new do |s|
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

  s.has_rdoc = true
  s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
  s.rdoc_options <<
    '--title' <<  'RSpec' <<
    '--main' << 'README' <<
    '--line-numbers'
  
  s.test_files = Dir.glob('test/*_test.rb')
  s.require_path = 'lib'
  s.autorequire = 'spec'
  s.bindir = "bin"
  s.executables = ["spec", "test2rspec"]
  s.default_executable = "spec"
  s.author = "Steven Baker" 
  s.email = "srbaker@pobox.com"
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
  egrep /#.*(FIXME|TODO|TBD)/
end

task :clobber do
  rm_rf 'coverage'
  rm_rf 'doc/output'
end

task :release => [:clobber, :verify_user, :verify_password, :test, :publish_packages, :publish_website, :publish_news]

desc "Build the website with rdoc and rcov, but do not publish it"
task :website => [:clobber, :copy_rcov_report, :doc, :examples_specdoc, :rdoc]

task :copy_rcov_report => [:test_with_rcov, :rcov_verify] do
  rm_rf 'doc/output/coverage'
  mkdir 'doc/output' unless File.exists? 'doc/output'
  mv 'coverage', 'doc/output'
end

task :verify_user do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
  raise "BEHAVIOURDRIVEN_USER environment variable not set!" unless ENV['BEHAVIOURDRIVEN_USER']
end

task :verify_password do
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end

desc "Upload Website to RubyForge"
task :publish_website => [:verify_user, :website] do
  publisher = Rake::SshDirPublisher.new(
    "#{ENV['BEHAVIOURDRIVEN_USER']}@www.behaviourdriven.org",
    "/var/www/behaviourdriven.org/htdocs/#{PKG_NAME}",
    "doc/output"
  )

  publisher.upload
end

desc "Publish gem+tgz+zip on RubyForge. You must make sure lib/version.rb is aligned with the CHANGELOG file"
task :publish_packages => [:verify_user, :verify_password, :package] do
  require 'meta_project'
  require 'rake/contrib/xforge'
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
task :publish_news => [:verify_user, :verify_password] do
  require 'meta_project'
  require 'rake/contrib/xforge'
  Rake::XForge::NewsPublisher.new(MetaProject::Project::XForge::RubyForge.new(PKG_NAME)) do |news|
    # Never hardcode user name and password in the Rakefile!
    news.user_name = ENV['RUBYFORGE_USER']
    news.password = ENV['RUBYFORGE_PASSWORD']
  end
end
