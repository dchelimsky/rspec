Spec::Distributed
=================

Spec::Distributed makes it possible to run specs in a distributed fashion, in parallel 
on different slaves. It's something you can consider using when you have a *very* slow 
RSpec suite (for example using Spec::Ui).

== How it works ==
When you use Spec::Distributed you will have one master process, and two or more slave processes.
The master distributes behaviours (describe blocks) to slaves via DRb.

== Example ==
Note: If you want to run the examples from an svn checkout, replace 'spec' with
'ruby -Ilib ../rspec/bin/spec'

Start two slave runners:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::SlaveRunner:druby://localhost:8991

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::SlaveRunner:druby://localhost:8992

Start master runner:
  
  spec examples/*_spec.rb --require spec/distributed --runner  Spec::Distributed::MasterRunner:druby://localhost:8991,druby://localhost:8992
  
== Using Subversion ==
It is very important that the slaves and the master have identical sources. If the master is run from
a Subversion working copy, it will automatically detect the local revision and tell the slaves to 
update accordingly prior to running the behaviours.

== Spec::Ui and formatters ==
Slaves should be using Spec::Ui::SlaveScreenshotFormatter and the master should be using
Spec::Ui::MasterScreenshotFormatter. In order to get a report without dead links to screenshot
PNGs and browser HTML snapshots, all formatters must write to the same location.
Since slaves and masters typically will run on different machines, you might want to set
up a shared location using Samba or NTFS shares.

== Using Rinda for Autodiscovery ==
The slave class Spec::Distributed::RindaSlaveRunner will be used in
conjunction with Spec::Distributed::RindaMasterRunner so that masters
and slaves may auto-discover each other.

To use the Rinda Runners start one more slave runner:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaSlaveRunner

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaSlaveRunner

Then start the master runner:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::MasterRunner

Note the slaves and masters don't need prior knowledge of each other.

The slave runner will attempt to contact any RingServer on the local
network. If none exists it will start one. Subsequent slaves will use
this RingServer to publish themselves.

When the master starts, it will contact the RingServer and query for
all available slave servers. Then the master will create a thread for
each available slave.

When the master uses a slave, it removes it from the pool of available
slaves. The slave will re-publish itself back into the tuplespace
after running the spec.

== Partitioning the Tuplespace ==
With no additional configuration options passed to either the Master
or Slave runners the RindaMasterRunner will use all available slaves.

Suppose you have more than one set of masters and slaves running at
the same time. For example, Bob and Joe want to run a pool of slaves,
but don't want to share them with each other. One solution would be to
run seperate RingServers on different ports, but that defeats the
purpose of auto-discovery.

Both Spec::Distributed::RindaSlaveRunner and
Spec::Distributed::RindaMasterRunner take an optional list of
"tuplespace selectors", which are a comma seperated list of strings.

For example, to Joe might start his slaves like this:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaSlaveRunner:Joe

Joe would then start his RindaMasterRunner as so:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaMasterRunner:Joe
  
This master runner will only find slaves that have been configured
with the same arguments.

Joe may also have several builds he want to test, so he might setup
two pools of slave servers to run:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaSlaveRunner:Joe,1
  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaSlaveRunner:Joe,2

Then Joe could create two master runners, one for each build:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaMasterRunner:Joe,1
  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaMasterRunner:Joe,2

Again, the master runners would only find slaves that have been
configured with the same parameters.

== Wildcarding the Tuplespace ==

To continue with the example, lets suppose that Bob knows that Joe is
out to lunch, and wants to use some of his slave runners while he
gone. Bob has his own slave runners configured similarly to Joe's:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaSlaveRunner:Bob,1
  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaSlaveRunner:Bob,2

So Bob wants to use all of Joe's (and everyone's) build #2 slave
servers. So he starts his master runner and passes in a wild-card in
the first position:

  spec examples/*_spec.rb --require spec/distributed --runner Spec::Distributed::RindaMasterRunner:*,2

This will select all the slave runners that were configured with two
arguments, and the value of the second argument is 2.

Which is to say, slaves will only be selected if the number of
"tuplespace selectors" matches, and all of the values match or are a
wildcard (*). Zero selectors will only match slaves started with zero
selectors, a single wild-card will only match slaves started with one
selector.

This can be useful for partitioning seperate builds, platforms, dev
groups etc.

