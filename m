From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: corrupted filesystem (again!)
Date: Mon, 31 Jan 2011 19:48:17 +0900 (JST)
Message-ID: <20110131.194817.132605624.ryusuke@osrg.net>
References: <AANLkTimZ6qXBwF0zYquz5Yep_x0zbCbNgcTCW7sTCs0U@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimZ6qXBwF0zYquz5Yep_x0zbCbNgcTCW7sTCs0U-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

Hi,
On Sat, 29 Jan 2011 15:06:03 -0800, Paul L wrote:
> Hi all,
> 
> If my memory serves me right, this is the 4th time I've had corrupted
> filesystem after using nilfs2 for almost 2 years. With help from the
> list, I've managed to recover every time! A big thank you to the
> everyone who helped! Let's see if this time I have any luck.
> 
> When I first noticed something wrong with the file system, command 'ls
> -l' would list some files with outrageously big size, like 20 digits
> or something. I don't remember doing any particular task before I
> noticed this. So I thought I would just reboot and see if things come
> back normal.
> 
> After a reboot, the disk failed to mount. That was almost two weeks
> ago, and I was using 2.0.20. I didn't do anything further except
> backing up the entire disk data.
> 
> Today I had a little more time and decided to upgrade to
> nilfs2-2.0.21, and still the same. Here is what dmesg showed me when I
> mount the file system (after I turned on CONFIG_NILFS_DEBUG and "echo
> '-vvv recovery' > /proc/fs/nilfs2/debug_option"):
> 
> 
> NILFS nilfs_fill_super: start(silent=0)
> NILFS warning: broken superblock. using spare superblock.
> NILFS warning: broken superblock. using spare superblock.
> NILFS(recovery) nilfs_search_super_root: looking segment
> (seg_start=1087488, seg_end=1089535, segnum=531, seg_seq=837256)
> NILFS(recovery) load_segment_summary: checking segment
> (pseg_start=1088825, full_check=1)
> NILFS(recovery) load_segment_summary: done (ret=0)
> NILFS(recovery) nilfs_search_super_root: found super root: segnum=531,
> seq=837256, pseg_start=1088825, pseg_offset=1396
> segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> NILFS(dat) nilfs_dat_translate: failed (ret=-2)
> NILFS warning (device mmcblk0p1): nilfs_ifile_get_inode_block: unable
> to read inode: 2
> NILFS: get root inode failed
> NILFS(segment) nilfs_segctor_thread: segctord exiting.
> NILFS nilfs_fill_super: aborted
> NILFS put_nilfs: the_nilfs on bdev mmcblk0p1 was freed
> 
> 
> Apparently, it was trying to use the spare superblock, but still
> couldn't find the root inode.

Sorry for inconvenience (again).

According to the log, DAT metadata file seems to be broken, but we
need more debug information to trace down what happened.

Can you try the following debug option?

 # echo "-vv dat" > /proc/fs/nilfs2/debug_option

Also, the summary information of the pointed log may be helpful:

 # dempseg /dev/mmcblk0p1 531
 # dempseg /dev/mmcblk0p1 530

And a few ragular questions:

- Do you think the garbage collector was working when it happened ?
- Was it near disk full ?


Regards,
Ryusuke Konishi

> I also tried the fsck0.niilfs2 utility from nilfs-utils-2.0.18. It
> didn't help either. Here is the output:
> 
> 
> Super-block:
>     revision = 2.0
>     blocksize = 4096
>     write time = 2011-01-18 23:22:07
>     indicated log: blocknr = 1088825
>         segnum = 531, seq = 837256, cno=1787400
> 
> Clean FS.
> A valid log is pointed to by superblock (No change needed): blocknr = 1088825
>     segnum = 531, seq = 837256, cno=1787400
>     creation time = 2011-01-18 23:22:07
> 
> 
> I'm pretty clueless on what to do next. Any help would be greatly appreciated!
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
