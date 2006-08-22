# This LOAD_PATH munging is not necessary if you have installed RSpec via Ruybygems.
# It's only done here in order to make sure we run against the RSpec SVN.
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../lib')

task :pre_commit => [:clobber_sqlite, :migrate, :generate_rspec, :spec]

task :clobber_sqlite do
  rm_rf 'db/*.db'
end

task :generate_rspec do
  `ruby script/generate rspec --force`
  raise "Failed to generate rspec environment" if $? != 0
end

# Monkey patch SpecTask to include the RSpec lib above us. We're no longer
# munging the $LOAD_PATH (http://rubyforge.org/tracker/?func=detail&atid=3149&aid=4896&group_id=797)
require 'spec/rake/spectask'

module Spec
  module Rake
    class SpecTask < ::Rake::TaskLib
      alias_method :initialize_old, :initialize

      def initialize(name)
        initialize_old(name) do |t|
          yield self
          t.libs << RAILS_ROOT + '/../../lib'
        end
      end
    end
  end
end

