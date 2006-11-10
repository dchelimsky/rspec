svn co svn://svn.codehaus.org/jruby/branches/enebo jruby
cd jruby
ant jar
export JRUBY_HOME=`pwd`
export PATH=$PATH:$JRUBY_HOME/bin
$JRUBY_HOME/bin/jruby -I../../../lib ../../../bin/spec ../../../spec
$JRUBY_HOME/bin/gem install diff-lcs
