require 'rinda/ring'
require 'rinda/tuplespace'

module Spec
  module Distributed
    class RindaSlaveRunner < SlaveRunner
      include TupleArgs
      
      def process_args(args)
        process_tuple_args(args)
      end

      def run(paths, exit_when_done)
        start_or_find_ring_server
        register_self
        @started = true
        DRb.thread.join
      end

      # This is called by the master over DRb.
      # the master should be 'take'ing so re-register
      def report_dump
        super
        register_self
      end

      def start_or_find_ring_server
        DRb.start_service
        @url = DRb.uri.to_s
        begin
          puts "Looking for Ring server..."
          @ring_server = Rinda::RingFinger.new
          @service_ts = @ring_server.lookup_ring_any(2)
          puts "Located Ring server at #{@service_ts.__drburi}"
        rescue Exception
          puts "No Ring server found, starting my own."
          @service_ts = Rinda::TupleSpace.new
          @ring_server = Rinda::RingServer.new(@service_ts)
        end
      end

      def register_self
        fail_count = 0
        begin
          puts "registering service for tuple selector #{tuples.inspect}"
          @service_ts.write(tuples(self), Rinda::SimpleRenewer.new)
        rescue Exception => e
          puts "could not register my self in the tuplespace. Exception: #{e.message}"
          start_or_find_ring_server
          fail_count += 1
          retry if fail_count < 5
          puts "Unable to re-register my self. Giving up."
          exit
        end
      end
      
      def slave_watermark
        "#{@url} selecting #{@tuple_selector.inspect}"
      end

    end
  end
end

