desc "Generate specdoc for examples"
Spec::Rake::SpecTask.new('examples_specdoc') do |t|
  t.spec_files = FileList['examples/**/*_spec.rb']
  t.spec_opts = ["--doc"]
  t.out = 'EXAMPLES.rd'
end