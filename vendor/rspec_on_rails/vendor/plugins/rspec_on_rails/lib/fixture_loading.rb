
module Spec
  module Runner

    class Specification
      attr_accessor :loaded_fixtures
    end

    class Context
      cattr_accessor :fixture_path

      class_inheritable_accessor :fixture_table_names
      class_inheritable_accessor :fixture_class_names
      class_inheritable_accessor :use_transactional_fixtures
      class_inheritable_accessor :use_instantiated_fixtures   # true, false, or :no_instances
      class_inheritable_accessor :pre_loaded_fixtures

      attr_accessor :loaded_fixtures, :setup_block, :teardown_block

      self.fixture_table_names        = []
      self.use_transactional_fixtures = false
      self.use_instantiated_fixtures  = true
      self.pre_loaded_fixtures        = false
      
      self.fixture_class_names  = {}
      
      @@already_loaded_fixtures = {}
      self.fixture_class_names  = {}
      
      def self.set_fixture_class(class_names = {})
        self.fixture_class_names = self.fixture_class_names.merge(class_names)
      end
      
      def self.fixtures(*table_names)
        table_names = table_names.flatten.map { |n| n.to_s }
        self.fixture_table_names |= table_names
        require_fixture_classes(table_names)
        setup_fixture_accessors(table_names)
      end

      def fixtures(*table_names)
        self.class.fixtures(*table_names)
      end

      def self.require_fixture_classes(table_names=nil)
        (table_names || fixture_table_names).each do |table_name| 
          file_name = table_name.to_s
          file_name = file_name.singularize if ActiveRecord::Base.pluralize_table_names
          begin
            require file_name
          rescue LoadError
            # Let's hope the developer has included it himself
          end
        end
      end

      def self.setup_fixture_accessors(table_names=nil)

        (table_names || fixture_table_names).each do |table_name|
          table_name = table_name.to_s.tr('.','_')

          # define_method(table_name) 
          # when defining the methods into Spec::Runner::ExecutionContext, you need to make sure
          # it gets all the data it needs passed through somehow
          # this is done in the lambda's in Spec::Runner::Context#run
          Spec::Runner::ExecutionContext.send(:define_method, table_name) do |fixture, *optionals|

            force_reload = optionals.shift
            @fixture_cache[table_name] ||= Hash.new
            @fixture_cache[table_name][fixture] = nil if force_reload

            if @spec.loaded_fixtures[table_name][fixture.to_s]
              @fixture_cache[table_name][fixture] ||= @spec.loaded_fixtures[table_name][fixture.to_s].find
            else
              raise StandardError, "No fixture with name '#{fixture}' found for table '#{table_name}'"
            end
          end
        end
      end

      def self.uses_transaction(*methods)
        @uses_transaction ||= []
        @uses_transaction.concat methods.map { |m| m.to_s }
      end

      def self.uses_transaction?(method)
        @uses_transaction && @uses_transaction.include?(method.to_s)
      end

      # instance
      def use_transactional_fixtures?
        use_transactional_fixtures 
        #&&
        #!self.class.uses_transaction?(method_name)
      end

      def setup_with_fixtures
        if pre_loaded_fixtures && use_transactional_fixtures?
          raise RuntimeError, 'pre_loaded_fixtures requires use_transactional_fixtures' 
        end

        # @fixture_cache = Hash.new

        # Load fixtures once and begin transaction.
        if use_transactional_fixtures?
          if @@already_loaded_fixtures[self.class]
            @loaded_fixtures = @@already_loaded_fixtures[self.class]
          else
            load_fixtures
            @@already_loaded_fixtures[self.class] = @loaded_fixtures
          end
          ActiveRecord::Base.lock_mutex
          ActiveRecord::Base.connection.begin_db_transaction

        # Load fixtures for every test.
        else
          @@already_loaded_fixtures[self.class] = nil
          load_fixtures
        end

        # Instantiate fixtures for every test if requested.
        instantiate_fixtures if use_instantiated_fixtures
      end

      def teardown_with_fixtures
        # Rollback changes.
        if use_transactional_fixtures?
          ActiveRecord::Base.connection.rollback_db_transaction
          ActiveRecord::Base.unlock_mutex
        end
        ActiveRecord::Base.verify_active_connections!
      end

      private
        def load_fixtures
          @loaded_fixtures = {}
          fixtures = Fixtures.create_fixtures(fixture_path, fixture_table_names, fixture_class_names)
          unless fixtures.nil?
            if fixtures.instance_of?(Fixtures)
              @loaded_fixtures[fixtures.table_name] = fixtures
            else
              fixtures.each { |f| @loaded_fixtures[f.table_name] = f }
            end
          end
        end

        # for pre_loaded_fixtures, only require the classes once. huge speed improvement
        @@required_fixture_classes = false

        def instantiate_fixtures
          if pre_loaded_fixtures
            raise RuntimeError, 'Load fixtures before instantiating them.' if Fixtures.all_loaded_fixtures.empty?
            unless @@required_fixture_classes
              self.class.require_fixture_classes Fixtures.all_loaded_fixtures.keys
              @@required_fixture_classes = true
            end
            Fixtures.instantiate_all_loaded_fixtures(self, load_instances?)
          else
            raise RuntimeError, 'Load fixtures before instantiating them.' if @loaded_fixtures.nil?
            @loaded_fixtures.each do |table_name, fixtures|
              Fixtures.instantiate_fixtures(self, table_name, fixtures, load_instances?)
            end
          end
        end

        def load_instances?
          use_instantiated_fixtures != :no_instances
        end


    end
  end
end
