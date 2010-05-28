From: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Fri, 28 May 2010 16:31:51 +0200
Message-ID: <20C856F0-0CEB-45B9-A668-C07C89A7D338@xs4all.nl>
References: <4BFCF55A.80205@bobich.net>	<927E6E4B-B072-42EE-915A-FD34A88D478A@xs4all.nl>	<4BFF8BD6.7080802@bobich.net>	<72C0FCE6-CE1A-4262-B89F-A1C3CBA99EAD@xs4all.nl>	<4BFF9E74.6040900@bobich.net> <BF3C6199-02BC-415A-B028-E856312FB2DD@xs4all.nl> <4BFFC6FA.8010208@bobich.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFFC6FA.8010208-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On May 28, 2010, at 3:36 PM, Gordan Bobic wrote:

> Vincent Diepeveen wrote:
>
>>>> The big speedup that SSD's deliver for average usage is  
>>>> ESPECIALLY because of the faster random access to the hardware.
>>>
>>> Sure - on reads. Writes are a different beast. Look at some  
>>> reviews of SSDs of various types and generations. Until  
>>> relatively recently, random write performance (and to a large  
>>> extent, any write performance) on them has been very poor. Cheap  
>>> flash media (e.g. USB sticks) still suffers from this.
>>>
>> You wouldn't want to optimize a file system for hardware of the  
>> past is it?
> >
>> Before a file system is any mature, the hardware that is the  
>> standard today will be very common.
>
> There are a few problems with that line of reasoning.
>
> 1) Legacy support is important. If it wasn't, file systems would be  
> strictly in the realm of fixed disk manufacturers, and we would all  
> be using object based storage. This hasn't happened, nor is it  
> likely to in the next decade.
>
> 2) We cannot optimize for hardware of the future, because this  
> hardware may never arrive.
>
> 3) "Hardware of the past" is still very much in full production,  
> and isn't going away any time soon.
>
> The only sane option is to optimize for what is prevalent right now.
>
>>>> if you have some petabytes of storage, i guess the bigger  
>>>> bandwidth that SSD's deliver is not relevant, as the limitation
>>>> is the network bandwidth anyway, so some raid5 with extra spare  
>>>> will deliver more than sufficient bandwidth.
>>>
>>> RAID3/4/5/6 is inherently unsuitable for fast random writes  
>>> because if a write-read-write cycle required to update the parity.
>>>
>> Nearly all major supercomputers use raid5 with extra spare as well  
>> as most database servers.
>
> Can you quantify that bold statement?
>
> I would expect vastly higher levels of RAID than RAID5 on  
> supercomputers, because RAID5 doesn't scale sufficiently. RAID6 is  
> a bit better, but still doesn't really scale. It comes down to data  
> error rates on disks. RAID5 with current error rates tops out at  
> about 6-8TB, which is pitifully small on the supercomputer scale.

I'm speaking of each microunit of course. Call the bigger system as  
you want.
Each microunit basically gets built from a raid5 with 1 extra spare.

To be very honest - past so many years i didn't see anything else  
anywhere.
About all active supercomputers use this principle; note that most  
governments
have no clue on networks and order a cheap network; very few do order  
a good network.

I'd say if you already overpay some factors for expensive intel or  
ibm processors,
why not also order a good network?

Yet no matter what network you show up with. The total write speed  
that your storage delivers is always
going to be a lot more than the network can deliver to it.

These machines get build for a price. Using raid5 with an extra spare  
is simply cheapest and makes sense.

You can't beat it pricewise.

Then how each microunit connect with each other is yet another story  
and different in each architecture.

>
> Anybody deploying RAID5 on high-performance database servers that  
> are expected to have more than about 1% write:read ratio has no  
> business being a database administrator, IMO.

that's a very dumb statement. A single raid5 has nowadays 3 gbit  
speed and you got thousands of them.

it is only the tiny pc's such as my quad socket opteron box here,  
which run an entire database,
where a higher raid level makes more sense such as raid 10. Yet  
that's factor 2 in overhead in i/o.

Isn't that a bit much?

As soon as we speak of clustered or supercomputer systems, the  
bandwidth to the i/o is the bottleneck always of course.

The expensive thing is the network or the cpu's anyway, not the  
harddrives, as long as you don't go for SSD's :)

Besides, the majority of number crunching software is doing stuff  
like matrix calculations (more than 50% of all system time goes to that
of HPC) and the number of reads is a lot more there than the number  
of writes.

>
> Then again the fact that I have managed to optimize the performance  
> of most systems I've been called to provide consultancy on by  
> factors of between 10 and 1000 without requiring any new hardware  
> shows me that the industry is full of people who haven't got a clue  
> what they are doing.
>

