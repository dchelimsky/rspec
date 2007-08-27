= Using Selenium with spec/ui =

The files in this directory are examples illustrating how to use Selenium
with spec/ui. Prerequisites:

* Install Java 1.4 or later
* Download SeleniumRC 0.9.0 or later (http://www.openqa.org/selenium-rc/)
* Copy selenium-server.jar into the spec directory.
* Copy selenium.rb into the spec directory.

After this is installed, open two shells in this directory.

In the first one, run:

  java -jar spec/selenium-server.jar

In the second one, run:

  rake spec:selenium
  
= Note for OS X users =

== Firefox 2.0.0.1 ==
If you experience that the selenium server is just hanging, read this:
http://forums.openqa.org/message.jspa?messageID=16541

You may have better luck with one of the snapshot jars found under
http://maven.openqa.org/org/openqa/selenium/server/selenium-server

== Safari ==
You may have to set up Safari's proxy settings manually:
http://forums.openqa.org/thread.jspa?messageID=20570&#20570
