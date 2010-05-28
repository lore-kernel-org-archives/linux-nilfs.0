From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Fri, 28 May 2010 14:36:58 +0100
Message-ID: <4BFFC6FA.8010208@bobich.net>
References: <4BFCF55A.80205@bobich.net>	<927E6E4B-B072-42EE-915A-FD34A88D478A@xs4all.nl>	<4BFF8BD6.7080802@bobich.net>	<72C0FCE6-CE1A-4262-B89F-A1C3CBA99EAD@xs4all.nl>	<4BFF9E74.6040900@bobich.net> <BF3C6199-02BC-415A-B028-E856312FB2DD@xs4all.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BF3C6199-02BC-415A-B028-E856312FB2DD-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vincent Diepeveen wrote:

>>> The big speedup that SSD's deliver for average usage is ESPECIALLY 
>>> because of the faster random access to the hardware.
>>
>> Sure - on reads. Writes are a different beast. Look at some reviews of 
>> SSDs of various types and generations. Until relatively recently, 
>> random write performance (and to a large extent, any write 
>> performance) on them has been very poor. Cheap flash media (e.g. USB 
>> sticks) still suffers from this.
>>
> 
> You wouldn't want to optimize a file system for hardware of the past is it?
 >
> Before a file system is any mature, the hardware that is the standard 
> today will be very common.

There are a few problems with that line of reasoning.

1) Legacy support is important. If it wasn't, file systems would be 
strictly in the realm of fixed disk manufacturers, and we would all be 
using object based storage. This hasn't happened, nor is it likely to in 
the next decade.

2) We cannot optimize for hardware of the future, because this hardware 
may never arrive.

3) "Hardware of the past" is still very much in full production, and 
isn't going away any time soon.

The only sane option is to optimize for what is prevalent right now.

>>> if you have some petabytes of storage, i guess the bigger bandwidth 
>>> that SSD's deliver is not relevant, as the limitation
>>> is the network bandwidth anyway, so some raid5 with extra spare will 
>>> deliver more than sufficient bandwidth.
>>
>> RAID3/4/5/6 is inherently unsuitable for fast random writes because if 
>> a write-read-write cycle required to update the parity.
>>
> 
> Nearly all major supercomputers use raid5 with extra spare as well as 
> most database servers.

Can you quantify that bold statement?

I would expect vastly higher levels of RAID than RAID5 on 
supercomputers, because RAID5 doesn't scale sufficiently. RAID6 is a bit 
better, but still doesn't really scale. It comes down to data error 
rates on disks. RAID5 with current error rates tops out at about 6-8TB, 
which is pitifully small on the supercomputer scale.

Anybody deploying RAID5 on high-performance database servers that are 
expected to have more than about 1% write:read ratio has no business 
being a database administrator, IMO.

Then again the fact that I have managed to optimize the performance of 
most systems I've been called to provide consultancy on by factors of 
between 10 and 1000 without requiring any new hardware shows me that the 
industry is full of people who haven't got a clue what they are doing.

> Stock exchange is more into raid10 type clustering,
> but those few harddrives that the stock exchange uses, is that relevant?

You're pulling examples out of the air, and it is difficult to discuss 
them without in-depth system design information. And I doubt you have 
access to that level of the system design information of stock exchange 
systems unless you work for one. Do you?

>>>>> So a file system should benefit from the special properties of a 
>>>>> SSD to be suited for this modern hardware.
>>>>
>>>> The only actual benefit is decreased latency.
>>> Which is mighty important; so the ONLY interesting type of filesystem 
>>> for a SSD is a filesystem
>>> that is optimized for read and write latency rather than bandwidth IMHO.
>>
>> Indeed, I agree (up to a point). Random IOPS has long been the 
>> defining measure of disk performance for a reason.
> 
> I'm always very careful saying a benchmark is holy.

Most aren't, but every once in a while a meaningful one comes up. Random 
IOPS one is one such (relatively rare) example.

