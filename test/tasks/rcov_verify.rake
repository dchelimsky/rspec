require 'rake'
require 'spec/rake/rcov_verify'

RCov::VerifyTask.new(:rcov_verify => :rcov) do |t|
  t.threshold = 95.6 # Make sure you have rcov 0.7 or higher!
  t.index_html = 'doc/output/coverage/index.html'
end
