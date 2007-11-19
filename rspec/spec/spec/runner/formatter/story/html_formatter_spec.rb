require File.dirname(__FILE__) + '/../../../../spec_helper.rb'
require File.dirname(__FILE__) + '/../../../story/rspec_adapter.rb'

module Spec
  module Runner
    module Formatter
      module Story
        describe HtmlFormatter do
          before :each do
            @out = StringIO.new
            @options = mock('options')
            @reporter = HtmlFormatter.new(@options, @out)
          end
          
          it "should just be poked at" do
            @reporter.run_started(1)
            @reporter.story_started('story_title', 'narrative')

            @reporter.scenario_started('story_title', 'succeeded_scenario_name')
            @reporter.step_succeeded('given', 'succeded_step', 'one', 'two')
            @reporter.scenario_succeeded('story_title', 'succeeded_scenario_name')

            @reporter.scenario_started('story_title', 'pending_scenario_name')
            @reporter.step_pending('when', 'pending_step', 'un', 'deux')
            @reporter.scenario_pending('story_title', 'pending_scenario_name', 'not done')

            @reporter.scenario_started('story_title', 'failed_scenario_name')
            @reporter.step_failed('then', 'failed_step', 'en', 'to')
            @reporter.scenario_failed('story_title', 'failed_scenario_name', NameError.new('sup'))
            
            @reporter.story_ended('story_title', 'narrative')
            @reporter.run_ended
          end
        end
      end
    end
  end
end