>>> Especially read latency i consider most important.
>>
>> Depends on your application. Remember that reads can be sped up by 
>> caching.
> 
> Even relative simple caching is very difficult to improve, with random 
> reads.
> 
> The random read speed is of overwhelming influence.

20 years of experience in high-performance applications, databases and 
clusters showed me otherwise. Random read speed is only an issue until 
your caches are primed, or if your data set is sufficiently big to 
overwhelm any practical amount of RAM you could apply.

>> I look after a number of systems running applications that are 
>> write-bound because the vast majority of reads can be satisfied from 
>> page cache, but writes are unavoidable because transactions have to be 
>> committed to persistent storage.
> 
> You're assuming the working set size fits in caching, which is a very 
> interesting assumption.

Not necessarily the whole working set, but a decent chunk of it, yes. If 
it doesn't, you probably need to re-assess what you're trying to do.

For example, on databases, as a rule of thumb you need to size your RAM 
so that all indexes aggregated fit into 50-75% of your RAM. The rest of 
the RAM is used for page caches for the actual data.

To put it into a different perspective - a typical RHEL server install 
is 5-6GB. That fits into the RAM on the machine on my desk, and almost 
fits into the RAM of the laptop on typing up this email on.

If your working set is measured in petabytes, then you are probably 
using some big iron from Cray or IBM with suitable amounts of memory for 
your application.

>> You cannot limit your performance assessment to the use-case of an 
>> average desktop user running Firefox, Thunderbird and OpenOffice 99% 
>> of the time. Those are not the users that file systems advances of the 
>> past 30 years are aimed at.
> 
> Actually manufacturers design cpu's based upon a good analysis of the 
> spec and linpack benchmark.
> 
> That's how it works in reality.

Again, I'd love to hear some basis of this. I don't think there is any, 
outside of the realm of specialized hardware that is specifically 
designed for linpack. For starters, such a design would ignore the fact 
that even simple things like the different optimizing compilers can 
yield performance differences of 4-8x. CPU designers are smarter than to 
base their CPU design based on linpack throughput.

> If i would generate them the 'stupid manner', which is how about all 
> software works, then it would be harddrive latency bound.
> Of course there is no budget for SSD's for the generation of it, i 
> explained you my financial status already.
> 
> So in contradiction to Ken Thompson i have to be clever.

I'm going to assume that you have already read up on file system 
optimizations, WRT stride, stripe-width and block group size. Otherwise 
you could find your RAID array limited to the performance of 1 disk on 
random IOPS.

> So already a year or 10 ago with some others we figured out a manner of 
> generating that's a lot faster and which is not i/o bound
> but CPU bound and also the CPU instructions needed have been reduced up 
> roughly factor 60.
> 
> Yet you know what?
> 
> Number of reads is bigger than the number of writes. So it's a few dozen 
> petabyte writes in total and a bit more reads than that.
> Probably i'll figure out for this run how to turn off caching, as i 
> cache myself in the entire RAM already.

Are you talking about reads that actually hit the disks or reads that 
the application performs? If the data was recently read/written, then 
chances are that the reads will have come from caches. Pay attention to 
your iostat figures.

> Of course i use a relative small amount of RAM whenever possible, 
> because the latency is the CPU always in all calculations
> and the bandwidth to the RAM. Now when using a small amount of RAM, when 
> that is possible, say a couple of hundreds of MB,
> the latency within that is always faster than when using the entire 
> gigabytes of RAM that the box has.

I'm not sure what you're talking about here. CPU cache hit rates, maybe?

> Even simple old file systems already can get to the full bandwidth of 
> any hardware, both read and write,
> as this proces is not random, but has been bandwidth optimized for both 
> i/o as well as CPU.

That's just wrong. It's not about the file system being able to use the 
full bandwidth of the hardware, it's about the file system reducing the 
amount of I/O required so the hardware can perform more work with the 
same amount of physical resources. Unless you were mis-explaining what 
you mean.

