From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix race condition that causes file system corruption
Date: Sun, 29 Oct 2017 14:24:46 +0900
Message-ID: <CAKFNMo=UfirJzx5TBvT6ap9f_ozJDZ5AdnD94qF03dV=B5HX9Q@mail.gmail.com>
References: <20170711061907.19259-1-andreas.rohner@gmx.net>
 <CAKFNMonzhYBKkjotNiNY0x0DnWxzHYF8WvO7f7xjGwr-8a=aRQ@mail.gmail.com>
 <20170713084434.4c68f7d6@terok> <CAKFNMomD0qE3Q-bSfH=6-A82LaEVh2fK8Asp6emgYMa9BstQKw@mail.gmail.com>
 <CAKFNMomWEWyPZ4jSvJLk9AdzuDxn1T4-gxsOpbgRoZ-=6jH1Tg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Fgeha2X+qEHd0oiiligp35coN3Qhv408Nw3IN1p7E9s=;
        b=P2gYOztBwZFXS2RsxRz22EFdaJoulVP88sqzqljmO17mX7wr8YCHzl/lp9PLdVkn6W
         HKpR2Z0L3SaMI38Upq6Fh5qMMRPHGWzHbtxgh5e32fZTsZVYaeh+jKfdDVRtaQ7hsuRx
         7Nx1ZpT7Pp0bx9A1yKW+yI5Gdb6g49QbIXwhMq20qntKxV+Yy+vrxXahYl5iX6cBe6pr
         pS4AXjtk52gAHJM+OjsbvOZgou2TQhCVmlmrJEbJpBkOOQI3DpKly0f7wZavtRYpt52i
         3Wpqs3gmYQulgROCpCtB//YF489Tu1pLYkSyUR3g4UqqLeO8lszxvQrH215nkIyusyqZ
         LSQQ==
In-Reply-To: <CAKFNMomWEWyPZ4jSvJLk9AdzuDxn1T4-gxsOpbgRoZ-=6jH1Tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

If someone could confirm the patch by Andreas fixed the original corruption
issue,  I will send the patch to upstream anyway.

Verification (a "Tested-by" tag) is needed to let it go to stable trees.

Ryusuke Konishi


