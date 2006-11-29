require 'rubygems'
require 'spec'
require 'watir'
require 'fileutils'
require File.dirname(__FILE__) + '/../web_test_html_formatter_win_helper'

# Comment out to enable ActiveRecord fixtures
#require 'active_record'
#require 'active_record/fixtures'
#config = YAML::load_file(File.dirname(__FILE__) + '/database.yml')
#$fixture_path = File.dirname(__FILE__) + '/fixtures'
#ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
#ActiveRecord::Base.establish_connection(config['db'])

class RSpecWatir
  @@img_dir = File.dirname(__FILE__) + '/report/images'
  FileUtils.mkdir_p(@@img_dir) unless File.exist?(@@img_dir)

  include WebTestHtmlFormatterWinHelper
  @@n = 1
  
  def setup
    #Fixtures.create_fixtures($fixture_path, @@fixtures)
    @browser = Watir::IE.new
  end

  def teardown
    save_screenshot(@@img_dir, @@n)
    save_source(@@img_dir, @@n, @browser.html)
    @@n += 1
    @browser.close
  end
  
  #def self.fixtures(*testdata)
  #  @@fixtures = testdata
  #end
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

# Extensions to Watir to make it play nicer with RSpec
module Watir
  class IE
    # @browser.should_contain("bla bla")
    # @browser.should_not_contain("bla bla")
    alias_method :contain?, :contains_text
  end
end