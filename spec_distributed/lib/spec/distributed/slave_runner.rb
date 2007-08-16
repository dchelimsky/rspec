module Spec
  module Distributed
    class SlaveRunner < ::Spec::Runner::BehaviourRunner
      def initialize(options, args=nil)
        super(options)
        process_args(args)
      end

      def process_args(args)
        @url = args
        raise "You must pass the DRb URL: --runner #{self.class}:druby://host1:port1" if @url.nil?
      end

      def run(paths, exit_when_done)
        @started = true
        puts "Whip me on #{slave_watermark}"
        DRb.start_service(@url, self)
        DRb.thread.join
      end

      # This is called by the master over DRb.
      def prepare_run(master_paths, master_svn_rev)
        begin
          update_wc(master_svn_rev)
          prepare!(master_paths)
        rescue => e
          STDERR.puts e.message
          STDERR.puts e.backtrace.join("\n")
          exit(1)
        end
      end

      # This is called by the master over DRb.
      def run_behaviour_at(behaviour_index, dry_run, reverse, timeout)
        begin
          behaviour = @behaviours[behaviour_index]

          # We'll report locally, but also record what happened so we can send
          # that back to the master
          recorder = Recorder.new(slave_watermark)
          reporter = Dispatcher.new(recorder, @options.reporter)

          behaviour.run(reporter, dry_run, reverse, timeout)
          recorder
        rescue => e
          STDERR.puts e.message
          STDERR.puts e.backtrace.join("\n")
          exit(1)
        end
      end
      
      # This is called by the master over DRb.
      def report_dump
        super
        puts "=" * 70
      end
      
      def update_wc(master_svn_rev)
        Dir.chdir(top_svn_dir) do
          local_rev = `svn info`.match(/^Revision: (\d+)$/n)[1] rescue nil
          raise "This is not a svn working copy, but the master is (r#{master_svn_rev})" if master_svn_rev && local_rev.nil?
          if(local_rev.to_i != master_svn_rev.to_i)
            system("svn up -r#{master_svn_rev}")
          end
        end
      end

      def top_svn_dir
        dir = '.'
        loop do
          up = File.join(dir, '..')
          if File.directory?(File.join(up, '.svn'))
            dir = up
          else
            break
          end
        end
        dir
      end
    end

    def slave_watermark
      @url
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
      def initialize(watermark)
        @watermark = watermark
        @invocations = []
      end

      def method_missing(method, *args)
        marshallable_args = args.map {|arg| marshallable_dup(arg)}

        if method.to_s == 'add_behaviour'
          # Watermark each behaviour name so the final report says where it ran
          marshallable_args[0] = "#{marshallable_args[0].to_s} (#{@watermark})" 
        end
        @invocations << [method, *marshallable_args]
      end
    
      def marshallable_dup(o)
        begin
          dupe = o.dup
          dupe.instance_variables.each do |ivar|
            if Proc === dupe.instance_variable_get(ivar)
              dupe.__send__(:remove_instance_variable, ivar)
            end
          end
          dupe
        rescue TypeError # Some objects like nil and false cannot be duped, and there is no easy way to check for all cases
          o
        end
      end
      
      def replay(target)
        @invocations.each do |method, *args|
          target.__send__(method, *args)
        end
      end
    end
  end
end
