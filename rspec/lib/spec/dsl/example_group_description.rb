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
        init_example_group_type
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
      def init_example_group_type
        # NOTE - BE CAREFUL IF CHANGING THIS NEXT LINE:
        #   this line is as it is to satisfy JRuby - the original version
        #   read, simply: "if options[:example_group]", which passed against ruby, but failed against jruby
        if options[:example_group] && options[:example_group].ancestors.include?(ExampleGroup)
          proposed_type = parse_type(options[:example_group])
          if ExampleGroupFactory.get(proposed_type)
            options[:behaviour_type] ||= proposed_type
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
    
      def parse_type(example_group)
        class_name = get_class_name(example_group)
        parsed_class_name = class_name.split("::").reverse[0].gsub('ExampleGroup', '')
        return nil if parsed_class_name.empty?
        parsed_class_name.downcase.to_sym
      end

      def get_class_name(example_group)
        unless example_group.name.empty?
          return example_group.name
        end
        get_class_name(example_group.superclass)
      end
    end
  end
end
