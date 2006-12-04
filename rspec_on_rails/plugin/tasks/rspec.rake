require 'spec/rake/spectask'

task :default => :spec

desc 'Run all application-specific specs'
task :spec do
  Rake::Task["spec:app"].invoke      rescue got_error = true
    
  raise "RSpec failures" if got_error
end

task :stats => "spec:statsetup"

namespace :spec do
  desc 'Run all application-specific specs'
  task :app do
    Rake::Task["spec:models"].invoke      rescue got_error = true
    Rake::Task["spec:controllers"].invoke rescue got_error = true
    Rake::Task["spec:helpers"].invoke     rescue got_error = true
    Rake::Task["spec:views"].invoke       rescue got_error = true

    raise "RSpec failures" if got_error
  end
  
  desc "Run all specs including plugins"
  task :all do
    Rake::Task["spec:app"].invoke       rescue got_error = true
    Rake::Task["spec:plugins"].invoke   rescue got_error = true

    raise "RSpec failures" if got_error
  end
  
  desc "Run the specs under spec/models"
  Spec::Rake::SpecTask.new(:models => "db:test:prepare") do |t|
    `echo "Executing specs under spec/models"`
    t.spec_files = FileList['spec/models/**/*_spec.rb']
  end

  desc "Run the specs under spec/controllers"
  Spec::Rake::SpecTask.new(:controllers => "db:test:prepare") do |t|
    t.spec_files = FileList['spec/controllers/**/*_spec.rb']
  end
  
  desc "Run the specs under spec/views"
  Spec::Rake::SpecTask.new(:views => "db:test:prepare") do |t|
    t.spec_files = FileList['spec/views/**/*_spec.rb']
  end
  
  desc "Run the specs under spec/helpers"
  Spec::Rake::SpecTask.new(:helpers => "db:test:prepare") do |t|
    t.spec_files = FileList['spec/helpers/**/*_spec.rb']
  end
  
  desc "Run the specs under vendor/plugins"
  Spec::Rake::SpecTask.new(:plugins => "db:test:prepare") do |t|
    t.spec_files = FileList['vendor/plugins/**/spec/**/*_spec.rb']
  end

  desc "Print Specdoc for all specs"
  Spec::Rake::SpecTask.new('doc') do |t|
    t.spec_files = FileList[
      'spec/models/**/*_spec.rb',
      'spec/controllers/**/*_spec.rb',
      'spec/helpers/**/*_spec.rb',
      'spec/views/**/*_spec.rb',
      'vendor/plugins/**/spec/**/*_spec.rb'
    ]
    t.spec_opts = ["--format", "specdoc"]
  end

  desc "Setup specs for stats"
  task :statsetup do
    require 'code_statistics'
    ::STATS_DIRECTORIES << %w(Model\ specs spec/models)
    ::STATS_DIRECTORIES << %w(View\ specs spec/views)
    ::STATS_DIRECTORIES << %w(Controller\ specs spec/controllers)
    ::STATS_DIRECTORIES << %w(Helper\ specs spec/views)
    ::CodeStatistics::TEST_TYPES << "Model specs"
    ::CodeStatistics::TEST_TYPES << "View specs"
    ::CodeStatistics::TEST_TYPES << "Controller specs"
    ::CodeStatistics::TEST_TYPES << "Helper specs"
    ::STATS_DIRECTORIES.delete_if {|a| a[0] =~ /test/}
  end

  namespace :db do
    namespace :fixtures do
      desc "Load fixtures (from spec/fixtures) into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
      task :load => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
        (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'spec', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
          Fixtures.create_fixtures('spec/fixtures', File.basename(fixture_file, '.*'))
        end
      end
    end
  end
end
