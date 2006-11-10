svn co svn://svn.codehaus.org/jruby/trunk/jruby jruby
cd jruby
ant jar
export JRUBY_HOME=`pwd`
export PATH=$PATH:$JRUBY_HOME/bin
cd ..
$JRUBY_HOME/bin/gem install diff-lcs
jruby -I../../lib ../../bin/spec ../../spec
