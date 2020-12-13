# Manifesto

## The Story
The chronicles of my crazy journey working as a consultant in the Services and Delivery Organization of premiere companies which provide OS and middleware software, and public cloud.  (Sun Microsystems, Red Hat and AWS - if you were wondering...)

[Pixies - Where is my Mind?](https://www.youtube.com/watch?v=49FB9hhoO6c)  
"You've met me in a very strange time in my life" -- The Narrator, Fight Club   

"I'm going to give you a little advice. There's a force in the universe that makes things happen; all you have to do is get in touch with it. Stop thinking...let things happen...and be...the ball." -- Ty Webb, Caddyshack

[Basement Jaxx - Where's Your Head At](https://www.youtube.com/watch?v=5rAOyh7YmEc)  

["A Man's *got* to know his limitiations"](https://www.youtube.com/watch?v=uki4lrLzRaU&feature=youtu.be&t=147) -- Harry Callahan (Clint Eastwood).  A message seemingly telling you to limit your risks - I see it as the opposite, how will you know what you're capable of, if you never push yourself to fail.

Know-it-all:  I have learned (with quite a bit of validation from peers/friends):  It's OK to not know everything... and it's OK to know that you don't know everything.  
In fact, if you feel that you know everything, you're probably [hosed.](https://en.wikipedia.org/wiki/Dunning%E2%80%93Kruger_effect)

---
### Have fun
"Good times, bad times... you know I had my share" -- Jimmy Page  
I feel all the points in this doc are important points - but "Have Fun" is fairly paramount.  Seriously this is work, and not personal.  Remain Customer-focused and Customer-centric.  Follow the other points below and things should go well.  If things do not go well, and you did your best, it likely has nothing to do with you.  

### Be Present  
This may seem obvious, but... listen to calls, really listen.  Take notes.  Try to read the customers tone.  Don't browse, don't scribble (unless scribbling is how you center, I suppose)

### Be Punctual  
Being on-time is likely one of the simplest things you can expect yourself to do.  If this means you have to add a 15 reminder to meeting notices, then.. you know what you have to do.

### Yearn to Learn (elevate your state)
Find passion in digging in and learning about the topics and technology(s) we implement and support.

### Mind the Gap
Don't {un,re}invent the wheel...
Somebody has (probably) already done what you are about to take on.  Look around, ask around.

### Know the mission  
If you don't know *why* you are doing *what* you are doing, find out.  Dig in.  This is rather important.  Be sure to ask the customer to identify goals and objectives.  Have them explain what problem(s) they are trying to solve and what outcomes they are seeking.  

### Start with the End (in mind)
Or, working backwards.  Try to focus on the Business Objectives and what we are trying to accomplish - rather than focusing on all the issues they had trying to solve problems and how they are (seemingly) insurmountable.

### Know thy enemy...  
While the saying is a bit dramatic, the point is:  Your "enemy" (perhaps "competition" is a better word) is your competition for a reason - they possess traits/skills/etc...which present a challenge to you, or differentiate them from you.  Learn what those traits are, focus on the merits of the traits.  There is no shame in following other's example when they are positive and constructive.

### Know the message
Stop saying "we should eat our own dog food" and instead say "we drink our own Champagne"   
Nobody likes dog food... celebrate our amazing products!

### Know... that you won't know everything  
"Fake it, 'til you make it"   
-- No...  this saying needs to stop.  Let's invent a better phrase.  
"Face it 'til you make it"  
"Embrace it 'til you make it"  

[OODA!](https://en.wikipedia.org/wiki/OODA_loop) -- observe–orient–decide–act  
While I appreciate the sentiment of trying to mitigate concern we inevitably encounter as a consultant, if a customer heard their $3xx/hour consultant say that phrase, I am pretty sure they would not be impressed.  And you're NOT faking anything.  You are there for a reason.  That said, you should not... and will not... know everything.  That is fine (and expected) - know your limits, know how to concede that you need to research to provide the customer an accurate and timely response.

### Get Comfortable Being Uncomfortable
Similiar to the last quip, you should find a way to normalize being uncomfortable.  Many of us do this in different ways (pushing ourselves during exercise, getting a college degree as an adult, etc..)  To be clear:  don't seek to be indifferent about being uncomfortable - rather, learn to acknowledge it, and embrace it as a normal part of life (for someone who is trying to continously be better and challenge themself).  
[Inc.com article](https://www.inc.com/chris-dessi/how-to-get-comfortable-with-being-uncomfortable-according-to-a-green-beret.html)

### References
[Four Stages of Confidence](https://en.wikipedia.org/wiki/Four_stages_of_competence)  
[Dunning-Kruger effect](https://en.wikipedia.org/wiki/Dunning%E2%80%93Kruger_effect)

## Design Principles
This section was recently added and is still a work-in-progress.  I believe I want it to highlight that there are particular aspects of the architecture which should be present in all facets of the design process.  (i.e. always in the back of your mind.)  
While we may not *all* have Security in our job title, it certainly should be in everyone's job description.  We are ALL responsible for security.  I have pondered whether the idea that anyone who is part of a system design, operation, maintenance should have their own personal data included with all their customer's personal data.  Protect everyone as though you would protect yourself.  

### Defense In Depth
I find the [Defense in Depth](https://en.wikipedia.org/wiki/Defense_in_depth_(computing)) to probably be the most interesting.  My opinion is that it seems like the most strategic and logical approach (regardless of what context it is being applied).  For example:  the wikipedia article says it's also known as the Castle Approach (and not Frank Castle from The Punisher).  Review the following [NIST 800-53](https://nvd.nist.gov/800-53/Rev4/control/SC-32) Control Description as an example in the "real world".

### Blast Radius
Initially, I had the following:  
I suppose technically a resut of Defense In Depth.  (provide more detail for this later though)

Well, later.. has arrived.  Blast radius is not only a security concept, but an ideal for resliency.  An example:
 Let's consider an outage scenario for something like OpenShift - which has a control-plane, and compute-plane.  
Imagine you need 6 compute nodes to provide enough capacity for your workload.  
Now, let's talk about 2 ways you could manage that capacity:
* 1 cluster Environment - called Hercules
  * single "control plane" of 3 nodes (blue)
  * single "compute plane" of 6 nodes (blue)
* 2 cluster(s) Environment - called Orthrus 
  * control plane of 3 nodes (blue)
  * control plane of 3 nodes (green)
  * compute plane of 3 "compute nodes" (blue)
  * compute plane of 3 "compute nodes" (green)

Failure scenario 1:  bad information is uploaded to the control plane  
Failure scenario 2:  the control plane is hacked 

| Cluster Name | Failure Scenario | Outcome |
|:-------------|:----------------:|:--------|
| Hercules     | 1                | Potential failure for ALL compute
| Hercules     | 2                | Potential failure for ALL compute
| Orthrus      | 1                | Potential faliure for Green cluster compute, Blue compute still operational
| Orthrus      | 2                | Potential failure for Green cluster compute, Blue compute still operational

### Using multiple cluster
#### Cons
* there is the added cost of 3 "control-plane" nodes to provide extra resilience (which incurs no adtl licensing for OCP, I might add).  
#### Pros
* Easier to test platform updates, execute maintenance, etc.. with lesser risk

### Separation of Duties
The Principle regarding the [Separation of Duties](https://en.wikipedia.org/wiki/Separation_of_duties) has a history outside the realm of IT.  While SOD is not a perfect system/approach, (of course it is possible to have multiple people coordinate to execute a nefarious plan).  SOD is not only to prevent bad actors, but to also protect your workflow by having multiple people review and approve the review.

### Least Privilege 
The [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) is similar to the previous Principles insofar as you should *always* limit what access/exposure a service/user/process has.

### Bad design/implementation WILL happen
Regardless if the topic of this section is *actually* true, you should build your system as though it is - and, architect to mitigate this reality.  Like mentioned earlier, treat these systems as though your *own* data is going to be acquired if/when the systems are comprimised.

<hr>

I am not hiding the fact that a lot of my strategy is derived from my time spent at AWS.  The [Leadership Principles](https://www.amazon.jobs/en/principles) are a great way to approach a sound mindset.

## From Jeff Bezos...  
I included the following because I think it's a meaningful thing to read.  
https://www.inc.com/scott-mautz/jeff-bezos-says-asking-these-12-questions-now-will-make-you-proud-of-life-youve-built-later.html  

1. How will you use your gifts?
We all have gifts, no exception. How can you wield yours like the superpowers they are to do good for the world?  
Different gifts can surface at different times. My business/marketing gifts served me well for decades, until I wanted to use other gifts in servitude (thus becoming a speaker/author/
teacher/coach). I've found the most happiness in using my gifts to serve something greater than myself.

2. What choices will you make?  
This is about being intentional, working on your life versus in it. Breaking toxic patterns and accepting responsibility for the outcomes. And as 70s rock icon Geddy Lee sang: "If you choose not to decide, you still have made a choice," so living on autopilot isn't an option. Choose to be intentional in your choices.

3. Will inertia be your guide, or will you follow your passions?  
"Unstuck" starts with "U." The road to success is dotted with many tempting parking spots--if you've put it in park, thrust it into drive.
I fell into a comfortable, corporate pattern. Things were coming easy but learning and growth wasn't. I was shrinking. It wasn't until I kicked my entrepreneurial dreams into overdrive that I yanked myself out of a rut.

4. Will you follow dogma or be original?  
I haven't done everything right over my career as a boss. But I know that when I gave employees the space, encouragement, and safety to bring their original thinking to the table (and managed by objective versus oversight), I saw wings unfurl.
Yours will too, if you dare to create. It doesn't have to be something that's absolutely unique, just uniquely you.

5. Will you choose a life of ease, or a life of service and adventure?  
Shifting to a life of servitude wasn't easy. I had to redefine what success looks like, rethink how much wealth/income I really needed, reevaluate what living comfortably means. While the challenges that come with a life of service/adventure aren't inconsequential, I can't imagine it any other way at this stage of my life.

6. Will you wilt under criticism or follow your convictions?  
You decide who gets to criticize you. Not all criticism is created equal--some doing the criticizing shouldn't even get a seat at the table.

7. Will you bluff it out when you're wrong or apologize?  
The fastest route to regret is to let your role in tension/conflict linger. And I've never, ever regretted being the bigger person when necessary.

8. Will you guard your heart against rejection or act when you fall in love?  
I know the temptation to be smarmy is high given Bezos' recent indiscretions, but it shouldn't taint the truth to this point.

9. Will you play it safe or be a bit swashbuckling?  
You know that pit you feel in your stomach before you try something that scares/worries you? That feeling isn't there to frighten you. It's there to tell you that something must be worth it, otherwise you'd feel nothing.

10. When it's tough, will you give up or be relentless?  
Psychology research from the University of Pennsylvania indicates that mental toughness, or "grit," as the researchers call it, is the single most important factor for success, even above intelligence. Being persistent pays.

11. Will you be a cynic or a builder?  
Cynics lose their power when challenged. Challenge yourself to lift up rather than tear down. There are so many trolls that hide under their bridge and spew acid. Don't be a troll--be a bridge.

12. Will you be clever at the expense of others, or will you be kind?  
There's no value my wife and I try to role model more for our child than kindness. Why? Because it's the positive, environment-molding attribute from which all other positive attributes flow.
We're the editors of our own life story. Our job is to build the most meaningful chapters we can before "The End". So get introspective now to enjoy your looking-back perspective later.

