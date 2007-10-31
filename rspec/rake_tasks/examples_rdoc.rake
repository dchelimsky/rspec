require 'rake'
require 'spec/rake/spectask'

desc "Generate specdocs for examples for inclusion in RDoc"
Spec::Rake::SpecTask.new('examples_rdoc') do |t|
  t.spec_files = FileList['examples/**/*.rb']
  t.spec_opts = ["--format", "rdoc:EXAMPLES.rd"]
end