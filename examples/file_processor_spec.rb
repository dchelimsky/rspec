require File.dirname(__FILE__) + '/../lib/spec'
require 'stringio'

# A class that accesses the file system. This class is designed
# in such a way that it doesn't talk directly to the *real* file
# system using File, FileStat etc. Intead it uses a minimal file system
# API that *we* designed.
#
# Using dependency injection allows us to inject a mock filesystem
# that allows us to execute specs and verify how this class works
# without the need for a file system at all.
#
# Further down the road, we might change the constructor to use
# a default file system:
#
#   def initialize(fs=DefaultFileSystem)
#   end
#
# The DefaultFileSystem class would delegate to File, FileStat
# etc methods, and would have its own specs - that *actually*
# access the real file system. We would *not* use mocks at this
# low level.
#
# Note that instead of inventing our own file system API, it may
# be more pragmatic to design your classes (such as FileProcessor)
# around Ruby's stdlib Pathname class. This class *is* a facade for
# many of the low level File system operations, and since it's
# truly OO, it is easier to mock.
#
class FileProcessor  
  # Dependency injection allows us to use a mock file system
  def initialize(fs)
    @fs = fs
  end

  def process(file_path)
    length = @fs.length(file_path)
    raise FileTooShort if length < 32
  end
end

class FileTooShort < StandardError; end

context "A FileProcessor" do
  setup do
    @fs = mock "FileSystem" # The name of the mock is arbitrary and only used in error messages
    @processor = FileProcessor.new(@fs)
  end

  specify "should raise nothing when the file is exactly 32 bytes" do
    @fs.should_receive(:length).with("example.bin").and_return 32
    @processor.process("example.bin")
  end

  specify "should raise an exception when the file length is less than 32 bytes" do
    @fs.should_receive(:length).with("example.bin").and_return 31
    lambda {
      @processor.process("example.bin")
    }.should_raise(FileTooShort)
  end
end