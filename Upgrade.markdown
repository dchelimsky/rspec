# Upgrade to rspec-1.1.99.x

## WARNINGS

* If you use the ruby command to run specs instead of the spec command, you'll
  need to require 'spec/autorun' or they won't run. This won't affect you if
  you use the spec command or the Spec::Rake::SpecTask that ships with RSpec.

* require 'spec/test/unit' to invoke test/unit interop if you're using
  RSpec's core (this is handled implicitly with spec-rails)

* setup/teardown is gone - use before/after instead

  * you can still use setup/teardown if you're using Test::Unit::TestCase as
    the base ExampleGroup class (which is implicit in rspec-rails)
    
* All references to rubygems have been removed from within rspec's code.

  * See Ryan Tomayko's http://gist.github.com/54177 for rationale and
    suggestions on alternative approaches to loading rubygems


## New Matcher DSL

We've added a new DSL for generating custom matchers very simply and cleanly.
We'll still support the simple_matcher method, so never fear if you're using
that, but we recommend that you start developing your new matchers with this
new syntax.

    Spec::Matchers.create do :be_a_multiple_of |smaller|
			match do |bigger|
				bigger % smaller == 0
			end
		end
		
		9.should be_a_multiple_of(3)

See features/matchers/create\_matcher\_.feature for more examples
