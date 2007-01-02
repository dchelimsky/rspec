require 'spec/rake/spectask'

namespace :spec do
  report_dir = "#{RAILS_ROOT}/doc/spec/watir"

  desc "Run Watir"
  Spec::Rake::SpecTask.new('watir') do |t|
    t.ruby_opts = ["-I#{File.expand_path(File.dirname(__FILE__) + '/../../../../../spec_ui/lib')}"]
    t.spec_files = FileList['spec/watir/**/*_spec.rb']
    t.spec_opts = ['--require', 'rubygems,spec/ui/watir_helper', '--format', 'Spec::Ui::WebappFormatter']
    t.out = "#{report_dir}/index.html"
  end

  task :clean_report do
    img_dir = "#{report_dir}/images"
    ENV['RSPEC_IMG_DIR'] = img_dir
    FileUtils.rm_rf(report_dir) if File.exist?(report_dir)
    FileUtils.mkdir_p(img_dir)
  end

  task :watir => :clean_report
end