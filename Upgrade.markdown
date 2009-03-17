# Upgrade to rspec-1.2.1 (in dev)

## What's Changed

* After minor public outcry and confusion, we restored necessary references to
  rubygems in rspec. They only appear if you are running the --diff option (in
  order to load diff-lcs) or if you're running rspec's own specs. If you find
  yourself in either situation, and don't use rubygems, you can keep it from
  being loaded by setting the ``I_DONT_USE_RUBY_GEMS`` environment variable.
  I'm serious.
  
## What's new

### The new matcher DSL works with test/unit (without the rest of rspec)

We'll be separating this out to its own gem for rspec 2.0, but for now, just install
rspec >= 1.2.1 and add the following to your ``test_helper`` file:
  
    require 'spec/expectations'
    class Test::Unit::TestCase
      include Spec::Matchers
    end
    
This will add ``should()`` and ``should_not()`` to your objects, make all of
rspec's built-in matchers available to your tests, INCLUDING rspec's DSL for
creating matchers (see below, under Upgrade to rspec-1.2.0)

# Upgrade to rspec-1.2.0

## What's Changed

### WARNINGS

* If you use the ruby command to run specs instead of the spec command, you'll
  need to require 'spec/autorun' or they won't run. This won't affect you if
  you use the spec command or the Spec::Rake::SpecTask that ships with RSpec.

* require 'spec/test/unit' to invoke test/unit interop if you're using
  RSpec's core (this is handled implicitly with spec-rails)

* setup and teardown are gone - use before and after instead

  * you can still use setup and teardown if you're using
    Test::Unit::TestCase as the base ExampleGroup class (which is implicit
    in rspec-rails)

* The matcher protocol has been improved. The old protocol is still supported,
  but we added support for two new methods that speak a bit more clearly:
  
  * ``failure_message          => failure_message_for_should``
  * ``negative_failure_message => failure_message_for_should_not``

* All references to rubygems have been removed from within rspec's code.

  * See http://gist.github.com/54177 for rationale and suggestions on
    alternative approaches to loading rubygems

## What's New

### Ruby 1.9

RSpec now works with Ruby 1.9.1. See
[http://wiki.github.com/dchelimsky/rspec/ruby-191](http://wiki.github.com/dchelimsky/rspec/ruby-191)
for useful information.

### Improved heckle integration

RSpec works with heckle again [1]! Gotta use heckle >= 1.4.2 for this to work
though, and it only works with ruby-1.8.6 and 1.8.7 (heckle doesn't support
1.9.1 yet).

    [sudo] gem install heckle --version ">=1.4.2"
    spec spec/game/mastermind.rb --heckle Game::Mastermind

### New Matcher DSL

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

See ``features/matchers/create_matcher.feature`` for more examples
