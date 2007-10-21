module Spec
  module DSL
    class BehaviourDescription
      module ClassMethods
        def generate_description(*args)
          description = args.shift.to_s
          until args.empty?
            suffix = args.shift.to_s
            description << " " unless suffix =~ /^\s|\.|#/
            description << suffix
          end
          description
        end
      end
      extend ClassMethods

      attr_reader :description, :described_type
      
      def initialize(*args)
        args, @options = args_and_options(*args)
        init_behaviour_type(@options)
        init_spec_path(@options)
        init_described_type(args)
        init_description(*args)
      end
  
      def [](key)
        @options[key]
      end
      
      def []=(key, value)
        @options[key] = value
      end
      
      def to_s; @description; end
      
      def ==(value)
        case value
        when BehaviourDescription
          @description == value.description
        else
          @description == value
        end
      end
      
    private
      def init_behaviour_type(options)
        # NOTE - BE CAREFUL IF CHANGING THIS NEXT LINE:
        #   this line is as it is to satisfy JRuby - the original version
        #   read, simply: "if options[:behaviour_class]", which passed against ruby, but failed against jruby
        if options[:behaviour_class] && options[:behaviour_class].ancestors.include?(Example)
          proposed_behaviour_type = parse_behaviour_type(@options[:behaviour_class])
          if BehaviourFactory.get(proposed_behaviour_type)
            options[:behaviour_type] ||= proposed_behaviour_type
          end
        end
      end
      
      def init_spec_path(options)
        if options.has_key?(:spec_path)
          options[:spec_path] = File.expand_path(@options[:spec_path])
        end
      end
      
      def init_description(*args)
        @description = self.class.generate_description(*args)
      end
      
      def init_described_type(args)
        @described_type = args.find{|arg| Module === arg}
      end
    
      def parse_behaviour_type(behaviour_class)
        class_name = get_class_name(behaviour_class)
        parsed_class_name = class_name.split("::").reverse[0].gsub('Example', '')
        return nil if parsed_class_name.empty?
        parsed_class_name.downcase.to_sym
      end

      def get_class_name(behaviour_class)
        unless behaviour_class.name.empty?
          return behaviour_class.name
        end
        get_class_name(behaviour_class.superclass)
      end
    end
  end
end
