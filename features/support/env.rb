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
    @working_dir ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../tmp/cucumber-generated-files"))
  end

  def self.spec_command
    @spec_command ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../bin/spec"))
  end

  def self.cmdline_file
    @cmdline_file ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../resources/helpers/cmdline.rb"))
  end
  def self.rspec_lib
    @rspec_lib ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../lib"))
  end

  def working_dir
    self.class.working_dir
  end

  def spec_command
    self.class.spec_command
  end

  def cmdline_file
    self.class.cmdline_file
  end

  def rspec_lib
    self.class.rspec_lib
  end

  def spec(args)
    ruby("#{spec_command} #{args}")
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
      @stdout = super("-I #{rspec_lib} #{args}", stderr_file.path)
    end
    @stderr = IO.read(stderr_file.path)
    @exit_code = $?.to_i
  end


end

Before do
  FileUtils.rm_rf RspecWorld.working_dir if test ?d, RspecWorld.working_dir
  FileUtils.mkdir RspecWorld.working_dir
end

World do
  RspecWorld.new
end
