require 'rake'
require 'spec/rake/rcov_verify'

RCov::VerifyTask.new(:rcov_verify => :rcov) do |t|
  t.threshold = 95.9
  t.index_html = 'doc/output/coverage/index.html'
end
