module RCov
  class VerifyTask < Rake::TaskLib
    attr_accessor :name
    attr_accessor :index_html
    attr_accessor :threshold
    attr_accessor :verbose
    
    def initialize(name=:rcov_verify)
      @name = name
      yield self if block_given?
      raise "Threshold must be set" if @threshold.nil?
      define
    end
    
    def define
      desc "Verify that rcov coverage is at least #{threshold}"
      task @name do
        total_coverage = nil
        File.open(index_html).each_line do |line|
          if line =~ /<tt>(\d+\.\d+)%<\/tt>&nbsp;<\/td>/
            total_coverage = eval($1)
            break
          end
        end
        puts "Coverage: #{total_coverage}% (threshold: #{threshold}%)" if verbose
        raise "Coverage must be at least #{threshold}% but was #{total_coverage}%" if total_coverage < threshold
      end
    end
  end
end