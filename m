From: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Fri, 28 May 2010 14:33:31 +0200
Message-ID: <BF3C6199-02BC-415A-B028-E856312FB2DD@xs4all.nl>
References: <4BFCF55A.80205@bobich.net>	<927E6E4B-B072-42EE-915A-FD34A88D478A@xs4all.nl>	<4BFF8BD6.7080802@bobich.net> <72C0FCE6-CE1A-4262-B89F-A1C3CBA99EAD@xs4all.nl> <4BFF9E74.6040900@bobich.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFF9E74.6040900-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On May 28, 2010, at 12:44 PM, Gordan Bobic wrote:

> Vincent Diepeveen wrote:
>
>>>>> 1) Modern SSDs (e.g. Intel) do this logical/physical mapping  
>>>>> internally, so that the writes happen sequentially anyway.
>>>> Could you explain that, as far as i know modern SSD's have 8  
>>>> independant channels to do read and writes, which is why they  
>>>> are having that big read and write speed and can in theory  
>>>> therefore support 8 threads doing reads and writes. Each channel  
>>>> say using blocks of 4KB, so it's 64KB in total.
>>>
>>> I'm talking about something else. I'm talking about the fact that  
>>> you can turn logical random writes into physical sequential  
>>> writes by re-mapping logical blocks to sequential physical blocks.
>> That's doing 2 steps back in history isn't it?
>
> Sorry, I don't see what you mean. Can you elaborate?
>


>> The big speedup that SSD's deliver for average usage is ESPECIALLY  
>> because of the faster random access to the hardware.
>
> Sure - on reads. Writes are a different beast. Look at some reviews  
> of SSDs of various types and generations. Until relatively  
> recently, random write performance (and to a large extent, any  
> write performance) on them has been very poor. Cheap flash media  
> (e.g. USB sticks) still suffers from this.
>

You wouldn't want to optimize a file system for hardware of the past  
is it?

Before a file system is any mature, the hardware that is the standard  
today will be very common.

> Don't confuse fast random reads with fast random writes.
>

I'd be the last on the planet not knowing what random writes versus  
random reads is.

>> if you have some petabytes of storage, i guess the bigger  
>> bandwidth that SSD's deliver is not relevant, as the limitation
>> is the network bandwidth anyway, so some raid5 with extra spare  
>> will deliver more than sufficient bandwidth.
>
> RAID3/4/5/6 is inherently unsuitable for fast random writes because  
> if a write-read-write cycle required to update the parity.
>

Nearly all major supercomputers use raid5 with extra spare as well as  
most database servers.

Stock exchange is more into raid10 type clustering,
but those few harddrives that the stock exchange uses, is that relevant?

>>>> So a file system should benefit from the special properties of a  
>>>> SSD to be suited for this modern hardware.
>>>
>>> The only actual benefit is decreased latency.
>> Which is mighty important; so the ONLY interesting type of  
>> filesystem for a SSD is a filesystem
>> that is optimized for read and write latency rather than bandwidth  
>> IMHO.
>
> Indeed, I agree (up to a point). Random IOPS has long been the  
> defining measure of disk performance for a reason.
>

I'm always very careful saying a benchmark is holy.

>> Especially read latency i consider most important.
>
> Depends on your application. Remember that reads can be sped up by  
> caching.
>

Even relative simple caching is very difficult to improve, with  
random reads.

The random read speed is of overwhelming influence.

> I look after a number of systems running applications that are  
> write-bound because the vast majority of reads can be satisfied  
> from page cache, but writes are unavoidable because transactions  
> have to be committed to persistent storage.

You're assuming the working set size fits in caching, which is a very  
interesting assumption.

>
> You cannot limit your performance assessment to the use-case of an  
> average desktop user running Firefox, Thunderbird and OpenOffice  
> 99% of the time. Those are not the users that file systems advances  
> of the past 30 years are aimed at.

Actually manufacturers design cpu's based upon a good analysis of the  
spec and linpack benchmark.

That's how it works in reality.

