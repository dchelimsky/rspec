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

      # The spec helpers
      m.directory 'spec'
      m.template  'spec_helper.rb', 'spec/spec_helper.rb'
      m.file      'test2spec.erb', 'spec/test2spec.erb'
      m.file      'test2spec_help.rb', 'test/test2spec_help.rb'

      # The rails_spec runner and client scripts
      m.file 'script/rails_spec', 'script/rails_spec', script_options
      m.file 'script/rails_spec_runner', 'script/rails_spec_runner', script_options

    end
  end

  protected
    def banner
      "Usage: #{$0} rspec"
    end

end
