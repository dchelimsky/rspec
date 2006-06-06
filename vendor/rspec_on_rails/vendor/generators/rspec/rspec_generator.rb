# This generator adds the basic spec_helper.rb
# and rake tasks required to use RSpec with Rails
class RspecGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      # The spec helper and Rake tasks
      m.directory 'spec'
      m.template 'spec_helper.rb', 'spec/spec_helper.rb'
      m.template 'rspec.rake', 'lib/tasks/rspec.rake'

      # Copy out the rspec_model generator
      m.directory 'vendor/generators/rspec_model/templates'
      m.file 'rspec_model/USAGE',                    'vendor/generators/rspec_model/USAGE'
      m.file 'rspec_model/rspec_model_generator.rb', 'vendor/generators/rspec_model/rspec_model_generator.rb'
      m.file 'rspec_model/templates/model_spec.rb',  'vendor/generators/rspec_model/templates/model_spec.rb'

      # Copy out the rspec_controller generator
      m.directory 'vendor/generators/rspec_controller/templates'
      m.file 'rspec_controller/USAGE',                         'vendor/generators/rspec_controller/USAGE'
      m.file 'rspec_controller/rspec_controller_generator.rb', 'vendor/generators/rspec_controller/rspec_controller_generator.rb'
      m.file 'rspec_controller/templates/controller_spec.rb',  'vendor/generators/rspec_controller/templates/controller_spec.rb'
    end
  end

  protected
    def banner
      "Usage: #{$0} rspec"
    end

end
