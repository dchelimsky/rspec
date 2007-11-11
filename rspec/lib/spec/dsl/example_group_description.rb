module Spec
  module DSL
    class ExampleGroupDescription
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

      attr_reader :description, :described_type, :options
      
      def initialize(*args)
        args, @options = args_and_options(*args)
        init_behaviour_type
        init_spec_path
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
        when ExampleGroupDescription
          @description == value.description
        else
          @description == value
        end
      end
      
    private
      def init_behaviour_type
        # NOTE - BE CAREFUL IF CHANGING THIS NEXT LINE:
        #   this line is as it is to satisfy JRuby - the original version
        #   read, simply: "if options[:behaviour]", which passed against ruby, but failed against jruby
        if options[:behaviour] && options[:behaviour].ancestors.include?(ExampleGroup)
          proposed_behaviour_type = parse_behaviour_type(options[:behaviour])
          if ExampleGroupFactory.get(proposed_behaviour_type)
            options[:behaviour_type] ||= proposed_behaviour_type
          end
        end
      end
      
      def init_spec_path
        if options.has_key?(:spec_path)
          options[:spec_path] = File.expand_path(options[:spec_path])
        end
      end
      
      def init_description(*args)
        @description = self.class.generate_description(*args)
      end
      
      def init_described_type(args)
        @described_type = args.find{|arg| Module === arg}
      end
    
      def parse_behaviour_type(behaviour)
        class_name = get_class_name(behaviour)
        parsed_class_name = class_name.split("::").reverse[0].gsub('ExampleGroup', '')
        return nil if parsed_class_name.empty?
        parsed_class_name.downcase.to_sym
      end

      def get_class_name(behaviour)
        unless behaviour.name.empty?
          return behaviour.name
        end
        get_class_name(behaviour.superclass)
      end
    end
  end
end
