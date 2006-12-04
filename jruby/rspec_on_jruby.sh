#!/bin/bash
cd `dirname $0`/jruby
ant jar
export JRUBY_HOME=`pwd`
export PATH=$PATH:$JRUBY_HOME/bin
$JRUBY_HOME/bin/gem install diff-lcs --no-rdoc --no-ri
$JRUBY_HOME/bin/jruby -I../../../lib ../../../bin/spec ../../../spec
