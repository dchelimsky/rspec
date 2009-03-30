$:.unshift File.join(File.dirname(__FILE__), "/../../lib")

require 'spec/expectations'
require 'tempfile'
require File.dirname(__FILE__) + '/../../spec/ruby_forker'
require File.dirname(__FILE__) + '/matchers/smart_match'


class RspecWorld
  include Spec::Expectations
  include Spec::Matchers
  include RubyForker

  def self.working_dir
    @working_dir ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../tmp"))
  end

  def working_dir
    self.class.working_dir
  end

  def spec(args)
    ruby("#{spec_file} #{args}")
  end

  def cmdline(args)
    ruby("#{cmdline_file} #{args}")
  end

  def create_file(file_name, contents)
    @path = File.join(working_dir, file_name)
    File.open(@path, "w") { |f| f << contents }
  end

  def last_stdout
    @stdout
  end

  def last_stderr
    @stderr
  end

  def last_exit_code
    @exit_code
  end

  # it seems like this, and the last_* methods, could be moved into RubyForker-- is that being used anywhere but the features?
  def ruby(args)
    stderr_file = Tempfile.new('rspec')
    stderr_file.close
    Dir.chdir(working_dir) do
      @stdout = super(args, stderr_file.path)
    end
    @stderr = IO.read(stderr_file.path)
    @exit_code = $?.to_i
  end

  def spec_file
    @spec_command ||= File.expand_path(File.join(working_dir, "/../bin/spec"))
  end

  def cmdline_file
    @cmdline_file ||= File.expand_path(File.join(working_dir, "/../resources/helpers/cmdline.rb"))
  end

end

# Global Setup
FileUtils.mkdir(RspecWorld.working_dir) unless test ?d, RspecWorld.working_dir

After do
  FileUtils.rm_rf RspecWorld.working_dir
  FileUtils.mkdir RspecWorld.working_dir
end

World do
  RspecWorld.new
end
