From: Yuehai Xu <yuehaixu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Performance about nilfs2 for SSD
Date: Wed, 29 Sep 2010 17:44:30 -0400
Message-ID: <AANLkTinLs14zOK8A-m76AsJt3E04W4_bSeinZjT=g9eR@mail.gmail.com>
References: <AANLkTinLswg7ko3T-cGsSMMqPfcM0dZB7GN2o6Q2b3gY@mail.gmail.com>
	<20100926.181707.70807240.ryusuke@osrg.net>
	<AANLkTimXE22zz2TvMX6VGkFiosvF6qBxmpacc2PYDng6@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=FVM7UqOAqi3nv4LvbtSty0wl5s45cp3U/IF+90AEWUU=;
        b=qzC1l+A21yPW1iZKs/PyhY3ykGyU0iQ5cHFHd/i9Ex/HGrDxTsPU8NSS7gv05bktOC
         9SRw0WhjOEiB6GLoTI2cdFAWZACSnXUPk0TViRrz5fXjM/N4rbN+xwrOaYsJs39jvvk/
         S9bJj03lGV40gn1fXNFgmlxZVk2gACY/FbbfI=
In-Reply-To: <AANLkTimXE22zz2TvMX6VGkFiosvF6qBxmpacc2PYDng6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yhxu-jgEIgUtgKzeHXe+LvDLADg@public.gmane.org

I asked the same question in the list of Linux-btrfs, what I got is
that the inode itself will be overwritten too, except for the
superblocks. That seems make sense, how about NILFS2? I guess it
should be the same.

However, though I don't do much tests about SSD, I am wondering
whether it will be a bottleneck, since even the data is written to a
new place instead of writing it to the original one, the superblocks
which are in a fixed place should be updated all the time. This
operation might cause much more frequent over-writes to the areas
where the super blocks are. Is the SSD smart enough to handle this
over-write? or the file system can do something to avoid such kind of
situation.

Anyway, or this problem might not even be a problem for file system
because there are cache and the writes can be delayed.

I appreciate for your comments.

Thanks,
Yuehai

On Tue, Sep 28, 2010 at 4:03 PM, Yuehai Xu <yuehaixu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> On Sun, Sep 26, 2010 at 5:17 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> w=
rote:
>> Hi,
>> On Sat, 25 Sep 2010 18:54:04 -0400, Yuehai Xu wrote:
>>> Hi,
>>>
>>> I have a SSD which is Intel x25-v, I use it to test the performance=
 of
>>> different file systems. The results seems confusing to me. It is fr=
om
>>> postmark in which I set file number to 50,000 with each size from 9=
216
>>> bytes to 15360 bytes
>>>
>>> =A0 =A0 =A0 EXT3 =A0 =A0NILFS2 =A0BTRFS =A0 EXT4 =A0 =A0XFS =A0 =A0=
 REISERFS =A0 =A0 =A0 =A0EXT2
>>> PostMark(R) =A0 146.67Kb/s =A052.21Kb/s =A0 90.59Kb/s
>>> 172.12Kb/s =A0 =A060.39Kb/s =A0 =A0 =A0 146.67Kb/s =A0 =A0 =A083.25=
Kb/s
>>> PostMark(W) =A0 28.09Mb/s =A0 =A0 =A0 10Mb/s =A017.35Mb/s =A0 =A0 =A0=
 31.04Mb/s =A0 =A0 =A0 11.56Mb/s =A0 =A0 =A0 28.09Mb/s =A0 =A0 =A0 15.9=
4Mb/s
>>>
>>> From the results, the throughput both for R/W of NILFS2 is much
>>> smaller than EXT3. As I noticed that the performance of NILFS2 for =
SSD
>>> is much better than other file systems from the web site. What's th=
e
>>> matter with my own test result? My kernel is 2.6.32, and I use defa=
ult
>>> way to format NILFS2, nothing special is done. So, my questions are=
:
>>>
>>> 1. Are there any special parameters that I need to configure when I
>>> mount/format my SSD?
>>
>> Nilfs in latest kernels have "discard" mount option, but I think
>> it won't change the above result dramatically.
>>
>>> 2. Is the performance much different from different kind of SSD?
>>> 3. As I know, NILFS2 is a kind of Log-file system, which means it
>>> always makes the random writes sequentially and tries to avoid the
>>> cost of overwrite for SSD. Does it need to overwrite its meta data?
>>> Since I think NILFS2 should always make a mapping table, how about
>>> when the mapping table need to be updated?
>>
>> For older SSD drives, it may be true.
>>
>> But, recent intelligent SSD drives are doing LFS like optimizations
>> internally, so I guess they would show similar trend.
>
> What do you mean for "similar trend"? Do you mean that the throughput
> should be almost the same no matter the different kinds of file
> systems?
>
>>
>> Unfortunately NILFS2 has performance issue due to its DAT and Garbag=
e
>> Collection design, and it seems to be hurting the merit of LFS for
>> such high-throughput devices.
>>
>> DAT is metadata which is used to convert indirect block addresses
>> (called virtual block number) to real block addresses. =A0This makes
>> relocation of disk blocks possible, but at the same time, it makes
>> latency of disk access double against blocks read first time.
>>
>> To mitigate this design drawback, nilfs is applying readahead for su=
ch
>> metadata, but it has much room for tuning. =A0For instance, I recent=
ly
>> sent some patches to improve read performance on intel SSD for 2.6.3=
6.
>>
>> For details on the metadata organization and disk address conversion
>> of NILFS2, please see the slides:
>>
>> =A0http://www.nilfs.org/papers/jls2009-nilfs.pdf
>
> From the slice and Documentation/filesystems/nilfs2.txt, I notice tha=
t
> the DAT is stored almost at the end of every LOG, which seems certain
> parts of a disk. I know that Log-structure File System doesn't
> overwrite the original files, however, what confuses me is whether th=
e
> mapping info in inode should be overwritten. For example, suppose
> mapping info(LBA->PBA) of file A is stored in inode A. If file A is
> over written, actually the new file is written to B, then, I think th=
e
> corresponding mapping info in inode A should changes from file A to
> file B. In that way, is this operation a kind of over-write? Even
> though I read the papers from the link you give me, I don't get the
> exact answer.
>
> I appreciate your answer very much.
>
> For NILFS2, as you have said, DAT is used to convert virtual block
> address to real block address, that is from logical block address(LBA=
)
> to physical block address(PBA), I guess this is the place to maintain
> the mapping info. However, when these info are updated, for example,
> when over write happens, the original virtual block address should ma=
p
> to a new real block address, in such case, will over write happen in
> DAT? Is this one of the reason for SSD's performance of NILFS2?
>
> From the papers I have read, the general idea to do garbage collectio=
n
> is to copy some "live" from segments and compact them into a new live
> segments and then write them back, marking the original segments as
> free. Do you have any ideas to optimize this gc?
>
> Since I only read some papers and don't hack the source code, the
> questions I asked might be naive, I really appreciate your replying
>
> Thanks,
> Yuehai
>
>>
>> A link page ( http://www.nilfs.org/en/links.html ) has some more
>> related links.
>>
>>> 4. What's special has done to optimize the performance of SSD? I gu=
ess
>>> Log-file systems might have better performance than fast file syste=
ms
>>> such as EXT2/3, but at least right now the results shows that I was
>>> wrong.
>>
>> As I wrote above, recent SSD drives adopt own LFS like optimization,
>> and the performance characteristics are greatly affected by it. =A0I=
t's
>> well explained in the following article:
>>
>> =A0http://lwn.net/Articles/353411/
>>
>>
>> Regards,
>> Ryusuke Konishi
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
