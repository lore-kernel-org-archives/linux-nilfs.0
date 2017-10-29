From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix race condition that causes file system corruption
Date: Mon, 30 Oct 2017 07:19:01 +0900
Message-ID: <CAKFNMo=NnxYgxXhBASBY7QVO9phf=p3RgXCpCb6qWR9N99YedA@mail.gmail.com>
References: <20170711061907.19259-1-andreas.rohner@gmx.net>
 <CAKFNMonzhYBKkjotNiNY0x0DnWxzHYF8WvO7f7xjGwr-8a=aRQ@mail.gmail.com>
 <20170713084434.4c68f7d6@terok> <CAKFNMomD0qE3Q-bSfH=6-A82LaEVh2fK8Asp6emgYMa9BstQKw@mail.gmail.com>
 <CAKFNMomWEWyPZ4jSvJLk9AdzuDxn1T4-gxsOpbgRoZ-=6jH1Tg@mail.gmail.com>
 <20171029090712.1b19ef66@terok> <CAKFNMo=6uOSA-bdkxN6dYnPo-7Svkm2vMXbFLzcP_eEp9ra_jg@mail.gmail.com>
 <20171029150646.3853372c@terok> <CAKFNMonWJtOHxaHQO8SNPGOUx6H=ghp7EQ+L1s3nbjMZt-Zr_Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=E85HghDN0xMYF2+oWpXbWBmWzpzJkNMQLtSdBQlXbTM=;
        b=Eas+y1lNW/AbewlyShNKvsuD7zXfhuZ7AGrzr/upA9cQbBFPSup9djnGIzG0x/MjBc
         PQJIlQ7z3+62WfGzKgZH9YmHWbLAvZLwOzrQS4/Xqo/mWfP3rnMw5KAYOUhd9o5b3yn/
         x4CQwg/fk2CS7b27HcLF11Ip4B5mSmQuN663kz0Wc/JFHIGrxl+kxHLMmusuYVG0uDOt
         2pEQMEZunAkCDi7UAThbxaP5anrcJdvKwpWd2QI82I2mdaPgfE5L5VyDVd3lPjH+z5DS
         P8KjPFd4Ig9AQuS1J0cUqG848LJIiFvbZfu3+v8is13ZqeBfNuvc7PJPuZqQcj95Zbek
         nteg==
In-Reply-To: <CAKFNMonWJtOHxaHQO8SNPGOUx6H=ghp7EQ+L1s3nbjMZt-Zr_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I could reproduce the issue in two and a half hours.
Will proceed verification of the patch later.

Regards,
Ryusuke Konishi

