Here are the things we'd like to do. If you're looking to help out, read on.
We have put them into several categories to trick\^H\^H\^H\^H\^Hencourage you into
helping.

**RULE NUMBER 1**: It's ok if you break amp. Go ahead and accidentally remove
every file, commit, and then push it. We're not worried; we have immutable history
and multiple copies of the repo and advanced knowledge of `amp/hg revert`. You
can't hurt us.

# Maintenance

## Multitude of Tests
Tests. We need them. More and more of them. We want every command to be tested
(at least generally), although if every option were also tested that'd be
superb.

# Expansion

## Extensions
Start porting over useful extensions from Mercurial, Git, etc. 'Nuff said.

# Documentation

## User guide
We need a guide that will tell new users how to install and use amp. It should
explain what to do if you get a bug. Add this into the help system so it can be
CLI-accessible and browser-accessible. Add it to the man pages as well (see
tasks/man.rake).

## Inline documentation
Go through to big ugly methods (or any method, no matter how dumb) and add
inline comments explaining what the method does and HOW IT INTERACTS WITH
THE REST OF THE SYSTEM. Comments should be formatted according to YARD
documentation format (http://yardoc.org). Key questions to ask and answer:
Who (uses this), What (is passed in), Why (this exists), and How (this
interacts with the rest of the system).

## Wiki
We need to expand our BitBucket wiki so that it is more appeasing and useful.

