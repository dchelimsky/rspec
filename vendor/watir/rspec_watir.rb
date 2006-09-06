require 'rubygems'
require 'spec'
require 'watir'

class RSpecWatir
  def setup
    @browser = Watir::IE.new
  end

  def teardown
    @browser.close
  end
end

module Spec
  module Runner
    class Context
      def before_context_eval
        inherit RSpecWatir
      end
    end
  end
end
