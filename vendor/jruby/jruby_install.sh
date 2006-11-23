#!/bin/bash
cd `dirname $0`
if [ -d jruby_code ]
then
  echo "Checking out jruby"
  svn co svn://svn.codehaus.org/jruby/trunk jruby_code
else
  echo "Updating out jruby"
  svn up
fi
cd jruby_code/jruby
ant jar
export JRUBY_HOME=`pwd`
export PATH=$PATH:$JRUBY_HOME/bin
$JRUBY_HOME/bin/gem install diff-lcs --no-rdoc --no-ri
$JRUBY_HOME/bin/jruby -I../../../../lib ../../../../bin/spec ../../../../spec
