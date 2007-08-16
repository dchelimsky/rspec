
module Spec
  module Distributed
    class RindaMasterRunner < MasterRunner
      include TupleArgs

      def process_args(args)
        process_tuple_args(args)
      end

      def run(paths, exit_when_done)
        DRb.start_service
        begin
          @ring_server = Rinda::RingFinger.primary
        rescue Exception => e
          puts "Could not find the RingServer. Please make sure there is at least one slave running"
          exit
        end
        super
      end
      
      def slave_runners
        puts "Looking for slaves with tuple #{tuples.inspect}"
        slaves = @ring_server.read_all tuples
        puts "Found #{slaves.length} slaves"
        slaves.map { |s| @ring_server.take(s); s[2] }
      end

    end
  end
end