>
>>>> Of course i understand you skip ext4 as that obviously still has  
>>>> to get bugfixed.
>>>
>>> It seems to be deemed stable enough for several distros, and will  
>>> be the default in RHEL6 in a few months' time, so that's less of  
>>> a concern.
>>>
>> I ran into severe problems with ext4 and i just used it at 1  
>> harddrive, same experiences with other linux users.
>
> How recently have you tried it? RHEL6b has only been out for a month.
>

Previous week.

Note i use AMD hardware. It seems intel gives away machines for free  
to all kind of projects, including open source projects;
i see them test very little at AMD hardware.

Yet the quad socket hardware i built here for under 1000 euro,  
harddrives not counted,
it has 16 cores of 2.3Ghz.

The size of the current EGTBs i use is 1 terabyte. Now that drives  
get bigger i intend to generate the 7 men.
Where the final set will be (uncompressed) roughly something against  
a 100 TB, the amount of i/o needed for that
will be roughly a 1000 times more.

If i would generate them the 'stupid manner', which is how about all  
software works, then it would be harddrive latency bound.
Of course there is no budget for SSD's for the generation of it, i  
explained you my financial status already.

So in contradiction to Ken Thompson i have to be clever.

So already a year or 10 ago with some others we figured out a manner  
of generating that's a lot faster and which is not i/o bound
but CPU bound and also the CPU instructions needed have been reduced  
up roughly factor 60.

Yet you know what?

Number of reads is bigger than the number of writes. So it's a few  
dozen petabyte writes in total and a bit more reads than that.
Probably i'll figure out for this run how to turn off caching, as i  
cache myself in the entire RAM already.

Of course i use a relative small amount of RAM whenever possible,  
because the latency is the CPU always in all calculations
and the bandwidth to the RAM. Now when using a small amount of RAM,  
when that is possible, say a couple of hundreds of MB,
the latency within that is always faster than when using the entire  
gigabytes of RAM that the box has.

Even simple old file systems already can get to the full bandwidth of  
any hardware, both read and write,
as this proces is not random, but has been bandwidth optimized for  
both i/o as well as CPU.

When the final set has been generated, what will happen with it, is  
some sort of supercompression to it.
Then it'll fit on SSD hardware easily.

Then it will only be used for reads during searches. So all what  
matters then is the random read latency.

This is kind of true for most databases which do not fit in the RAM.

Number of reads is so overwhelming bigger, that basically with SSD's  
you care most for random read speed of course.

Now you have a point that the random write speed is important in many  
applications;
however it can be a few factors worse than random read speed, as long  
as it isn't phenomenal weaker.

>> Note i used ubuntu.
>
> I guess that explains some of your desktop-centric views.
>
>> Stuff like RHEL is more expensive a copy  than i have at my bank  
>> account.
>
> RHEL6b is a public beta, freely downloadable.
>
> CentOS is a community recompile of RHEL, 100% binary compatible,  
> just with different artwork/logos. Freely available. As is  
> Scientific Linux (a very similar project to CentOS, also a free  
> recompile of RHEL). If you haven't found them, you can't have  
> looked very hard.
>

Except for RHEL, i know all this stuff very well of course.

>>> I am more interested in metrics for how much writing is required  
>>> relative to the amount of data being transferred. For example, if  
>>> I am restoring a full running system (call it 5GB) from a tar  
>>> ball onto nilfs2, ext2, ext3, btrfs, etc., I am interested in how  
>>> many blocks worth of writes actually hit the disk, and to a  
>>> lesser extent how many of those end up being merged together  
>>> (since merged operations, in theory, can cause less wear on an  
>>> SSD because bigger blocks can be handle more efficiently if  
>>> erasing is required.
>> The most efficient blocksize for SSD's is 8 channels of 4KB blocks.
>
> I'm not going to bite and get involved in debating the correctness  
> of this (somewhat limited) view. I'll just point out that it bears  
> very little relevant to the paragraph that it appears to be  
> responding to.

Don't act arrogant.

To say it in a manner guys with 100 IQ points below me understand;
If you're doing random writes using the 8 independant channels of 4KB  
you'll hit the full bandwidth of the SSD basically.

>
> Gordan

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
