From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 0/9] nilfs2: implementation of cost-benefit GC policy
Date: Sun, 15 Mar 2015 00:40:39 +0900 (JST)
Message-ID: <20150315.004039.972680698417010702.konishi.ryusuke@lab.ntt.co.jp>
References: <54FF561E.7030409@gmx.net>
	<20150312.215431.324210374799651841.konishi.ryusuke@lab.ntt.co.jp>
	<55042879.90701@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=W5pVl6nBBtKJVHT5vaNS8LRNt1n7IJQGbfNAmvbQ5HE=;
        b=gTuhln54XkxWDwt0KzNPiQTLwfQWWO1TB6VhAkp33EZ2TRcbsPX+endnaN2GLXoYrO
         kBDKANK7NmasAmWNRBLVcFS2eYXun571DFvG0/5x8ZAN38RMO8iH/4Xg5jXwA09t2pOc
         bAQEzv00muMQO9ePVh9qV5lxV9IRLZGZ+RTRb6H8enmoEE3xPwkeyr3/fie5y3nJW5kK
         /vECB566RuatLfmiA8mF/3Lm/4F4kigZBpnM9EfQTGbs0Rhdmr72Z1P2K7V02DZnwmQs
         USFxlJLkTdBG1Zk9ZC2mX/LEmLBg6OnjAFIp5S8kvHBzK4ZrGnJ+g61sgPCpsrsAkxV9
         TFfw==
In-Reply-To: <55042879.90701-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 14 Mar 2015 13:24:25 +0100, Andreas Rohner wrote:
> Hi Ryusuke,
> 
> Thank you very much for your detailed review and feedback. I agree with
> all of your points and I will start working on a rewrite immediately.
> 
> On 2015-03-12 13:54, Ryusuke Konishi wrote:
>> Hi Andreas,
>> 
>> On Tue, 10 Mar 2015 21:37:50 +0100, Andreas Rohner wrote:
>>> Hi Ryusuke,
>>>
>>> Thanks for your thorough review.
>>>
>>> On 2015-03-10 06:21, Ryusuke Konishi wrote:
>>>> Hi Andreas,
>>>>
>>>> I looked through whole kernel patches and a part of util patches.
>>>> Overall comments are as follows:
>>>>
>>>> [Algorithm]
>>>> As for algorithm, it looks about OK except for the starvation
>>>> countermeasure.  The stavation countermeasure looks adhoc/hacky, but
>>>> it's good that it doesn't change kernel/userland interface; we may be
>>>> able to replace it with better ways in a future or in a revised
>>>> version of this patchset.
>>>>
>>>> (1) Drawback of the starvation countermeasure
>>>>     The patch 9/9 looks to make the execution time of chcp operation
>>>>     worse since it will scan through sufile to modify live block
>>>>     counters.  How much does it prolong the execution time ?
>>>
>>> I'll do some tests, but I haven't noticed any significant performance
>>> drop. The GC basically does the same thing, every time it selects
>>> segments to reclaim.
>> 
>> GC is performed in background by an independent process.  What I'm
>> care about it that NILFS_IOCTL_CHANGE_CPMODE ioctl is called from
>> command line interface or application.  They differ in this meaning.
>> 
>> Was a worse case senario considered in the test ?
>> 
>> For example:
>> 1. Fill a TB class drive with data file(s), and make a snapshot on it.
>> 2. Run one pass GC to update snapshot block counts.
>> 3. And do "chcp cp"
>> 
>> If we don't observe noticeable delay on this class of drive, then I
>> think we can put the problem off.
> 
> Yesterday I did a worst case test as you suggested. I used an old 1 TB
> hard drive I had lying around. This was my setup:
> 
> 1. Write a 850GB file
> 2. Create a snapshot
> 3. Delete the file
> 4. Let GC run through all segments
> 5. Verify with lssu that the GC has updated all SUFILE entries
> 6. Drop the page cache
> 7. chcp cp
> 
> The following results are with the page cache dropped immediately before
> each call:
> 
> 1. chcp ss
> real	0m1.337s
> user	0m0.017s
> sys	0m0.030s
> 
> 2. chcp cp
> real	0m6.377s
> user	0m0.023s
> sys	0m0.053s
> 
> The following results are without the drop of the page cache:
> 
> 1. chcp ss
> real	0m0.137s
> user	0m0.010s
> sys	0m0.000s
> 
> 2. chcp cp
> real	0m0.016s
> user	0m0.010s
> sys	0m0.007s
> 
> There are 119233 segments in my test. Each SUFILE entry uses 32 bytes.
> So the worst case for 1 TB with 8 MB segments would be 3.57 MB of random
> reads and one 3.57 MB continuous write. You only get 6.377s because my
> hard drive is so slow. You wouldn't notice any difference on a modern
> SSD. Furthermore the SUFILE is also scanned by the segment allocation
> algorithm and the GC, so it is very likely already in the page cache.

6.377s is too long because nilfs_sufile_fix_starving_segs() locks
sufile mi_sem, and even lengthens lock period of the following locks:

 - cpfile mi_sem (held at nilfs_cpfile_clear_snapshot()).
 - transaction lock (held at nilfs_ioctl_change_cpmode()).
 - ns_snapshot_mount_mutex (held at nilfs_ioctl_change_cpmode()).

leading to freeze of all write operations, lssu, lscp, cleanerd, and
snapshot mount, etc.

It is preferable for the function to be moved outside of them and to
release/reacquire transaction lock and sufile mi_sem regularly in some
way.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
