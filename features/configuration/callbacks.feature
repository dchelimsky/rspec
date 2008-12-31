Feature: callbacks

  before and after callbacks are called in the following order:
    before suite
    before all
    before each
    after each
    after all
    after suite

  Scenario: called in order
  	Given the file ../../resources/spec/callbacks_example.rb
    When I run it with the ruby interpreter
  	Then the stdout should match /before suite\nbefore all\nbefore each\nafter each\n\.after all\n.*after suite/m
