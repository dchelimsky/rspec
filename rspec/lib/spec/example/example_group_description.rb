module Spec
  module Example
    class ExampleGroupDescription
      module ClassMethods
        def description_text(*args)
          args.inject("") do |result, arg|
            result << " " unless (result == "" || arg.to_s =~ /^\s|\.|#/)
            result << arg.to_s
          end
        end
      end
      extend ClassMethods

      attr_reader :text, :described_type, :options
      alias_method :to_s, :text
      
      def initialize(*args)
        args, @options = args_and_options(*args)
        set_type
        expand_spec_path
        @described_type = args.find{|arg| Module === arg}
        @text = self.class.description_text(*args)
      end
  
      def [](key)
        @options[key]
      end
      
      def []=(key, value)
        @options[key] = value
      end
      
      def ==(value)
        case value
        when ExampleGroupDescription
          @text == value.text
        else
          @text == value
        end
      end
      
    private
      def set_type
        # NOTE - BE CAREFUL IF CHANGING THIS NEXT LINE:
        #   this line is as it is to satisfy JRuby - the original version
        #   read, simply: "if options[:example_group]", which passed against ruby, but failed against jruby
        if options[:example_group] && options[:example_group].ancestors.include?(ExampleGroup)
          proposed_type = parse_type(options[:example_group])
          if ExampleGroupFactory.get(proposed_type)
            options[:type] ||= proposed_type
          end
        end
      end
      
      def expand_spec_path
        if options.has_key?(:spec_path)
          options[:spec_path] = File.expand_path(options[:spec_path])
        end
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