Industry knows very well what they do, price of raid5 is unbeatable.  
Then you add an extra spare, or even 2 spares,
so that you can allow for more fault tolerance. 2 disks can fail. Now  
the only choice is how big you want to make that raid5 array,
whether you can guess you can get away with the network choice with  
10-12 disks or with just 5 + 1 spare.
6 disks is a common choice. You can use that raid unit then within  
the grand circus for 60% efficiency.

>> Stock exchange is more into raid10 type clustering,
>> but those few harddrives that the stock exchange uses, is that  
>> relevant?
>
> You're pulling examples out of the air, and it is difficult to  
> discuss them without in-depth system design information. And I  
> doubt you have access to that level of the system design  
> information of stock exchange systems unless you work for one. Do you?

Why not take a look on my facebook what i do at home, that saves a  
lot of bandwidth in this mailing list.

>
>>>>>> So a file system should benefit from the special properties of  
>>>>>> a SSD to be suited for this modern hardware.
>>>>>
>>>>> The only actual benefit is decreased latency.
>>>> Which is mighty important; so the ONLY interesting type of  
>>>> filesystem for a SSD is a filesystem
>>>> that is optimized for read and write latency rather than  
>>>> bandwidth IMHO.
>>>
>>> Indeed, I agree (up to a point). Random IOPS has long been the  
>>> defining measure of disk performance for a reason.
>> I'm always very careful saying a benchmark is holy.
>
> Most aren't, but every once in a while a meaningful one comes up.  
> Random IOPS one is one such (relatively rare) example.
>
>>>> Especially read latency i consider most important.
>>>
>>> Depends on your application. Remember that reads can be sped up  
>>> by caching.
>> Even relative simple caching is very difficult to improve, with  
>> random reads.
>> The random read speed is of overwhelming influence.
>
> 20 years of experience in high-performance applications, databases  
> and clusters showed me otherwise. Random read speed is only an  
> issue until your caches are primed, or if your data set is  
> sufficiently big to overwhelm any practical amount of RAM you could  
> apply.
>

That's a lot of outdated machines.

>>> I look after a number of systems running applications that are  
>>> write-bound because the vast majority of reads can be satisfied  
>>> from page cache, but writes are unavoidable because transactions  
>>> have to be committed to persistent storage.
>> You're assuming the working set size fits in caching, which is a  
>> very interesting assumption.
>
> Not necessarily the whole working set, but a decent chunk of it,  
> yes. If it doesn't, you probably need to re-assess what you're  
> trying to do.
>
> For example, on databases, as a rule of thumb you need to size your  
> RAM so that all indexes aggregated fit into 50-75% of your RAM. The  
> rest of the RAM is used for page caches for the actual data.
>
> To put it into a different perspective - a typical RHEL server  
> install is 5-6GB. That fits into the RAM on the machine on my desk,  
> and almost fits into the RAM of the laptop on typing up this email on.
>
> If your working set is measured in petabytes, then you are probably  
> using some big iron from Cray or IBM with suitable amounts of  
> memory for your application.

Not at all. Until a few years ago they delivered 1Ghz alpha's to run  
an entire array.

>
>>> You cannot limit your performance assessment to the use-case of  
>>> an average desktop user running Firefox, Thunderbird and  
>>> OpenOffice 99% of the time. Those are not the users that file  
>>> systems advances of the past 30 years are aimed at.
>> Actually manufacturers design cpu's based upon a good analysis of  
>> the spec and linpack benchmark.
>> That's how it works in reality.
>
> Again, I'd love to hear some basis of this.

It might be helpful if i remind you that i'm co-author of a program  
that's in specint2006. Initially it was meant for specint2004.

Note the next specint i won't be in.

> I don't think there is any, outside of the realm of specialized  
> hardware that is specifically designed for linpack. For starters,  
> such a design would ignore the fact that even simple things like  
> the different optimizing compilers can yield performance  
> differences of 4-8x. CPU designers are smarter than to base their  
> CPU design based on linpack throughput.

You seem to really have no clue on how professional $100 billion  
companies are.

If you sell overexpensive products such as intel, marketing is  
everything.
For that marketing having something new that outperforms old  
generation is everything.

All the testers seem to share they always benchmark the same  
applications.
The easiest to design for is spec.

Spec takes years and years to release a benchmark, so that gives  
manufacturers like 4-7 years to tape out cpu's designed upon
accurate analysis of spec.

So the applications that get tested in benchmarks you put entire  
teams on to analyze and speedup for your hardware.
Same for others such as AMD, Sun etc.

Now if you realize that applications for specint2006 were submitted  
years before 2004, as it initially was meant to get specint2004,
and you then figure out which cpu's taped out some years after 2004,  
and then you'll notice that some features different manufacturers
have in their new cpu's, definitely 'by accident' work very well for  
the programs inside spec.

