require File.dirname(__FILE__) + '/webapp_helper'
require 'rubygems'

if RUBY_PLATFORM =~ /darwin/
  require 'safariwatir'
  Watir::Browser = Watir::Safari
else
  require 'watir'
  Watir::Browser = Watir::IE
end

class Watir::Browser
  def kill!
    close
  end
end
