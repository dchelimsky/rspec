module Spec
  module Distributed
    class SlaveRunner < ::Spec::Runner::BehaviourRunner
      def initialize(options, url=nil)
        super(options)
        @url = url
        raise "You must pass the DRb URL: --runner #{self.class}:drb://host1:port1" if @url.nil?
      end

      def run(paths, exit_when_done)
        @started = true
        puts "Whip me on #{@url}"
        DRb.start_service(@url, self)
        DRb.thread.join
      end

      # This is called by the master over DRb.
      def prepare_run(master_paths, master_svn_rev)
        update_wc(master_svn_rev)
        prepare!(master_paths)
      end

      # This is called by the master over DRb.
      def run_behaviour_at(behaviour_index, dry_run, reverse, timeout)
        behaviour = @behaviours[behaviour_index]

        # We'll report locally, but also record what happened so we can send
        # that back to the master
        recorder = Recorder.new
        reporter = Dispatcher.new(recorder, @options.reporter)

        behaviour.run(reporter, dry_run, reverse, timeout)
        recorder
      end
      
      # This is called by the master over DRb.
      def report_dump
        super
        puts "=" * 70
      end
      
      def update_wc(master_svn_rev)
        local_rev = `svn info`.match(/Revision: (\d+)/m)[1] rescue nil
        raise "This is not a svn working copy, but the master is (r#{master_svn_rev})" if master_svn_rev && local_rev.nil?
        if(local_rev != master_svn_rev)
          system("svn up -r#{master_svn_rev}")
        end
      end
    end
    
    class Dispatcher
      def initialize(*children)
        @children = children
      end

      def method_missing(method, *args)
        @children.each{|child| child.__send__(method, *args)}
      end
    end
    
    # This is used as a reporter and just records method invocations. It is then
    # sent back to the master and all the invocations are replayed there on the master's
    # *real* reporter. Nifty, eh?
    class Recorder
      def initialize
        @invocations = []
      end

      def method_missing(method, *args)
        @invocations << [method, *args]
      end
      
      def replay(target)
        @invocations.each do |method, *args|
          target.__send__(method, *args)
        end
      end
    end
  end
end
