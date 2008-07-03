= RSpec

* http://rspec.info
* http://rspec.info/rdoc/
* http://github.com/dchelimsky/rspec-rails/wikis
* mailto:rspec-devel@rubyforge.org

== DESCRIPTION:

RSpec is a Behaviour Driven Development framework with tools to express User
Stories with Executable Scenarios and Executable Examples at the code level.

== FEATURES:

* Spec::Story provides a framework for expressing User Stories and Scenarios
* Spec::Example provides a framework for expressing Isolated Examples
* Spec::Matchers provides Expression Matchers for use with Spec::Expectations and Spec::Mocks.

== SYNOPSIS:

Spec::Expectations supports setting expectations on your objects so you
can do things like:

  result.should equal(expected_result)
  
Spec::Mocks supports creating Mock Objects, Stubs, and adding Mock/Stub
behaviour to your existing objects.

== INSTALL:

  [sudo] gem install rspec

 or

  git clone git://github.com/dchelimsky/rspec.git
  cd rspec
  rake gem
  rake install_gem

== LICENSE:

(The MIT License)

Copyright (c) 2005-2008 The RSpec Development Team

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
