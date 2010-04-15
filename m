From: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: NILFS information request
Date: Thu, 15 Apr 2010 02:37:22 +0200
Message-ID: <0580A275-B1BA-47D3-9650-486339F8A12D@xs4all.nl>
References: <4283.1025.1852-28777-1386800339-1271287189@seznam.cz>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4283.1025.1852-28777-1386800339-1271287189-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: ales-76-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Apr 15, 2010, at 1:19 AM, ales-76-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org wrote:

> Hello,
>
> I'm not sure if I understand your requirements correctly, but I  
> have my doubts about NILFS being a silver bullet for latency  
> constrained workloads.

Thanks for your valuable input, i really appreciate your quick reply!

Als Blah e.a.

> First, the idea behind log-structured file systems is to optimize  
> for writes - batching several unrelated write requests into a  
> single continuous write. Your workload seems to be read-mostly

I'm not so much looking for a single silver bullet from good old  
days, instead i'm looking for a readspeed from the OS which is  
similar to 21th century electronic bullet fire rates.

Correct it is only reads. Basically see it as a big ROM that  
*sometimes* gets used to terminate a search when the absolute truth  
is already known about a specific entity (position).

> (BTW, ReiserFS is noted for very good small file performance and it  
> worked stable for me).

Well i expect that if you do only reads that basically any FS will be  
reasonably bugfree.

I would not use reiserFS for mission critical stuff too quickly; i  
had bad experiences there, but well that is an entirely different  
discussion,
as i have no statistical evidence other than it messed up for me too  
much :)

Same stability problems with ext3 and software raid-0 in linux  
kernel. Always problems.

However what matters here is having 1 mainboard where i want to do as  
fast as possible small reads from the i/o meanwhile the cpu's are busy
with their Artificial Intelligence job, so it shouldn't eat massive  
system time either. It all is about the total time of a single read  
and that as many times
a second as i can.

Acceptable is a load of 10%. So basicaly every core is allowed to  
lose 10% of its time to i/o reads. Now how many can i do a second a  
core to achieve that?

So to speak if getting 1 byte is really fast in a specific filesystem  
i can move to bytelevel, as i store 5 positions in 1 byte ( 3^5 = 241  
so that fits in 1 byte).
Each position can have in a simplified form of fuzzy logic 3  
realities: "win, draw or loss". So the length of the reads i can  
really limit bigtime.

However as things in past were tuned to magnetic disk speeds latency,  
things also get cached in the RAM. For this i have designed an O (1)  
lookup table,
which is quite sophisticated and the aim is to use the RAM efficiently.

Much depends upon the speed at which can get read from the flash 'usb  
stick' so to speak or SD card, whatever i can get cheap in size say  
64 GB or more.


> Second, performace of any file system depends on performance of the  
> underlying hardware and magnetic disks simply cannot deliver enough  
> IOPs, especially for random reads/writes.

Of course we are all aware of that, but also that of course magnetic  
disks for a 100 euro you can have a terabyte,
whereas for fast latency storage sized 1 terabyte you can buy entire  
Greece nowadays.

> So if you want really low latency and high IO rate you probably  
> need to either go for SSDs (and NILFS for that matter),

Apologies for my stupid mathematical logics in this, even though i  
have never studied math of course; i only kept myself busy with  
numbers and theories of myself how to
manipulate them (google for probable primes and Diepeveen), as  
opposed to math guys who apply lemma's in braindead manner.

However according to logical thinking you first say that i should  
consider Reiser-FS for doing a lot of low latency reads and now  
suddenly must consider NILFS for exactly the same thing?

I'm not following that logics. Can you explain?

> or keep the whole working set in memory (which is usually  
> prohibitive in terms of price).

The algorithms for the mainsearch speed up exponential with fast RAM  
accesses, so we are speaking of a shared memory type of system; sure  
my engine also ran on a supercomputer
such as SGI origin3800 @ 1024 processors from which i could use a  
partition of 512 processors for the search. However that's very low  
latency communication between each processor
over the shared memory network; not comparable with the factor 1000  
slower latencies practical of gigabit ethernet (forget about paper  
claims here, it really is ugly slow), which 'en passant'
(french for 'in the meantime' - excusez le mot) in its ugly slowness  
also jams all the cores of the processors while doing that (not DMA  
huh?).

So to keep it simple minded i'm looking for single mainboard i/o  
speed, where speed is just the number of reads i can do with 16  
cores. Then this core is doing a read then that core,
and so on. The cores do not know from each other whether and when  
they do a read, if they do one at all. Chaining really happens a lot  
there; a core that is doing a read now
has a high chance of doing a read next time also. In fact odds are  
good it is a read to a position closeby a previous done read, which  
is why i cache it in the RAM with some small
buffer.

Say a gigabyte of RAM or so in total for all caches of all cores  
together.

> Third, there are other things than file systems that are probably  
> more suited to the task. I mean, you can put several machines  
> together to form a cluster and than run a distribited key-value  
> store on it.

If you google on me you'll see i'm also in the beowulf mailing list.  
See above for clusters. I'm interested in maximizing read speed to a  
device, or even using several devices,
like for example i would use an usb stick with 16GB and a SD card of  
32GB etc, wasn't it that the usb stick would jam everything (central  
locking somewhere?).

Of course 32GB is rather small, so odds are also there it can be a  
SSD or something, wasn't it that for just 128GB it's already 200  
euro, far outside budget,
who knows one day though...

3000 euro for 1TB SSD is rather expensive i'd argue. Would those  
still be fast latency?

Please note i'm not aware what latency we can expect from SATA as a  
standard,
as i see some of those 1 TB SSD's are in fact PCI-E cards with a disk  
put on top of it.

Of course PCI-E, if we look to the fastest network cards, they can  
deliver at around 1 us latency handsdown, which is really a lot  
faster than times quoted
for SSD's of 75 us, so i assume it is needed for additional cooling  
as well.

> Key-value stores are something in between a file system and  
> relational database. These are optimized for retrieving/storing  
> small objects with low latency. Most known key-value store is  
> probably Amazon's Dynamo (http://www.allthingsdistributed.com/ 
> 2007/10/amazons_dynamo.html), but there are others. You can find a  
> decent introduction here: http://www.metabrew.com/article/anti- 
> rdbms-a-list-of-distributed-key-value-stores/ I understand that my  
> answers are probably not what you expected, but that's what I  
> think. And I'm sure others will have come up with something more  
> substantial and more related to NILFS performace for your workload.

Yeah so they say Amazon personnel living in the clouds (computing)  
might have plenty of time right now spamming the net...

Let's hope discussion is about NILFS here :)

Thanks for your contribution.

Vincent

>
> Cheers
>
> Ales Blaha
>
>> hi all,
>> Read an interesting article online on NILFS suggesting it would be  
>> ok for fast latency.
>> Very interesting.
>> Now my use case is rather simple. It is for read-only of EGTBs.   
>> (chess endgametablebases).
>> During a game tree search of (for example) a chessprogram if  
>> reaching far endgame,
>> it will go into the file system and do a lot of random reads.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
