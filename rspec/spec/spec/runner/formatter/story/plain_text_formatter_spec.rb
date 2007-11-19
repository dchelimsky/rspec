require File.dirname(__FILE__) + '/../../../../spec_helper.rb'
require File.dirname(__FILE__) + '/../../../story/rspec_adapter.rb'

module Spec
  module Runner
    module Formatter
      module Story
        describe PlainTextFormatter do
          before :each do
            # given
            @out = String.new
            @reporter = PlainTextFormatter.new(@out)
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
            @out.should include('3 scenarios')
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
            @out.should include('3 scenarios: 3 succeeded')
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
        
          it 'should document a story title and narrative' do
            # when
            @reporter.story_started 'story', 'narrative'
          
            # then
            @out.should contain("Story: story\n\n  narrative")
          end
        
          it 'should document a scenario name' do
            # when
            @reporter.scenario_started 'story', 'scenario'
          
            # then
            @out.should contain("\n\nScenario: scenario")
          end
        
          it 'should document a step by sentence-casing its name' do
            # when
            @reporter.step_succeeded :given, 'a context'
            @reporter.step_succeeded :when, 'an event'
            @reporter.step_succeeded :then, 'an outcome'
          
            # then
            @out.should contain("\n\n  Given a context\n\n  When an event\n\n  Then an outcome")
          end
        
          it 'should document additional givens using And' do
            # when
            @reporter.step_succeeded :given, 'step 1'
            @reporter.step_succeeded :given, 'step 2'
            @reporter.step_succeeded :given, 'step 3'
          
            # then
            @out.should contain("  Given step 1\n  And step 2\n  And step 3")
          end
        
          it 'should document additional events using And' do
            # when
            @reporter.step_succeeded :when, 'step 1'
            @reporter.step_succeeded :when, 'step 2'
            @reporter.step_succeeded :when, 'step 3'
          
            # then
            @out.should contain("  When step 1\n  And step 2\n  And step 3")
          end
        
          it 'should document additional outcomes using And' do
            # when
            @reporter.step_succeeded :then, 'step 1'
            @reporter.step_succeeded :then, 'step 2'
            @reporter.step_succeeded :then, 'step 3'
          
            # then
            @out.should contain("  Then step 1\n  And step 2\n  And step 3")
          end
        
          it 'should document a GivenScenario followed by a Given using And' do
            # when
            @reporter.step_succeeded :'given scenario', 'a scenario'
            @reporter.step_succeeded :given, 'a context'
          
            # then
            @out.should contain("  Given scenario a scenario\n  And a context")
          end
        
          it "should append PENDING for the first pending step" do
            @reporter.scenario_started('','')
            @reporter.step_pending(:given, 'a context')
          
            @out.should contain('Given a context (PENDING)')
          end
        
          it "should append PENDING for pending after already pending" do
            @reporter.scenario_started('','')
            @reporter.step_pending(:given, 'a context')
            @reporter.step_pending(:when, 'I say hey')
          
            @out.should contain('When I say hey (PENDING)')
          end
        
          it "should append FAILED for the first failiure" do
            @reporter.scenario_started('','')
            @reporter.step_failed(:given, 'a context')
          
            @out.should contain('Given a context (FAILED)')
          end
        
          it "should append SKIPPED for the second failiure" do
            @reporter.scenario_started('','')
            @reporter.step_failed(:given, 'a context')
            @reporter.step_failed(:when, 'I say hey')
          
            @out.should contain('When I say hey (SKIPPED)')
          end
        
          it "should append SKIPPED for the a failiure after PENDING" do
            @reporter.scenario_started('','')
            @reporter.step_pending(:given, 'a context')
            @reporter.step_failed(:when, 'I say hey')
          
            @out.should contain('When I say hey (SKIPPED)')
          end
        
          it 'should print some white space after each story' do
            # when
            @reporter.story_ended 'title', 'narrative'
          
            # then
            @out.should contain("\n\n")
          end
        end
      end
    end
  end
end
