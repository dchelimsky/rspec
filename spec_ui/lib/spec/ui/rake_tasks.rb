module Spec
  module Ui
    def self.create_tasks
      require 'spec/rake/spectask'

      if Spec::Runner.configuration.spec_ui_report_dir.nil?
        STDERR.puts <<-EOF
You must tell Spec::Ui where the report should go.
Please put the following in your spec/spec_helper.rb file:

require 'spec'
require 'spec/ui'

Spec::Runner.configure do |config|
  config.spec_ui_report_dir = File.dirname(__FILE__) + '/report'
end
EOF
      end
        
      FileUtils.rm_rf(Spec::Runner.configuration.spec_ui_report_dir) if File.exist?(Spec::Runner.configuration.spec_ui_report_dir)
      FileUtils.mkdir_p(Spec::Runner.configuration.spec_ui_report_dir)
      
      desc "Run UI Specs"
      Spec::Rake::SpecTask.new('spec:ui') do |t|
        t.spec_files = FileList['spec/**/*.rb']
        t.spec_opts = ['--require', 'spec/spec_helper', '--format', 'Spec::Ui::WebappFormatter']
        t.out = "#{Spec::Runner.configuration.spec_ui_report_dir}/index.html"
      end
    end
  end
end
