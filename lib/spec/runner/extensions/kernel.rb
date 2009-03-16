module Kernel
  
   unless respond_to?(:debugger)
    # Starts a debugging session if ruby-debug has been loaded, use the -u/--debugger option to  load it
    def debugger(steps=1)
      # If not then just comment and proceed
      $stderr.puts "debugger statement ignored, use -u or --debugger option on rspec to enable debugging"
    end
  end
end