2017-10-30 1:29 GMT+09:00 Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> I haven't yet succeeded to reproduce the original fs corruption error.
>>> Will continue to try reproducing the bug waiting for report from you
>>> and/or Clemens.
>>
>> I think I forgot to mention, that I use a protection period of 30
>> seconds. Here is my full nilfs_cleanerd.conf:
>
> Thanks.   This is likely to affect the test.
>
> Regards,
> Ryusuke Konishi
>
> 2017-10-29 23:06 GMT+09:00 Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
>> Am Sun, 29 Oct 2017 21:53:38 +0900
>> schrieb Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>
>>> 2017-10-29 17:07 GMT+09:00 Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
>>> > Hi Ryusuke,
>>> >
>>> > Thank you for reviewing my patch. I will rerun my tests to make sure
>>> > my conclusions were correct.
>>> >
>>> > The log output suggests to me, that you are hitting a totally
>>> > unrelated bug. I have seen that message before on one of my
>>> > experimental branches, but I didn't think it could happen with
>>> > stock NILFS2.
>>> >
>>> > My solution was to add the following piece of code to
>>> > nilfs_vdesc_is_live() in nilfs-utils:
>>> >
>>> > if (vdesc->vd_period.p_end == vdesc->vd_cno) {
>>> >         /*
>>> >          * This block was overwritten in the same logical segment,
>>> > but
>>> >          * in a different partial segment. Probably because of
>>> >          * fdatasync() or a flush to disk.
>>> >          * Without this check, gc will cause buffer confliction
>>> > error
>>> >          * if both partial segments are cleaned at the same time.
>>> >          * In that case there will be two vdesc with the same ino,
>>> >          * cno and offset.
>>> >          */
>>> >         return 0;
>>> > }
>>> >
>>> > I can't tell for sure if that will fix your problem. I am just
>>> > guessing. It isn't necessary with my setup, to reproduce the race
>>> > condition bug.
>>>
>>> Thank you, Andreas.  This snippet looks to have fixed the error so
>>> far.
>>>
>>> Could you shape it to a patch (preferably a separate one) for
>>> nilfs-utils repo ?
>>
>> Of course, but I am not sure how this error can occur exactly.
>> I tried to reproduce it with a small shell script using
>> fdatasync(), but I wasn't able to.
>>
>> However, I am pretty sure, that the patch does no harm and is safe.
>>
>>> I haven't yet succeeded to reproduce the original fs corruption error.
>>> Will continue to try reproducing the bug waiting for report from you
>>> and/or Clemens.
>>
>> I think I forgot to mention, that I use a protection period of 30
>> seconds. Here is my full nilfs_cleanerd.conf:
>>
>> protection_period       30
>> min_clean_segments      10%
>> max_clean_segments 30%
>> clean_check_interval    10
>> nsegments_per_clean 16
>> mc_nsegments_per_clean 16
>> cleaning_interval 0.1
>> mc_cleaning_interval 0.1
>> retry_interval          60
>> min_reclaimable_blocks  10%
>> mc_min_reclaimable_blocks       1%
>> use_set_suinfo
>> use_mmap
>> log_priority            info
>>
>> I can reproduce the corruption error with the latest kernel 4.14.0, and
>> I can confirm that it is fixed after applying the patch.
>> I used an older six core AMD Phenom(tm) II X6 1090T Processor and a
>> Samsung 850 EVO SSD.
>>
>> Best regards,
>>
>> Andreas
>>
>>> Thanks,
>>> Ryusuke Konishi
>>>
>>> >
>>> > I am rerunning my tests now to make sure I didn't make a mistake.
>>> >
>>> > Best regards,
>>> >
>>> > Andreas
>>> >
>>> > Am Sun, 29 Oct 2017 14:09:40 +0900
>>> > schrieb Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> >
>>> >> Unfortunately the patch didn't fix this issue:
>>> >>
>>> >> [  612.614615] NILFS (sda1): segctord starting. Construction
>>> >> interval = 5 seconds, CP frequency < 30 seconds
>>> >> [ 4298.841376] NILFS (sda1): nilfs_ioctl_move_inode_block:
>>> >> conflicting data buffer: ino=1155, cno=11, offset=1,
>>> >> blocknr=1216036, vblocknr=1198436
>>> >> [ 4298.841877] NILFS (sda1): error -17 preparing GC: cannot read
>>> >> source blocks
>>> >>
>>> >> Look like the bugsimulator hit other bug.
>>> >>
>>> >> When this happened, the disk usage was 100%:
>>> >>
>>> >> $ df /dev/sda1
>>> >> Filesystem     1K-blocks     Used Available Use% Mounted on
>>> >> /dev/sda1      104849404 99655676         0 100% /test
>>> >>
>>> >> And, the error killed cleanerd.   However, I could cleanly unmount
>>> >> the partition, and
>>> >> I didn't see any errors after remount the partition.
>>> >>
>>> >> As you commented, I have changed some parameters
>>> >> in /etc/nilfs_cleanerd.conf:
>>> >> -------------------------------------------
>>> >> mc_nsegments_per_clean  16 nsegments_per_clean     16
>>> >> max_clean_segments              30%
>>> >> cleaning_interval       0.1
>>> >> mc_cleaning_interval    0.1
>>> >> -------------------------------------------
>>> >>
>>> >> I will look into this issue with bugsimulator.
>>> >>
>>> >> Anyone can reproduce the original corruption issue in other way?
>>> >>
>>> >> Regards,
>>> >> Ryusuke Konishi
>>> >>
>>> >>
>>> >> 2017-10-29 2:16 GMT+09:00 Ryusuke Konishi
>>> >> <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> >> > Hi,
>>> >> >
>>> >> > Sorry for my late reponse.
>>> >> > I could reproduce a corruption issue with the bug simulator.
>>> >> >
>>> >> > -----
>>> >> > [88805.039545] NILFS (sda1): segctord starting. Construction
>>> >> > interval = 5 second s, CP frequency < 30 seconds
>>> >> > [92817.941644] NILFS (sda1): nilfs_ioctl_move_inode_block:
>>> >> > conflicting data buff er: ino=10846, cno=92, offset=2,
>>> >> > blocknr=11425709, vblocknr=11227714 [92817.941936] NILFS (sda1):
>>> >> > error -17 preparing GC: cannot read source blocks -----
>>> >> >
>>> >> > Now I'm testing the patch.   I will send it to upstream after it
>>> >> > turned out to suppress the issue.
>>> >> >
>>> >> > The patch itself looks good to me though I guess there may be
>>> >> > similar bugs. What makes things complicated seems that inode
>>> >> > block is not marked as dirty just when "propagate" function
>>> >> > carries a dirty state from a dirty node/data block.
>>> >> >
>>> >> > Anyway, I hasten to apply this patch.
>>> >> >
>>> >> > Thanks,
>>> >> > Ryusuke Konishi
>>> >> >
>>> >> >
>>> >> > 2017-07-13 15:44 GMT+09:00 Andreas Rohner
>>> >> > <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
>>> >> >> Hi,
>>> >> >>
>>> >> >> Am Wed, 12 Jul 2017 09:08:57 +0900
>>> >> >> schrieb Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> >> >>
>>> >> >>> Hi,
>>> >> >>>
>>> >> >>> 2017-07-11 15:19 GMT+09:00 Andreas Rohner
>>> >> >>> <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
>>> >> >>> >
>>> >> >>> > There is a race condition between the function
>>> >> >>> > nilfs_dirty_inode() and nilfs_set_file_dirty().
>>> >> >>> >
>>> >> >>> > When a file is opened, nilfs_dirty_inode() is called to
>>> >> >>> > update the access timestamp in the inode. It calls
>>> >> >>> > __nilfs_mark_inode_dirty() in a separate transaction.
>>> >> >>> > __nilfs_mark_inode_dirty() caches the ifile buffer_head in
>>> >> >>> > the i_bh field of the inode info structure and marks it as
>>> >> >>> > dirty.
>>> >> >>> >
>>> >> >>> > After some data was written to the file in another
>>> >> >>> > transaction, the function nilfs_set_file_dirty() is called,
>>> >> >>> > which adds the inode to the ns_dirty_files list.
>>> >> >>> >
>>> >> >>> > Then the segment construction calls
>>> >> >>> > nilfs_segctor_collect_dirty_files(), which goes through the
>>> >> >>> > ns_dirty_files list and checks the i_bh field. If there is a
>>> >> >>> > cached buffer_head in i_bh it is not marked as dirty again.
>>> >> >>> >
>>> >> >>> > Since nilfs_dirty_inode() and nilfs_set_file_dirty() use
>>> >> >>> > separate transactions, it is possible that a segment
>>> >> >>> > construction that writes out the ifile occurs in-between the
>>> >> >>> > two. If this happens the inode is not on the ns_dirty_files
>>> >> >>> > list, but its ifile block is still marked as dirty and
>>> >> >>> > written out.
>>> >> >>> >
>>> >> >>> > In the next segment construction, the data for the file is
>>> >> >>> > written out and nilfs_bmap_propagate() updates the b-tree.
>>> >> >>> > Eventually the bmap root is written into the i_bh block,
>>> >> >>> > which is not dirty, because it was written out in another
>>> >> >>> > segment construction.
>>> >> >>> >
>>> >> >>> > As a result the bmap update can be lost, which leads to file
>>> >> >>> > system corruption. Either the virtual block address points
>>> >> >>> > to an unallocated DAT block, or the DAT entry will be reused
>>> >> >>> > for something different.
>>> >> >>> >
>>> >> >>> > The error can remain undetected for a long time. A typical
>>> >> >>> > error message would be one of the "bad btree" errors or a
>>> >> >>> > warning that a DAT entry could not be found.
>>> >> >>> >
>>> >> >>> > This bug can be reproduced reliably by a simple benchmark
>>> >> >>> > that creates and overwrites millions of 4k files.
>>> >> >>> >
>>> >> >>> > Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>>> >> >>>
>>> >> >>> Will review, please wait for a while.
>>> >> >>
>>> >> >> Thank you, I have uploaded my benchmark on GitHub:
>>> >> >>
>>> >> >> https://github.com/zeitgeist87/bugsimulator
>>> >> >>
>>> >> >> The benchmark is very simple. It writes out 13107200 4k files
>>> >> >> in a two layer directory tree, so that every directory contains
>>> >> >> about 1000 files. Then it overwrites these files in an infinite
>>> >> >> loop.
>>> >> >>
>>> >> >> You need quite aggressive cleaner settings for it to keep up
>>> >> >> with the bugsimulator:
>>> >> >>
>>> >> >> mc_nsegments_per_clean  16
>>> >> >> nsegments_per_clean     16
>>> >> >> max_clean_segments              30%
>>> >> >> cleaning_interval       0.1
>>> >> >> mc_cleaning_interval    0.1
>>> >> >>
>>> >> >> If you run this benchmark on a fresh 100GB NILFS2 partition with
>>> >> >> the above cleaner settings, the file system will be corrupt in
>>> >> >> about half an hour. At least on my machine.
>>> >> >>
>>> >> >> With the patch for the race condition, it can run indefinetly.
>>> >> >>
>>> >> >> Regards,
>>> >> >> Andreas
>>> >> >>
>>> >> >>> Regards,
>>> >> >>> Ryusuke Konishi
>>> >> >>>
>>> >> >>> >
>>> >> >>> > ---
>>> >> >>> >  fs/nilfs2/segment.c | 6 ++++--
>>> >> >>> >  1 file changed, 4 insertions(+), 2 deletions(-)
>>> >> >>> >
>>> >> >>> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>>> >> >>> > index 70ded52dc1dd..50e12956c737 100644
>>> >> >>> > --- a/fs/nilfs2/segment.c
>>> >> >>> > +++ b/fs/nilfs2/segment.c
>>> >> >>> > @@ -1958,8 +1958,6 @@ static int
>>> >> >>> > nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
>>> >> >>> > err, ii->vfs_inode.i_ino); return err;
>>> >> >>> >                         }
>>> >> >>> > -                       mark_buffer_dirty(ibh);
>>> >> >>> > -                       nilfs_mdt_mark_dirty(ifile);
>>> >> >>> >                         spin_lock(&nilfs->ns_inode_lock);
>>> >> >>> >                         if (likely(!ii->i_bh))
>>> >> >>> >                                 ii->i_bh = ibh;
>>> >> >>> > @@ -1968,6 +1966,10 @@ static int
>>> >> >>> > nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
>>> >> >>> > goto retry; }
>>> >> >>> >
>>> >> >>> > +               // Always redirty the buffer to avoid race
>>> >> >>> > condition
>>> >> >>> > +               mark_buffer_dirty(ii->i_bh);
>>> >> >>> > +               nilfs_mdt_mark_dirty(ifile);
>>> >> >>> > +
>>> >> >>> >                 clear_bit(NILFS_I_QUEUED, &ii->i_state);
>>> >> >>> >                 set_bit(NILFS_I_BUSY, &ii->i_state);
>>> >> >>> >                 list_move_tail(&ii->i_dirty,
>>> >> >>> > &sci->sc_dirty_files); --
>>> >> >>> > 2.13.2
>>> >> >>> >
>>> >> >>> > --
>>> >> >>> > To unsubscribe from this list: send the line "unsubscribe
>>> >> >>> > linux-nilfs" in the body of a message to
>>> >> >>> > majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>>> >> >>> > http://vger.kernel.org/majordomo-info.html
>>> >> >>> --
>>> >> >>> To unsubscribe from this list: send the line "unsubscribe
>>> >> >>> linux-nilfs" in the body of a message to
>>> >> >>> majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>>> >> >>> http://vger.kernel.org/majordomo-info.html
>>> >> >>
>>> >> --
>>> >> To unsubscribe from this list: send the line "unsubscribe
>>> >> linux-nilfs" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> >> More majordomo info at
>>> >> http://vger.kernel.org/majordomo-info.html
>>> >
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-nilfs" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
