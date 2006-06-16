require 'rake'
require 'spec/rake/spectask'

desc "Generate HTML report for failing examples"
Spec::Rake::SpecTask.new('failing_examples_with_html') do |t|
  t.spec_files = FileList['failing_examples/**/*_spec.rb']
  t.spec_opts = ["--format", "html"]
  t.out = 'doc/output/tools/failing_examples.html'
  t.fail_on_error = false
end