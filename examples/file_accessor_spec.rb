require File.dirname(__FILE__) + '/../lib/spec'
require File.dirname(__FILE__) + '/file_accessor'
require 'stringio'

context "A FileAccessor" do
  specify "should open a file and pass it to the processor's process method" do
    accessor = FileAccessor.new
    file = mock "Pathname"
    io_processor = mock "IoProcessor"
    
    io = StringIO.new "whatever"
    file.should_receive(:open).and_yield io
    io_processor.should_receive(:process).with(io)
    
    accessor.open_and_handle_with(file, io_processor)
  end

end