require File.dirname(__FILE__) + '/../story_helper'

module Spec
  module Story
    module Documenter
      describe PlainTextDocumenter do
        before :each do
          # given
          @out = String.new
          @documenter = PlainTextDocumenter.new(@out)
        end
        
        it 'should document a story title and narrative' do
          # when
          @documenter.story_started 'story', 'narrative'
          
          # then
          @out.should contain("Story: story\nnarrative\n")
        end
        
        it 'should document a scenario name' do
          # when
          @documenter.scenario_started 'story', 'scenario'
          
          # then
          @out.should contain("\nScenario: scenario\n")
        end
        
        it 'should document a step by sentence-casing its name' do
          # when
          @documenter.found_step :given, 'a context'
          @documenter.found_step :when, 'an event'
          @documenter.found_step :then, 'an outcome'
          
          # then
          @out.should contain("  Given a context\n\n  When an event\n\n  Then an outcome\n")
        end
        
        it 'should document additional givens using And' do
          # when
          @documenter.found_step :given, 'step 1'
          @documenter.found_step :given, 'step 2'
          @documenter.found_step :given, 'step 3'
          
          # then
          @out.should contain("  Given step 1\n  And step 2\n  And step 3")
        end
        
        it 'should document additional events using And' do
          # when
          @documenter.found_step :when, 'step 1'
          @documenter.found_step :when, 'step 2'
          @documenter.found_step :when, 'step 3'
          
          # then
          @out.should contain("  When step 1\n  And step 2\n  And step 3")
        end
        
        it 'should document additional outcomes using And' do
          # when
          @documenter.found_step :then, 'step 1'
          @documenter.found_step :then, 'step 2'
          @documenter.found_step :then, 'step 3'
          
          # then
          @out.should contain("  Then step 1\n  And step 2\n  And step 3")
        end
        
        it 'should document a GivenScenario followed by a Given using And' do
          # when
          @documenter.found_step :'given scenario', 'a scenario'
          @documenter.found_step :given, 'a context'
          
          # then
          @out.should contain("  Given scenario a scenario\n  And a context")
        end
        
        it 'should print some white space after each story' do
          # when
          @documenter.story_ended 'title', 'narrative'
          
          # then
          @out.should contain("\n\n")
        end
        
        it 'should ignore uninteresting calls' do
          # when
          @documenter.run_started(42)
          @documenter.run_ended
          @documenter.scenario_succeeded('story', 'scenario')
          @documenter.scenario_failed('story', 'scenario', RuntimeError.new)
          @documenter.scenario_pending('story', 'scenario', 'todo')
          
          # then
          @out.should be_empty
        end
      end
    end
  end
end
