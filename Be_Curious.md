# Be Curious

A person in a suit walks in to the "war room" and blurts out, "I have $20 for whoever can guess when the next outage is going to be".  

"In a little over 11 hours after we get the system back up", I reply, not realizing:
* who the person was 
* that he was extremely exhausted/frustrated at this point 
* that he was not seriously asking the question (it was rhetorical/cathartic)

This was how I met Alan Kocsi, the CTO of GE Healthcare.

## Backstory
GE went through some significant changes and, in many ways, improvements throughout its existance.  GE Healthcare had the worlds largest ERP system ran by Veritas, Oracle, and Sun (VOS) - well, that moniker was given by the account teams, anyhow.
They were also going through a transition to "off shore development and maintenance" while upgrading the ERP system to the best UNIX hardware platform Sun Microsystems had at the time (the [Sun Fire 15k](https://en.wikipedia.org/wiki/Sun_Fire_15K)) and Hitachi Data Systems storage array.  The migration was an "all hands on deck" type of affair with aggressive deadlines and fairly lofty goals.  Amazingly, GE pulled off what seemed possibly unattainable.  They migrated their ERP system to this new platform and things were going well.  Until they weren't.

## The incident
A few weeks post migration, the system started having issues.  It would hang up and become unresponsive, and then sometimes recover, and sometimes not (requiring a complete cold boot of the environment - which, back then took over an hour).
They engaged their vendors to find out what was going on... and made some changes, which helped some, but not enough.  The account team at Sun created a "hail Mary" plan which was to bring "subject matter experts" in to explore EVERY possible configuration, design, implementation decision and then make recommendations and ultimately help deploy the changes.

Initially there were changes made: 
* network stack - introduced VLAN tagging (not a popular option back in that day) to separate all the traffic better for easier analysis), 
* storage layout - modified the HDS RAID layout based on workload
* added more capacity - more *memory* and CPU were added to the system (even though, by all accounts, there was ample capacity)

Unfortunately we did not have the time/luxury of implementing these changes independently of each other, and with time to assess the true impact of each of the changes.  As such, it was hard to really pinpoint exactly what change might be causing a particular result.  
After this change, the system was seemingly going down daily.  And the whole technical team was moved to an old "break room" and they brought in large monitors to display dashboards, and several phones and speaker phones.  The VOS team was invoked and there was a special login code provided when we called support.  

I don't recall at which point Kocsi walked in to the war room and leveled the challenge to the room, ironically or rhetorically - but it felt like it may have been a few weeks after the real problem had began.  I did not actually recognize who he was at that point.  I had heard his name, but he was just "the CTO" I had heard about - I was a hired gun from one of the vendors, I certainly did not hang out in board rooms with Chief Execs at that point in my career.

I had looked at all the usual suspects that might indicate a problem, followed the guidance of support, etc...  It wasn't until my curiousity led me down a path to look at how many times this system had to be rebooted, and once I put that data in to a spreadsheet to have a way to analyze the text output, that I was able to start seeing patterns.  If I recall, I think I was trying to figure *if* someone had been logging in around the time of the crashes, and then *who*.  (if you run the "last" command, you can see who logged in, the last time the box had been booted, the time between reboots, etc..).  

After I responded with my estimated time to the next crash, Alan asked, "How do you know that?"  I told him what I was looking at, and then he asked me to show him.  

He then said, "Let's get support this information".  
"I did, a few days ago", I replied.  
"And??"  
"I have not heard anything back on that yet."  
"I want them on the phone and I'll explain to them what their priorities are"  

I learned *many* things during my gig at GE Healthcare, but one amazing thing I learned from Alan - while he was not as technical as the consultants occupying desks in his environment, he still knew how to analyze a situation, direct workflow, ensure there were checkpoints and contigency.  

After Alan pushed on support to investigate this finding, we set off to figure out how to analzyze what the system was doing and how it changed over time.

## Unintended consequences
These "huge memory" systems were certainly not common and were somewhat new at this point in time.  Enterprise class systems have additional features built in to the hardware to be somewhat predictive and protective regarding hardware health - [ECC memory](https://en.wikipedia.org/wiki/ECC_memory), for example.  The system was capable of assessing memory health by doing checks of each location.  But... when we added a TON of memory (throwing resources at the problem, seemingly without any real reason) the problem was exacerbated, but in a very unexpected way.  Rather than waiting for Oracle DB to "stumble upon" bad memory on its own, the Operating System tried to find the bad cells and flag them.  This method worked fine until a threshold was surpassed (I don't know if they ever determined *exactly* how much memory would cause the issue).  But, as the system traversed every bit of memory in doing this health check, eventually it would consume too much resources in its own registers and would begin to hang. (see references at bottom).

## 
We had decisions to make:

* disable the memory scrubber?
* remove memory?

If we disable the scrubber, we risk data corruption, which may not be obvious/detectable until a later point in time.  
If we remove memory to fix the issue, how do we figure out how much to remove?  (again, we did not know what the threshold was causing the issue, nor did we know if other factors might play a role in the threshold value).

We opted to remove memory until the system stabilized, allow Sun Microsystems engineers time to fix their code. 

## References
[Memory Scrubber](https://patents.google.com/patent/EP0986783A1/ja) (AKA ECC Scrubbing)  
[Data Scrubbing](https://en.wikipedia.org/wiki/Data_scrubbing)  



