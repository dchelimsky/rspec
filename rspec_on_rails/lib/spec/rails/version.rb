module Spec
  module Rails
    module VERSION #:nodoc:
      unless defined?(REV)
        BUILD_TIME_UTC = 20071124111351
        REV = "$LastChangedRevision$".match(/LastChangedRevision: (\d+)/)[1]
      end
    end
  end
end

# Verify that the plugin has the same revision as RSpec
if Spec::VERSION::BUILD_TIME_UTC != Spec::Rails::VERSION::BUILD_TIME_UTC
  raise <<-EOF

############################################################################
Your RSpec on Rails plugin is incompatible with your installed RSpec.

RSpec          : #{Spec::VERSION::FULL_VERSION}
RSpec on Rails : r#{Spec::Rails::VERSION::REV}

Make sure your RSpec on Rails plugin is compatible with your RSpec gem.
See http://rspec.rubyforge.org/documentation/rails/install.html for details.
############################################################################
EOF
end
