RCov::VerifyTask.new(:rcov_verify => :rcov) do |t|
  t.threshold = 95.7
  t.index_html = 'doc/output/coverage/index.html'
end
