require 'rake'
require 'spec/rake/verify_rcov'

RCov::VerifyTask.new(:verify_rcov => :spec) do |t|
  t.threshold = ENV["RUN_CODE_RUN"] == "true" ? 96.0 : 100.0 # Make sure you have rcov 0.7 or higher!
  t.index_html = 'coverage/index.html'
end
