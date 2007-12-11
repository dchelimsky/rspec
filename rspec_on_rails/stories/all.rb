require File.join(File.dirname(__FILE__), *%w[helper])
require File.join(File.dirname(__FILE__), *%w[steps people])

with_steps_for :people do
  run File.join(File.dirname(__FILE__), *%w[transactions_should_rollback]), :type => RailsStory
end