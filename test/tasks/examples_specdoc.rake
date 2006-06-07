desc "Generate specdocs for examples for inclusion in RDoc"
Spec::Rake::SpecTask.new('examples_specdoc') do |t|
  t.spec_files = FileList['examples/**/*_spec.rb']
  t.spec_opts = ["--format", "rdoc"]
  t.out = 'EXAMPLES.rd'
end