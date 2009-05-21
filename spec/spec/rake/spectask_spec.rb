require File.dirname(__FILE__) + '/../../spec_helper.rb'
require File.dirname(__FILE__) + '/../../../lib/spec/rake/spectask.rb'

module Spec
  module Rake

    describe SpecTask do

      class MockTask

        def self.last_instance
          @last_instance
        end

        def self.last_instance=(block)
          @last_instance = block
        end

        def self.last_cmd
          @last_cmd
        end

        def self.last_cmd=(string)
          @last_cmd = string
        end
        
        def self.tasks
          @tasks ||= {}
        end
        
        def self.reset_tasks
          @tasks = {}
        end
        
        def self.task(name)
          tasks[name]
        end
        
        def self.register_task(name, block)
          tasks[name] = block
        end

        def initialize(name, &block)
          MockTask.register_task(name, block)
          MockTask.last_instance = block
        end
        
        def self.create_task(name, &block)
          new(name, &block)
        end
      end

      class SpecTask
        def task(name, &block)
          MockTask.create_task(name, &block)
        end

        def system(cmd)
          MockTask.last_cmd = cmd
          true
        end

        def default_ruby_path
          RUBY
        end
      end
      
      before(:each) do
        MockTask.reset_tasks
      end

      it "should execute rakes ruby path by default" do
        @it = SpecTask.new
        MockTask.last_instance.call
        MockTask.last_cmd.should match(/^#{@it.default_ruby_path} /)
      end

      it "should allow ruby_cmd to be overriden" do
        lambda {SpecTask.new {|t| t.ruby_cmd = "path_to_multiruby"}}.should_not raise_error
      end

      # A reminder for David C to look at this when he changes the default not to fork
      it "should run execute the command with system if ruby_cmd is specificed" do
        @it = SpecTask.new {|t| t.ruby_cmd = "path_to_multiruby"}
        @it.should_receive(:system).and_return(true)
        MockTask.last_instance.call
      end

      it "should execute the ruby_cmd path if specified" do
        @it = SpecTask.new {|t| t.ruby_cmd = "path_to_multiruby"}
        MockTask.last_instance.call
        MockTask.last_cmd.should match(/^path_to_multiruby /)
      end
      
      it "should produce a deprecation warning if the out option is used" do
        @it = SpecTask.new {|t| t.out = "somewhere_over_the_rainbow"}
        STDERR.should_receive(:puts).with("The Spec::Rake::SpecTask#out attribute is DEPRECATED and will be removed in a future version. Use --format FORMAT:WHERE instead.")
        MockTask.last_instance.call
      end
      
      it "should produce an error if failure_message is set and the command fails" do
        @it = SpecTask.new {|t| t.failure_message = "oops"; t.fail_on_error = false}
        STDERR.should_receive(:puts).with("oops")
        @it.stub(:system).and_return(false)
        MockTask.last_instance.call
      end
      
      it "should produce raise an error if fail_on_error is set and the command fails" do
        @it = SpecTask.new
        @it.stub(:system).and_return(false)
        lambda {MockTask.last_instance.call}.should raise_error
      end
      
      it "should produce not raise an error if fail_on_error is not set and the command fails" do
        @it = SpecTask.new {|t| t.fail_on_error = false}
        @it.stub(:system).and_return(false)
        lambda {MockTask.last_instance.call}.should_not raise_error
      end
      
      context "with the rspec option" do
        
        it "should create a clobber_rcov task" do
          MockTask.stub!(:create_task)
          MockTask.should_receive(:create_task).with(:clobber_rcov)
          @it = SpecTask.new(:rcov) {|t| t.rcov = true}
        end

        it "should setup the clobber_rcov task to remove the rcov directory" do
          @it = SpecTask.new(:rcov) {|t| t.rcov = true; t.rcov_dir = "path_to_rcov_directory"}
          @it.should_receive(:rm_r).with("path_to_rcov_directory")
          MockTask.task(:clobber_rcov).call
        end

        it "should make the clobber task depend on clobber_rcov" do
          MockTask.stub!(:create_task)
          MockTask.should_receive(:create_task).with(:clobber => [:clobber_rcov])
          @it = SpecTask.new(:rcov) {|t| t.rcov = true}
        end

        it "should make the rcov task depend on clobber_rcov" do
          MockTask.stub!(:create_task)
          MockTask.should_receive(:create_task).with(:rcov => :clobber_rcov)
          @it = SpecTask.new(:rcov) {|t| t.rcov = true}
        end
      end
    end
  end
end