2017-10-29 14:09 GMT+09:00 Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Unfortunately the patch didn't fix this issue:
>
> [  612.614615] NILFS (sda1): segctord starting. Construction interval
> = 5 seconds, CP frequency < 30 seconds
> [ 4298.841376] NILFS (sda1): nilfs_ioctl_move_inode_block: conflicting
> data buffer: ino=1155, cno=11, offset=1, blocknr=1216036,
> vblocknr=1198436
> [ 4298.841877] NILFS (sda1): error -17 preparing GC: cannot read source blocks
>
> Look like the bugsimulator hit other bug.
>
> When this happened, the disk usage was 100%:
>
> $ df /dev/sda1
> Filesystem     1K-blocks     Used Available Use% Mounted on
> /dev/sda1      104849404 99655676         0 100% /test
>
> And, the error killed cleanerd.   However, I could cleanly unmount the
> partition, and
> I didn't see any errors after remount the partition.
>
> As you commented, I have changed some parameters in /etc/nilfs_cleanerd.conf:
> -------------------------------------------
> mc_nsegments_per_clean  16
> nsegments_per_clean     16
> max_clean_segments              30%
> cleaning_interval       0.1
> mc_cleaning_interval    0.1
> -------------------------------------------
>
> I will look into this issue with bugsimulator.
>
> Anyone can reproduce the original corruption issue in other way?
>
> Regards,
> Ryusuke Konishi
>
>
> 2017-10-29 2:16 GMT+09:00 Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Hi,
>>
>> Sorry for my late reponse.
>> I could reproduce a corruption issue with the bug simulator.
>>
>> -----
>> [88805.039545] NILFS (sda1): segctord starting. Construction interval = 5 second
>> s, CP frequency < 30 seconds
>> [92817.941644] NILFS (sda1): nilfs_ioctl_move_inode_block: conflicting data buff
>> er: ino=10846, cno=92, offset=2, blocknr=11425709, vblocknr=11227714
>> [92817.941936] NILFS (sda1): error -17 preparing GC: cannot read source blocks
>> -----
>>
>> Now I'm testing the patch.   I will send it to upstream after it turned
>> out to suppress the issue.
>>
>> The patch itself looks good to me though I guess there may be similar bugs.
>> What makes things complicated seems that inode block is not marked as dirty
>> just when "propagate" function carries a dirty state from a dirty
>> node/data block.
>>
>> Anyway, I hasten to apply this patch.
>>
>> Thanks,
>> Ryusuke Konishi
>>
>>
>> 2017-07-13 15:44 GMT+09:00 Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
>>> Hi,
>>>
>>> Am Wed, 12 Jul 2017 09:08:57 +0900
>>> schrieb Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>>
>>>> Hi,
>>>>
>>>> 2017-07-11 15:19 GMT+09:00 Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
>>>> >
>>>> > There is a race condition between the function nilfs_dirty_inode()
>>>> > and nilfs_set_file_dirty().
>>>> >
>>>> > When a file is opened, nilfs_dirty_inode() is called to update the
>>>> > access timestamp in the inode. It calls __nilfs_mark_inode_dirty()
>>>> > in a separate transaction. __nilfs_mark_inode_dirty() caches the
>>>> > ifile buffer_head in the i_bh field of the inode info structure and
>>>> > marks it as dirty.
>>>> >
>>>> > After some data was written to the file in another transaction, the
>>>> > function nilfs_set_file_dirty() is called, which adds the inode to
>>>> > the ns_dirty_files list.
>>>> >
>>>> > Then the segment construction calls
>>>> > nilfs_segctor_collect_dirty_files(), which goes through the
>>>> > ns_dirty_files list and checks the i_bh field. If there is a cached
>>>> > buffer_head in i_bh it is not marked as dirty again.
>>>> >
>>>> > Since nilfs_dirty_inode() and nilfs_set_file_dirty() use separate
>>>> > transactions, it is possible that a segment construction that
>>>> > writes out the ifile occurs in-between the two. If this happens the
>>>> > inode is not on the ns_dirty_files list, but its ifile block is
>>>> > still marked as dirty and written out.
>>>> >
>>>> > In the next segment construction, the data for the file is written
>>>> > out and nilfs_bmap_propagate() updates the b-tree. Eventually the
>>>> > bmap root is written into the i_bh block, which is not dirty,
>>>> > because it was written out in another segment construction.
>>>> >
>>>> > As a result the bmap update can be lost, which leads to file system
>>>> > corruption. Either the virtual block address points to an
>>>> > unallocated DAT block, or the DAT entry will be reused for
>>>> > something different.
>>>> >
>>>> > The error can remain undetected for a long time. A typical error
>>>> > message would be one of the "bad btree" errors or a warning that a
>>>> > DAT entry could not be found.
>>>> >
>>>> > This bug can be reproduced reliably by a simple benchmark that
>>>> > creates and overwrites millions of 4k files.
>>>> >
>>>> > Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>>>>
>>>> Will review, please wait for a while.
>>>
>>> Thank you, I have uploaded my benchmark on GitHub:
>>>
>>> https://github.com/zeitgeist87/bugsimulator
>>>
>>> The benchmark is very simple. It writes out 13107200 4k files in a two
>>> layer directory tree, so that every directory contains about 1000 files.
>>> Then it overwrites these files in an infinite loop.
>>>
>>> You need quite aggressive cleaner settings for it to keep up with the
>>> bugsimulator:
>>>
>>> mc_nsegments_per_clean  16
>>> nsegments_per_clean     16
>>> max_clean_segments              30%
>>> cleaning_interval       0.1
>>> mc_cleaning_interval    0.1
>>>
>>> If you run this benchmark on a fresh 100GB NILFS2 partition with the
>>> above cleaner settings, the file system will be corrupt in about half an
>>> hour. At least on my machine.
>>>
>>> With the patch for the race condition, it can run indefinetly.
>>>
>>> Regards,
>>> Andreas
>>>
>>>> Regards,
>>>> Ryusuke Konishi
>>>>
>>>> >
>>>> > ---
>>>> >  fs/nilfs2/segment.c | 6 ++++--
>>>> >  1 file changed, 4 insertions(+), 2 deletions(-)
>>>> >
>>>> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>>>> > index 70ded52dc1dd..50e12956c737 100644
>>>> > --- a/fs/nilfs2/segment.c
>>>> > +++ b/fs/nilfs2/segment.c
>>>> > @@ -1958,8 +1958,6 @@ static int
>>>> > nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci, err,
>>>> > ii->vfs_inode.i_ino); return err;
>>>> >                         }
>>>> > -                       mark_buffer_dirty(ibh);
>>>> > -                       nilfs_mdt_mark_dirty(ifile);
>>>> >                         spin_lock(&nilfs->ns_inode_lock);
>>>> >                         if (likely(!ii->i_bh))
>>>> >                                 ii->i_bh = ibh;
>>>> > @@ -1968,6 +1966,10 @@ static int
>>>> > nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci, goto
>>>> > retry; }
>>>> >
>>>> > +               // Always redirty the buffer to avoid race condition
>>>> > +               mark_buffer_dirty(ii->i_bh);
>>>> > +               nilfs_mdt_mark_dirty(ifile);
>>>> > +
>>>> >                 clear_bit(NILFS_I_QUEUED, &ii->i_state);
>>>> >                 set_bit(NILFS_I_BUSY, &ii->i_state);
>>>> >                 list_move_tail(&ii->i_dirty, &sci->sc_dirty_files);
>>>> > --
>>>> > 2.13.2
>>>> >
>>>> > --
>>>> > To unsubscribe from this list: send the line "unsubscribe
>>>> > linux-nilfs" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-nilfs" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
