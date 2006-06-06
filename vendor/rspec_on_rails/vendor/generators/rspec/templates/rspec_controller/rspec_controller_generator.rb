require 'rails_generator/generators/components/controller/controller_generator'

class RspecControllerGenerator < ControllerGenerator
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, "#{class_name}Controller", "#{class_name}Helper"

      # Controller, helper, views, and spec directories.
      m.directory File.join('app/controllers', class_path)
      m.directory File.join('app/helpers', class_path)
      m.directory File.join('app/views', class_path, file_name)
      m.directory File.join('spec/controllers', class_path)

      # Controller class, functional spec, and helper class.
      m.template 'controller:controller.rb',
                  File.join('app/controllers',
                            class_path,
                            "#{file_name}_controller.rb")

      m.template 'controller_spec.rb',
                  File.join('spec/controllers',
                            class_path,
                            "#{file_name}_controller_spec.rb")

      m.template 'controller:helper.rb',
                  File.join('app/helpers',
                            class_path,
                            "#{file_name}_helper.rb")

      # View template for each action.
      actions.each do |action|
        path = File.join('app/views', class_path, file_name, "#{action}.rhtml")
        m.template 'controller:view.rhtml',
          path,
          :assigns => { :action => action, :path => path }
      end
    end
  end

end
