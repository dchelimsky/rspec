module SortedFind
  
  def find(*paths) # :yield: path
    paths.collect!{|d| d.dup}
    while file = paths.shift
      catch(:prune) do
        yield file.dup.taint
        next unless File.exist? file
        begin
          if File.lstat(file).directory? then
            d = Dir.open(file)
            begin
              for f in d.sort.reverse
                next if f == "." or f == ".."
                if File::ALT_SEPARATOR and file =~ /^(?:[\/\\]|[A-Za-z]:[\/\\]?)$/ then
                  f = file + f
                elsif file == "/" then
                  f = "/" + f
                else
                  f = File.join(file, f)
                end
                paths.unshift f.untaint
              end
            ensure
              d.close
            end
          end
        rescue Errno::ENOENT, Errno::EACCES
        end
      end
    end
  end
  
  def prune
    throw :prune
  end
  
  module_function :find, :prune
  
end