> When the final set has been generated, what will happen with it, is some 
> sort of supercompression to it.
> Then it'll fit on SSD hardware easily.
> 
> Then it will only be used for reads during searches. So all what matters 
> then is the random read latency.

That's a very, very specialized case that doesn't apply to the vast 
majority of applications.

> This is kind of true for most databases which do not fit in the RAM.

Not at all. Not by a long way. While I agree that database reads usually 
outnumber the writes by a factor of 100:1, most of those reads never hit 
the disk. For most decently tuned databases, 90%+ of reads are served 
from caches, and most of the work is performed before even looking at 
data tables (usually in page caches), as the record sets are resolved 
from the index data (generally in RAM, unless performance really isn't a 
concern).

> Number of reads is so overwhelming bigger, that basically with SSD's you 
> care most for random read speed of course.

SSDs yield impressively fast boot up times and operation while caches 
are cold. And page cache latency is still some 2000x faster than SSD 
latency (50ns vs 100us).

> Now you have a point that the random write speed is important in many 
> applications;
> however it can be a few factors worse than random read speed, as long as 
> it isn't phenomenal weaker.

Unless your system is tuned to the point where most reads come from page 
caches.

>>>> I am more interested in metrics for how much writing is required 
>>>> relative to the amount of data being transferred. For example, if I 
>>>> am restoring a full running system (call it 5GB) from a tar ball 
>>>> onto nilfs2, ext2, ext3, btrfs, etc., I am interested in how many 
>>>> blocks worth of writes actually hit the disk, and to a lesser extent 
>>>> how many of those end up being merged together (since merged 
>>>> operations, in theory, can cause less wear on an SSD because bigger 
>>>> blocks can be handle more efficiently if erasing is required.
>>> The most efficient blocksize for SSD's is 8 channels of 4KB blocks.
>>
>> I'm not going to bite and get involved in debating the correctness of 
>> this (somewhat limited) view. I'll just point out that it bears very 
>> little relevant to the paragraph that it appears to be responding to.
> 
> Don't act arrogant.
> 
> To say it in a manner guys with 100 IQ points below me understand;
> If you're doing random writes using the 8 independant channels of 4KB 
> you'll hit the full bandwidth of the SSD basically.

Except you don't get 8 channels on your interface to the SSD. All you 
are talking about here is the fact that the SSD might be using 8 flash 
chips in RAID0, which is less relevant. The number of channels also 
varies wildly across products (the current line of Intel X25-M drives 
has a 10-channel design). But this still doesn't take away from the fact 
that random writes are difficult for SSDs. Switch off the write caching 
on your SSD (hdparm -W0) and see what kind of a performance hit you get. 
Since you are claiming that SSDs don't have issues with random writes, 
how do you explain that? The only reason they are better at managing 
this random write deficiency on the current generation of drives is 
because they are doing some serious write re-ordering and 
physical/logical re-mapping to linearize the writes.

Have a look here for more info on this, conceptually if not product-wise:
http://www.managedflash.com/index.htm
If you were right and it wasn't an issue, ingenious hacks like this 
wouldn't help. While I'm slightly skeptical about the net benefit of 
this for the latest generation of SSDs (I haven't tried it yet), it is 
clear that older drives extract considerable benefit from it.

But the original point I was making in the original paragraph this has 
been spawned from is about how many writes a file system requires to 
make the data stick, after all the journaling, metadata and superblock 
writes are accounted for. Essentially, for writing 1000 files, which 
file system requires fewest writes to the disk. While this may not be an 
issue for expensive SSDs with good wear leveling, it is certainly an 
issue for applications that use cheap disk-like media (CF, SD, etc.) 
that may not have as advanced a wear leveling algorithm in it's 
firmware, thus making avoidance of unnecessary writes all the more 
important.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
