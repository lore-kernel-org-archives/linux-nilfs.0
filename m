From: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Fri, 28 May 2010 12:15:50 +0200
Message-ID: <72C0FCE6-CE1A-4262-B89F-A1C3CBA99EAD@xs4all.nl>
References: <4BFCF55A.80205@bobich.net> <927E6E4B-B072-42EE-915A-FD34A88D478A@xs4all.nl> <4BFF8BD6.7080802@bobich.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFF8BD6.7080802-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On May 28, 2010, at 11:24 AM, Gordan Bobic wrote:

> Vincent Diepeveen wrote:
>
>>> 1) Modern SSDs (e.g. Intel) do this logical/physical mapping  
>>> internally, so that the writes happen sequentially anyway.
>> Could you explain that, as far as i know modern SSD's have 8  
>> independant channels to do read and writes, which is why they are  
>> having that big read and write speed and can in theory therefore  
>> support 8 threads doing reads and writes. Each channel say using  
>> blocks of 4KB, so it's 64KB in total.
>
> I'm talking about something else. I'm talking about the fact that  
> you can turn logical random writes into physical sequential writes  
> by re-mapping logical blocks to sequential physical blocks.

That's doing 2 steps back in history isn't it?

The big speedup that SSD's deliver for average usage is ESPECIALLY  
because of the faster random access to the hardware.

People who sequentially stream usually run on big government  
clusters. SSD's are too expensive for them and have too little  
storage space.

To qualify for the sporthall top 500 list (www.top500.org), you can  
cluster a lot cheaper with ordinary storage;
if you have some petabytes of storage, i guess the bigger bandwidth  
that SSD's deliver is not relevant, as the limitation
is the network bandwidth anyway, so some raid5 with extra spare will  
deliver more than sufficient bandwidth.

> Old, naive flash without clever firmware was always good at  
> sequential writes but bad at random writes. Since fragmentation on  
> flash doesn't matter since there is no seek time, modern SSDs use  
> such re-mapping to prolong flash life, reduce the need for erasing  
> blocks and improve random write performance by linearizing it.
>
> This is completely independent of the fact that you might be able  
> to write to the flash chips in a more parallel fashion because the  
> disk ASIC has the ability to use more of them simultaneously.
>
>>> Does nilfs demonstrably provide additional benefits on such  
>>> modern SSDs with sensible firmware?
>>>
>>> 2) Mechanical disks suffer from slow random writes (or any random  
>>> operation for that matter), too. Do the benefits of nilfs show in  
>>> random write performance on mechanical disks?
>>>
>>> 3) How does this affect real-world read performance if nilfs is  
>>> used on a mechanical disk? How much additional file fragmentation  
>>> in absolute terms does nilfs cause?
>>>
>> Basically the main difference between SSD's and traditional disks  
>> is that SSD's have a faster latency, have more than 1 channel and  
>> write small blocks of 4KB, whereas 64KB read/writes are already  
>> real small for a traditional disk.
>
> Which begs the question why the traditional disks only support  
> multi-sector transfers of up to 16 sectors, but that's a different  
> question.
>
>> So a file system should benefit from the special properties of a  
>> SSD to be suited for this modern hardware.
>
> The only actual benefit is decreased latency.

Which is mighty important; so the ONLY interesting type of filesystem  
for a SSD is a filesystem
that is optimized for read and write latency rather than bandwidth IMHO.

Especially read latency i consider most important.

>
>>> 4) As the data gets expired, and snapshots get deleted, this will  
>>> inevitably lead to fragmentation, which will de-linearize writes  
>>> as they have to go into whatever holes are available in the data.  
>>> How does this affect nilfs write performance?
>>>
>>> 5) How does the specific writing amount measure against other  
>>> file systems (I'm specifically interested in comparisons vs.  
>>> ext2). What I mean by specific writing amount is for writing,  
>>> say, 100,000 random sized files, how many write operations and  
>>> MBs (or sectors) of writes are required for the exact same  
>>> operation being performed on nilfs and ext2 (e.g. as measured by  
>>> vmstat -d).
>> Isn't ext2 a bit old?
>
> So? The point is that it has no journal, which means fewer writes.  
> fsck on SSDs only takes a few minutes at most.
>
>> Of course i understand you skip ext4 as that obviously still has  
>> to get bugfixed.
>
> It seems to be deemed stable enough for several distros, and will  
> be the default in RHEL6 in a few months' time, so that's less of a  
> concern.
>

I ran into severe problems with ext4 and i just used it at 1  
harddrive, same experiences with other linux users.
Note i used ubuntu. Stuff like RHEL is more expensive a copy than i  
have at my bank account.

> I am more interested in metrics for how much writing is required  
> relative to the amount of data being transferred. For example, if I  
> am restoring a full running system (call it 5GB) from a tar ball  
> onto nilfs2, ext2, ext3, btrfs, etc., I am interested in how many  
> blocks worth of writes actually hit the disk, and to a lesser  
> extent how many of those end up being merged together (since merged  
> operations, in theory, can cause less wear on an SSD because bigger  
> blocks can be handle more efficiently if erasing is required.

The most efficient blocksize for SSD's is 8 channels of 4KB blocks.

Vincent


>
> Gordan

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
