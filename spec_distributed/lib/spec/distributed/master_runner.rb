require 'thread'
require 'spec/distributed/slave_runner'

module Spec
  module Distributed
    class MasterRunner < ::Spec::Runner::BehaviourRunner
      def initialize(options, args=nil)
        super(options)
        @slave_urls = args.split(",")
        raise "You must pass the DRb URLs: --runner #{self.class}:druby://host1:port1,drb://host2:port2" if @slave_urls.empty?
      end
      
      def run(paths, exit_when_done)
        @master_paths = paths
        @svn_rev = `svn info`.match(/Revision: (\d+)/m)[1] rescue nil
        STDERR.puts "WARNING - no local svn revision found. Your slaves may be out of sync." if @svn_rev.nil?
        super(paths, exit_when_done)
      end
      
      def run_behaviours
        DRb.start_service
        behaviour_reports = Queue.new
        index_queue = Queue.new
        @behaviours.length.times {|index| index_queue << index}

        @threads = @slave_urls.map do |slave_url|
          slave_runner = DRbObject.new_with_uri(slave_url)
          Thread.new do
            slave_runner.prepare_run(@master_paths, @svn_rev)
            while !index_queue.empty?
              i = index_queue.pop
              behaviour = @behaviours[i]
              behaviour_report = slave_runner.run_behaviour_at(i, @options.dry_run, @options.reverse, @options.timeout)
              behaviour_reports << behaviour_report
            end
            slave_runner.report_end
            slave_runner.report_dump
          end
        end
        
        # Add a last thread for the reporter
        @threads << Thread.new do
          @behaviours.length.times do
            behaviour_reports.pop.replay(@options.reporter)
          end
        end

        @threads.each {|t| t.join}
      end
    end
  end
end
