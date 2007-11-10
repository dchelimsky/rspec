require File.dirname(__FILE__) + '/../story_helper'

module Spec
  module Story
    module Reporter
      describe PlainTextReporter do
        before :each do
          # given
          @out = String.new
          @reporter = PlainTextReporter.new(@out)
        end
        
        it 'should summarize the number of scenarios when the run ends' do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario2')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario3')
          @reporter.run_ended
          
          # then
          @out.should contain('3 scenarios')
        end
        
        it 'should summarize the number of successful scenarios when the run ends' do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario2')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario3')
          @reporter.run_ended
          
          # then
          @out.should contain('3 scenarios: 3 succeeded')
        end
        
        it 'should summarize the number of failed scenarios when the run ends' do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_failed('story', 'scenario2', exception_from { raise RuntimeError, 'oops' })
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_failed('story', 'scenario3', exception_from { raise RuntimeError, 'oops' })
          @reporter.run_ended
          
          # then
          @out.should contain("3 scenarios: 1 succeeded, 2 failed")
        end
        
        it 'should summarize the number of pending scenarios when the run ends' do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_pending('story', 'scenario2', 'message')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_pending('story', 'scenario3', 'message')
          @reporter.run_ended
          
          # then
          @out.should contain("3 scenarios: 1 succeeded, 0 failed, 2 pending")
        end
        
        it "should only count the first failure in one scenario" do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_failed('story', 'scenario2', exception_from { raise RuntimeError, 'oops' })
          @reporter.scenario_failed('story', 'scenario2', exception_from { raise RuntimeError, 'oops again' })
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_failed('story', 'scenario3', exception_from { raise RuntimeError, 'oops' })
          @reporter.run_ended
          
          # then
          @out.should contain("3 scenarios: 1 succeeded, 2 failed")
        end
        
        it "should only count the first pending in one scenario" do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_pending('story', 'scenario2', 'because ...')
          @reporter.scenario_pending('story', 'scenario2', 'because ...')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_pending('story', 'scenario3', 'because ...')
          @reporter.run_ended
          
          # then
          @out.should contain("3 scenarios: 1 succeeded, 0 failed, 2 pending")
        end
        
        it "should only count a failure before the first pending in one scenario" do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_pending('story', 'scenario2', exception_from { raise RuntimeError, 'oops' })
          @reporter.scenario_failed('story', 'scenario2', exception_from { raise RuntimeError, 'oops again' })
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_failed('story', 'scenario3', exception_from { raise RuntimeError, 'oops' })
          @reporter.run_ended
          
          # then
          @out.should contain("3 scenarios: 1 succeeded, 1 failed, 1 pending")
        end
        
        it 'should produce details of the first failure each failed scenario when the run ends' do
          # when
          @reporter.run_started(3)
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_succeeded('story', 'scenario1')
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_failed('story', 'scenario2', exception_from { raise RuntimeError, 'oops2' })
          @reporter.scenario_failed('story', 'scenario2', exception_from { raise RuntimeError, 'oops2 - this one should not appear' })
          @reporter.scenario_started(nil, nil)
          @reporter.scenario_failed('story', 'scenario3', exception_from { raise RuntimeError, 'oops3' })
          @reporter.run_ended
          
          # then
          @out.should contain("FAILURES:\n")
          @out.should contain("1) story (scenario2) FAILED")
          @out.should contain("RuntimeError: oops2")
          @out.should_not contain("RuntimeError: oops2 - this one should not appear")
          @out.should contain("2) story (scenario3) FAILED")
          @out.should contain("RuntimeError: oops3")
        end
        
        it 'should produce details of each pending step when the run ends' do
          # when
          @reporter.run_started(2)
          @reporter.scenario_pending('story', 'scenario2', 'todo2')
          @reporter.scenario_pending('story', 'scenario3', 'todo3')
          @reporter.run_ended
          
          # then
          @out.should contain("Pending Steps:\n")
          @out.should contain("1) story (scenario2): todo2")
          @out.should contain("2) story (scenario3): todo3")
        end
        
        it 'should ignore uninteresting callbacks' do
          # when
          @reporter.story_started 'story', 'narrative'
          @reporter.scenario_started 'story', 'scenario'
          
          # then
          @out.should be_empty
        end
      end
    end
  end
end
