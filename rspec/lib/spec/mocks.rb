require 'spec/mocks/methods'
require 'spec/mocks/mock_handler'
require 'spec/mocks/mock'
require 'spec/mocks/argument_expectation'
require 'spec/mocks/message_expectation'
require 'spec/mocks/order_group'
require 'spec/mocks/errors'
require 'spec/mocks/error_generator'
require 'spec/mocks/extensions/object'

module Spec
  # == Mock and Stub Methods and Objects
  # 
  # RSpec will create Mock Objects and Stubs for you at runtime, or attach stub/mock behaviour
  # to any of your real objects (Partial Mock/Stub). Because the underlying implementation
  # for mocks and stubs is the same, you can intermingle mock and stub
  # behaviour in either dynamically generated mocks or your pre-existing classes.
  # There is a semantic difference in how they are created, however,
  # which can help clarify the role it is playing within a given spec.
  #
  # See Spec::Mocks::Methods for documentation about how to take advantage of this feature.
  # 
  # == Mock Objects
  # 
  # Mocks are objects that
  # allow you to set and verify expectations. They are very useful for specifying how the subject of
  # the spec interacts with its collaborators. This approach is widely known as "interaction
  # testing".
  # 
  # Mocks are also very powerful (though less widely understood) as a design tool. As you are
  # driving the implementation of a given class, Mocks provide an amorphous
  # collaborator that can change in behaviour as quickly as you can write an expectation in your
  # spec. This flexibility allows you to design the interface of a collaborator that often
  # does not yet exist. As the shape of the class being specified becomes more clear, so do the
  # requirements for its collaborators - often leading to the discovery of new types that are
  # needed in your system.
  # 
  # Read "Endo-Testing":http://www.mockobjects.com/files/endotesting.pdf for a much
  # more in depth description of this process.
  # 
  # == Stubs
  # 
  # Stubs are objects that allow you to set "stub" responses to
  # messages. As Martin Fowler points out on his site, "Mocks aren't stubs":http://www.martinfowler.com/articles/mocksArentStubs.html. Paraphrasing Fowler's paraphrasing
  # of Gerard Meszaros: Stubs provide canned responses to messages they might receive in a test, while
  # mocks allow you to specify and, subsquently, verify that certain messages should be received during
  # the execution of a test.
  # 
  # == Partial Mocks/Stubs
  # 
  # RSpec also supports partial mocking/stubbing, allowing you to add stub/mock behaviour
  # to instances of your existing classes. This is generally
  # something to be avoided, because changes to the class can have ripple effects on
  # seemingly unrelated specs. When specs fail due to these ripple effects, the fact
  # that some methods are being mocked can make it difficult to understand why a
  # failure is occurring.
  # 
  # That said, partials do allow you to expect and
  # verify interactions with class methods such as +#find+ and +#create+
  # on Ruby on Rails model classes.
  # 
  # == Further Reading
  # 
  # There are many different viewpoints about the meaning of mocks and stubs. If you are interested
  # in learning more, here is some recommended reading:
  # 
  # * Mock Objects: http://www.mockobjects.com/
  # * Endo-Testing: http://www.mockobjects.com/files/endotesting.pdf
  # * Mock Roles, Not Objects: http://www.mockobjects.com/files/mockrolesnotobjects.pdf
  # * Test Double Patterns: http://xunitpatterns.com/Test%20Double%20Patterns.html
  # * Mocks aren't stubs: http://www.martinfowler.com/articles/mocksArentStubs.html
  module Mocks
  end
end