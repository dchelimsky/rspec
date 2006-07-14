require 'rake'
require 'spec/rake/rcov_verify'

RCov::VerifyTask.new(:rcov_verify => :rcov) do |t|
  t.threshold = 96.3 # use rcov 0.6 or higher!
  t.index_html = 'doc/output/coverage/index.html'
end
