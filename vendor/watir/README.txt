Watir provides a Ruby API to talk to a browser (Internet Explorer).
Many people use Watir to *test* web applications, but it is also excellent
for *specifying* the *intended behaviour* of a web application. Even
for web applications that don't yet exist!

Customers, QA people, testers and programmers can translate user story
acceptance criteria to executable specs based on RSpec and Watir. Take
a look at find_rspecs_home_page.txt (the story) with find_rspecs_home_page.rb
(the associated spec).

One of the great benefits of using Watir with RSpec as opposed to using
Watir 'alone' or Watir with Test::Unit is RSpec's specdoc feature, which
is a great way to see what behaviour is actually implemented and in a working
condition. It also makes the behaviour of your webapp more transparent to
customers. They can say "The specdoc says foo, but I meant bar. We need to talk".

This directory contains a simple example to illustrate this. After you
have installed Ruby, Watir and RSpec, open a shell, go to this directory
and type:

  spec find_rspecs_home_page.rb --format specdoc

Or better:

  spec find_rspecs_home_page.rb --format html > find_rspecs_home_page.html

And upload find_rspecs_home_page.html to your project's web page or intranet.
This will give immediate visibility to the intended behaviour of your web app,
as well as whether it's working as expected or not.

