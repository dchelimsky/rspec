require 'spec/adapters/ruby_engine/mri'
require 'spec/adapters/ruby_engine/rubinius'

module Spec
  module Adapters
    module RubyEngine
    
      ENGINES = {
        'mri' => MRI.new,
        'rbx' => Rubinius.new
      }
    
      def self.engine
        if const_defined?(:RUBY_ENGINE)
          return RUBY_ENGINE
        else
          return 'mri'
        end
      end
    
      def self.adapter
        return ENGINES[engine]
      end
    end
  end
end