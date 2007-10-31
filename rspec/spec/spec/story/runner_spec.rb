require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe Runner do
      def dev_null
        io = StringIO.new
        def io.write(str)
          str.to_s.size
        end
        return io
      end
      
      before :each do
        Kernel.stub!(:at_exit)
        @stdout, $stdout = $stdout, dev_null
        @argv = Array.new(ARGV)
        Runner.module_eval { @run_options = @story_runner = nil }
      end
      
      after :each do
        $stdout = @stdout
        ARGV.replace @argv
        Runner.module_eval { @run_options = @story_runner = nil }
      end
      
      it 'should wire up a singleton StoryRunner' do
        Runner.story_runner.should_not be_nil
      end
      
      it 'should set its options based on ARGV' do
        # given
        ARGV << '--dry-run'
        
        # when
        options = Runner.run_options
        
        # then
        ensure_that options.dry_run, is(true)
      end

      it 'should add a documenter to the runner classes if one is specified' do
        # given
        ARGV << "--format" << "specdoc"
        story_runner = mock('story runner')
        scenario_runner = mock('scenario runner')
        
        story_runner.stub!(:add_listener).with(an_instance_of(Reporter::PlainTextReporter))
        scenario_runner.stub!(:add_listener).with(an_instance_of(Reporter::PlainTextReporter))

        Runner::StoryRunner.stub!(:new).and_return(story_runner)
        Runner::ScenarioRunner.stub!(:new).and_return(scenario_runner)
        
        # expect
        World.should_receive(:add_listener).with(an_instance_of(Documenter::PlainTextDocumenter))
        story_runner.should_receive(:add_listener).with(an_instance_of(Documenter::PlainTextDocumenter))
        scenario_runner.should_receive(:add_listener).with(an_instance_of(Documenter::PlainTextDocumenter))
        
        # when
        Runner.story_runner
      end
    end
  end
end