Nehalem with intel c++ 11.x is the ultimate design for specint2006 in  
that sense.

Beating its ipc (per core) is going to be *very* difficult.

>
>> If i would generate them the 'stupid manner', which is how about  
>> all software works, then it would be harddrive latency bound.
>> Of course there is no budget for SSD's for the generation of it, i  
>> explained you my financial status already.
>> So in contradiction to Ken Thompson i have to be clever.
>
> I'm going to assume that you have already read up on file system  
> optimizations, WRT stride, stripe-width and block group size.  
> Otherwise you could find your RAID array limited to the performance  
> of 1 disk on random IOPS.
>

The read latency a single SSD gets is so much faster than old  
fashioned drives

>> So already a year or 10 ago with some others we figured out a  
>> manner of generating that's a lot faster and which is not i/o bound
>> but CPU bound and also the CPU instructions needed have been  
>> reduced up roughly factor 60.
>> Yet you know what?
>> Number of reads is bigger than the number of writes. So it's a few  
>> dozen petabyte writes in total and a bit more reads than that.
>> Probably i'll figure out for this run how to turn off caching, as  
>> i cache myself in the entire RAM already.
>
> Are you talking about reads that actually hit the disks or reads  
> that the application performs? If the data was recently read/ 
> written, then chances are that the reads will have come from  
> caches. Pay attention to your iostat figures.

when i speak of reads i always speak of reads that hit the disk.
when i speak of writes i speak always of writes that hit the disk.

In fact writes get done 100% sequential.

>
>> Of course i use a relative small amount of RAM whenever possible,  
>> because the latency is the CPU always in all calculations
>> and the bandwidth to the RAM. Now when using a small amount of  
>> RAM, when that is possible, say a couple of hundreds of MB,
>> the latency within that is always faster than when using the  
>> entire gigabytes of RAM that the box has.
>
> I'm not sure what you're talking about here. CPU cache hit rates,  
> maybe?
>

Oh lala, the big optimizer.

If you use a cache of 10GB of ram then the latency within that ram to  
do a random read is slower than when you
do a random read in a smaller part of RAM, say 400MB.

And no, the L1,L2,L3 are not the reason for that.

RAM has become really slow at cheap systems such as that quad socket  
opteron here.
Getting randomly 8 bytes out of the RAMis between 300 and 320  
nanoseconds.

307 ns at the system here.

I tested that with my own benchmarking application. If you want it, i  
can email it you. It's open source.
I wrote it to test SSI's of supercomputers.

>> Even simple old file systems already can get to the full bandwidth  
>> of any hardware, both read and write,
>> as this proces is not random, but has been bandwidth optimized for  
>> both i/o as well as CPU.
>
> That's just wrong. It's not about the file system being able to use  
> the full bandwidth of the hardware, it's about the file system  
> reducing the amount of I/O required so the hardware can perform  
> more work with the same amount of physical resources. Unless you  
> were mis-explaining what you mean.
>

You're assuming stupid software that doesn't know what it can cache  
here.

My software has its own caches which are of course faster than the  
pagefile from the OS.

So everytime i use the word READ or WRITE to the file system, i  
really mean to physical disk :)

>> When the final set has been generated, what will happen with it,  
>> is some sort of supercompression to it.
>> Then it'll fit on SSD hardware easily.
>> Then it will only be used for reads during searches. So all what  
>> matters then is the random read latency.
>
> That's a very, very specialized case that doesn't apply to the vast  
> majority of applications.
>

Name me 1 petabyte storage type database that needs more writes than  
reads, or even where it is "on par".

Nearly all big storage is for applications that do an overwhelming  
number of reads extra than writes.

>> This is kind of true for most databases which do not fit in the RAM.
>
> Not at all. Not by a long way. While I agree that database reads  
> usually outnumber the writes by a factor of 100:1, most of those  
> reads never hit the disk. For most decently tuned databases, 90%+  
> of reads are served from caches, and most of the work is performed  
> before even looking at data tables (usually in page caches), as the  
> record sets are resolved from the index data (generally in RAM,  
> unless performance really isn't a concern).
>

Ignore the caches please. Just look to the number of READS to disk  
and WRITES to disk.

The number of reads to disk total overwhelm the number of writes.

In most applications this is mathematical provable by the way.

>> Number of reads is so overwhelming bigger, that basically with  
>> SSD's you care most for random read speed of course.
>
> SSDs yield impressively fast boot up times and operation while  
> caches are cold. And page cache latency is still some 2000x faster  
> than SSD latency (50ns vs 100us).

You're having the wrong assumption that you can improve my caching  
system; so the guy who has been doing everything to design over the  
past 15
years better caching systems you want to tell he should cache better.

I'm amazed how you focus upon 1 detail here.

That detail has already been solved.

The bottleneck REALLY is the random read latency to disk and nothing  
else :)

