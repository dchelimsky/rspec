require "test/unit"
require "test/unit/testresult"
require "test/unit/ui/testrunnermediator"

require 'spec/extensions/test/unit/example_group'
require 'spec/extensions/test/unit/example_suite'
require 'spec/extensions/test/unit/autorunner'
require 'spec/extensions/test/unit/rspectestresult'
require 'spec/extensions/test/unit/ui/testrunnermediator'
require 'spec/extensions/test/unit/ui/console/testrunner'

Spec::Example::ExampleGroupFactory.register(
  :default, Test::Unit::TestCase::ExampleGroup
)