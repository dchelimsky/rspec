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
