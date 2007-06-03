require 'rubygems'

if RUBY_PLATFORM =~ /darwin/
  require 'safariwatir'
  Watir::Browser = Watir::Safari
else
  require 'watir'
  Watir::Browser = Watir::IE

  class Watir::Browser
    alias old_initialize initialize
    # Brings the IE to the foreground (provided Win32::Screenshot is installed)
    def initialize
      result = old_initialize
      ::Win32::Screenshot.setForegroundWindow(self.getIE.hwnd) rescue nil
      result
    end
  end
end

class Watir::Browser
  def kill!
    close
  end
  
  alias _old_goto goto
  # Redefinition of Watir's original goto, which gives a better
  # exception message (the URL is in the message)
  def goto(url)
    begin
      _old_goto(url)
    rescue => e
      e.message << "\nURL: #{url}"
      raise e
    end
  end
end
