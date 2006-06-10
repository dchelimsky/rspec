require 'spec/rake/spectask'

desc 'Run all model and controller specs'
task :spec do
  Rake::Task["spec:models"].invoke       rescue got_error = true
  Rake::Task["spec:controllers"].invoke rescue got_error = true

  # not yet supported
  #if File.exist?("spec/integration")
  #  Rake::Task["spec:integration"].invoke rescue got_error = true
  #end

  raise "RSpec failures" if got_error
end

namespace :spec do
  desc "Run the specs under spec/models"
  Spec::Rake::SpecTask.new(:models => "db:test:prepare") do |t|
    t.spec_files = FileList['spec/models/**/*_spec.rb']
  end

  desc "Run the specs under spec/controllers"
  Spec::Rake::SpecTask.new(:controllers => "db:test:prepare") do |t|
    t.spec_files = FileList['spec/controllers/**/*_spec.rb']
  end
  
  namespace :translate do
    desc "Translate test/unit to spec/models"
    task :unit do
      `test2spec --specdir spec/models test/unit`
    end

    desc "Translate test/functional to spec/controllers"
    task :functional do
      `test2spec --specdir spec/controllers test/functional`
    end
  end
end
