class NaughtyController < ApplicationController
  def says_hello_to_aslak
    Stubbed.hello(:aslak)
  end
  
  def raises_regular_error
    raise "Naughty!"
  end
end