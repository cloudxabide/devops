# Design Principles

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

#### Using multiple cluster
##### Cons
* there is the added cost of 3 "control-plane" nodes to provide extra resilience (which incurs no adtl licensing for OCP, I might add).
* development tasks and maintenance must be performed on each cluster (requiring more work)
##### Pros
* Easier to test platform updates, execute maintenance, etc.. with lesser risk
* development tasks and maintenance must be performed on each cluster (providing more protection, as you should discover issues on one cluster before impacting both)

### Separation of Duties
The Principle regarding the [Separation of Duties](https://en.wikipedia.org/wiki/Separation_of_duties) has a history outside the realm of IT.  While SOD is not a perfect system/approach, (of course it is possible to have multiple people coordinate to execute a nefarious plan).  SOD is not only to prevent bad actors, but to also protect your workflow by having multiple people review and approve the review.

### Least Privilege
The [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) is similar to the previous Principles.  As a general approach/practice you should *always* limit what access a service/user/process has to the minimum that is necessary.  This limits your exposure in the case that part of your environment is compromised.

### Zero Trust
(To be Cont'd)

### Bad design/implementation WILL happen
Regardless if the topic of this section is *actually* true, you should build your system as though it is - and, architect to mitigate this reality.  Like mentioned earlier, treat these systems as though your *own* data is going to be acquired if/when the systems are comprimised.

<hr>

