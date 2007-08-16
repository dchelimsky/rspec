
module Spec
  module Distributed
    module TupleArgs
      def process_tuple_args(args)
        if args
          tuple_values = args.split(/,/, -1)
          raise ArgumentError.new("No empty tuple selectors allowed") if tuple_values.include?("") 
          @tuple_selector = tuple_values.map { |s| s == "*" ? nil : s }  
        else
          @tuple_selector = nil
        end
      end

      def tuples(drb_object=nil)
        if @tuple_selector
          [:rspec_slave, :RindaSlaveRunner, drb_object, *@tuple_selector]
        else
          [:rspec_slave, :RindaSlaveRunner, drb_object]
        end
      end

    end
  end
end
