require 'rubygems'
require 'spec'
require 'fileutils'
require File.dirname(__FILE__) + '/../web_test_html_formatter_helper'

# Comment out to enable ActiveRecord fixtures
#require 'active_record'
#require 'active_record/fixtures'
#config = YAML::load_file(File.dirname(__FILE__) + '/database.yml')
#$fixture_path = File.dirname(__FILE__) + '/fixtures'
#ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
#ActiveRecord::Base.establish_connection(config['db'])

class RSpecWatir
  include WebTestHtmlFormatterHelper

  @@img_dir = File.dirname(__FILE__) + '/report/images'
  FileUtils.mkdir_p(@@img_dir) unless File.exist?(@@img_dir)
  @@n = 1
  
  def setup
    #Fixtures.create_fixtures($fixture_path, @@fixtures)
    @browser = Watir::Browser.new
  end

  def teardown
    save_screenshots(@@img_dir, @@n)
    save_source(@@img_dir, @@n, @browser.html)
    @@n += 1
    @browser.close unless RUBY_PLATFORM =~ /darwin/
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
