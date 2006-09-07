= Using Selenium with RSpec =
(Also see ../watir/README.txt)

The files in this directory are examples illustrating how to use Selenium
from RSpec. In addition to Ruby and RSpec you need:

* Install Java 1.4 or later
* Download SeleniumRC 0.8.1 or later (http://www.openqa.org/selenium-rc/)
* Copy selenium-server.jar into this directory.
* Copy selenium.rb into this directory.

After this is installed, open two shells.

In the first one, run:

  java -jar selenium-server.jar

In the second one, run:

  ruby find_rspecs_home_page.rb --format specdoc