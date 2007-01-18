class RspecResourceGenerator < Rails::Generator::NamedBase
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_path, "#{class_name}")

      # Controller, helper, views, and spec directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('spec/controllers', controller_class_path))
      m.directory(File.join('spec/models', class_path))
      m.directory File.join('spec/fixtures', class_path)
      m.directory File.join('spec/views', controller_class_path, controller_file_name)
      
      # Controller spec, class, and helper.
      m.template 'rspec_resource:controller_spec.rb',
        File.join('spec/controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb")

      m.template 'scaffold_resource:controller.rb',
        File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")

      m.template 'scaffold_resource:helper.rb',
        File.join('app/helpers', controller_class_path, "#{controller_file_name}_helper.rb")

      for action in scaffold_views
        m.template(
          "scaffold_resource:view_#{action}.rhtml",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.rhtml")
        )
      end
      
      # Model class, unit test, and fixtures.
      m.template 'model:model.rb',      File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'model:fixtures.yml',  File.join('spec/fixtures', class_path, "#{table_name}.yml")
      m.template 'rspec_model:model_spec.rb',       File.join('spec/models', class_path, "#{file_name}_spec.rb")

      # View specs
      m.template 'rspec_resource:edit_rhtml_spec.rb',
        File.join('spec/views', controller_class_path, controller_file_name, "edit_rhtml_spec.rb")
      m.template 'rspec_resource:index_rhtml_spec.rb',
        File.join('spec/views', controller_class_path, controller_file_name, "index_rhtml_spec.rb")
      m.template 'rspec_resource:new_rhtml_spec.rb',
        File.join('spec/views', controller_class_path, controller_file_name, "new_rhtml_spec.rb")
      m.template 'rspec_resource:show_rhtml_spec.rb',
        File.join('spec/views', controller_class_path, controller_file_name, "show_rhtml_spec.rb")

      unless options[:skip_migration]
        m.migration_template(
          'model:migration.rb', 'db/migrate', 
          :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}",
            :attributes     => attributes
          }, 
          :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
        )
      end

      m.route_resources controller_file_name

    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} rspec_resource ModelName [field:type field:type]"
    end

    def scaffold_views
      %w[ index show new edit ]
    end

    def model_name 
      class_name.demodulize
    end
end

module Rails
  module Generator
    class GeneratedAttribute
      def default_value
        @default_value ||= case type
          when :integer                     then "1"
          when :float                       then "1.5"
          when :decimal                     then "\"9.99\""
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string                      then "\"MyString\""
          when :text                        then "\"MyText\""
          when :boolean                     then "false"
          else
            ""
        end      
      end
    end
  end
end