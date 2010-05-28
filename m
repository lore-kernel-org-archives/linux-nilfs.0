From: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Fri, 28 May 2010 14:45:35 +0200
Message-ID: <A3BB0C84-D2BD-4119-9296-0A4D9FC02F19@xs4all.nl>
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

I didn't investigate NILFS, but under all conditions what you want to  
avoid is some sort of central locking of the file system,
because if you're proposing all sorts of fancy stuff to the file  
system whereas you can already do your thing using full bandwidth of  
the SSD.

It really is interesting to have a file system where you do a minimum  
number of actions to the file system
so that other threads can do there work there. Any complicated  
datastructure manipulation that requires central locking
or other forms of complicated locking will limit other i/o actions.

Vincent

>> The big speedup that SSD's deliver for average usage is ESPECIALLY  
>> because of the faster random access to the hardware.
>
> Sure - on reads. Writes are a different beast. Look at some reviews  
> of SSDs of various types and generations. Until relatively  
> recently, random write performance (and to a large extent, any  
> write performance) on them has been very poor. Cheap flash media  
> (e.g. USB sticks) still suffers from this.
>
> Don't confuse fast random reads with fast random writes.
>
>> if you have some petabytes of storage, i guess the bigger  
>> bandwidth that SSD's deliver is not relevant, as the limitation
>> is the network bandwidth anyway, so some raid5 with extra spare  
>> will deliver more than sufficient bandwidth.
>
> RAID3/4/5/6 is inherently unsuitable for fast random writes because  
> if a write-read-write cycle required to update the parity.
>
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
>> Especially read latency i consider most important.
>
> Depends on your application. Remember that reads can be sped up by  
> caching.
>
> I look after a number of systems running applications that are  
> write-bound because the vast majority of reads can be satisfied  
> from page cache, but writes are unavoidable because transactions  
> have to be committed to persistent storage.
>
> You cannot limit your performance assessment to the use-case of an  
> average desktop user running Firefox, Thunderbird and OpenOffice  
> 99% of the time. Those are not the users that file systems advances  
> of the past 30 years are aimed at.
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
>
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
