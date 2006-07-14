require 'rbconfig'

# This generator adds the basic spec_helper.rb,
# rails_spec for faster spec invocation
# and rake tasks required to use RSpec with Rails
class RspecGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }

      # The rails_spec runner and client scripts
      m.file 'script/rails_spec', 'script/rails_spec', script_options
      m.file 'script/rails_spec_runner', 'script/rails_spec_runner', script_options

      # The spec helper and Rake tasks
      m.directory 'spec'
      m.template  'spec_helper.rb', 'spec/spec_helper.rb'
      m.file      'test2spec.erb', 'spec/test2spec.erb'
      m.file      'test2spec_help.rb', 'test/test2spec_help.rb'
      m.directory 'lib/tasks'
      m.template  'rspec.rake', 'lib/tasks/rspec.rake'

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
