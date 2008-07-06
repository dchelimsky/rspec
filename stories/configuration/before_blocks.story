Story: before suite
	As a developer using rspec
	I want to declare a one-time global set up
	
	Scenario: one time set-up
	
		Given the file ../resources/spec/before_blocks_example.rb
		
    When I run it with the ruby interpreter

		Then the stdout should match "3 examples, 0 failures"