>
>> Now you have a point that the random write speed is important in  
>> many applications;
>> however it can be a few factors worse than random read speed, as  
>> long as it isn't phenomenal weaker.
>
> Unless your system is tuned to the point where most reads come from  
> page caches.
>

You have no idea with whom you're dealing sir.

>>>>> I am more interested in metrics for how much writing is  
>>>>> required relative to the amount of data being transferred. For  
>>>>> example, if I am restoring a full running system (call it 5GB)  
>>>>> from a tar ball onto nilfs2, ext2, ext3, btrfs, etc., I am  
>>>>> interested in how many blocks worth of writes actually hit the  
>>>>> disk, and to a lesser extent how many of those end up being  
>>>>> merged together (since merged operations, in theory, can cause  
>>>>> less wear on an SSD because bigger blocks can be handle more  
>>>>> efficiently if erasing is required.
>>>> The most efficient blocksize for SSD's is 8 channels of 4KB blocks.
>>>
>>> I'm not going to bite and get involved in debating the  
>>> correctness of this (somewhat limited) view. I'll just point out  
>>> that it bears very little relevant to the paragraph that it  
>>> appears to be responding to.
>> Don't act arrogant.
>> To say it in a manner guys with 100 IQ points below me understand;
>> If you're doing random writes using the 8 independant channels of  
>> 4KB you'll hit the full bandwidth of the SSD basically.
>
> Except you don't get 8 channels on your interface to the SSD. All  
> you are talking about here is the fact that the SSD might be using  
> 8 flash chips in RAID0, which is less relevant. The number of  
> channels also varies wildly across products (the current line of  
> Intel X25-M drives has a 10-channel design). But this still doesn't  
> take away from the fact that random writes are difficult for SSDs.  
> Switch off the write caching on your SSD (hdparm -W0) and see what  
> kind of a performance hit you get. Since you are claiming that SSDs  
> don't have issues with random writes, how do you explain that?

I'm claiming that random write speed though relevant is far less  
relevant than random read speed.

You focus just upon random write speed here, whereas most software  
has optimized the writing already at software level
wherever it was possible, to stream it sequential to disk; so no need  
to do that at filesystem level.

What really matters as we both agree upon is that there shouldn't be  
a too big gap (say factor 100) between random write speed versus  
random read speed.

But a few times slower write speed is quite ok.

> The only reason they are better at managing this random write  
> deficiency on the current generation of drives is because they are  
> doing some serious write re-ordering and physical/logical re- 
> mapping to linearize the writes.
>
> Have a look here for more info on this, conceptually if not product- 
> wise:
> http://www.managedflash.com/index.htm
> If you were right and it wasn't an issue, ingenious hacks like this  
> wouldn't help. While I'm slightly skeptical about the net benefit  
> of this for the latest generation of SSDs (I haven't tried it yet),  
> it is clear that older drives extract considerable benefit from it.
>

I prefer the price of the SSD's to go down rather than the write  
speed get faster :)

> But the original point I was making in the original paragraph this  
> has been spawned from is about how many writes a file system  
> requires to make the data stick, after all the journaling, metadata  
> and superblock writes are accounted for. Essentially, for writing  
> 1000 files, which file system requires fewest writes to the disk.  
> While this may not be an issue for expensive SSDs with good wear  
> leveling, it is certainly an issue for applications that use cheap  
> disk-like media (CF, SD, etc.) that may not have as advanced a wear  
> leveling algorithm in it's firmware, thus making avoidance of  
> unnecessary writes all the more important.
>

What will be most important is that all the different threads that  
write to the i/o, that they are fast.

Where you tend to believe it is 50 ns to get a memory access, that's  
completely wrong.

Even at a 2 socket nehalem system the fastest access to RAM (say a 2  
GB buffer) with 8 cores at the same time,
is roughly 70 ns. Then you just have 8 bytes. In reality you want  
quite a bit more than 8 bytes.

At quad socket hardware it's far over 300 nanoseconds in fact to just  
get 8 bytes.

So it's definitely a lot slower than you guess.

The real problem with the file system when all cores are busy doing  
something, will be that all the cores must message each other
to invalidate cache lines and so on. Cache snooping etc.

That's really ugly slow.

So it is very important to not setup a datastructure where the cpu is  
nonstop busy with this.

If it has to do it a couple of hundreds of times, then you also have  
a significant penalty (say 30-100 us)
just to updatign the file system.

Where this might be peanuts at a system where little i/o gets done,  
it's an useless loss of time.




> Gordan
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
