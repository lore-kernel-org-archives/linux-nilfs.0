From: Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: corrupted filesystem (again!)
Date: Sat, 29 Jan 2011 15:06:03 -0800
Message-ID: <AANLkTimZ6qXBwF0zYquz5Yep_x0zbCbNgcTCW7sTCs0U@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:date:message-id:subject:from:to
         :content-type;
        bh=luXELOtGNF6OTw+b2w74sYkoOT0/UkaN/qtBFYZLsmw=;
        b=g+qZ1n1Y+QNEEYws3VSqWjlOdkbWxjrz3CwCDX8uxvzrRaWRnXD3qzuJjKCoIzvIGr
         WeYJEf9fxaqUO7lsxnq/Fqnkd4GO6GNIPRdIK1UrMQy+uFGmQFkYqPC14iJRMdtfDZ0y
         nd67grWgePZHF+ZqmpINeF5FISsmWt1x501IQ=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

If my memory serves me right, this is the 4th time I've had corrupted
filesystem after using nilfs2 for almost 2 years. With help from the
list, I've managed to recover every time! A big thank you to the
everyone who helped! Let's see if this time I have any luck.

When I first noticed something wrong with the file system, command 'ls
-l' would list some files with outrageously big size, like 20 digits
or something. I don't remember doing any particular task before I
noticed this. So I thought I would just reboot and see if things come
back normal.

After a reboot, the disk failed to mount. That was almost two weeks
ago, and I was using 2.0.20. I didn't do anything further except
backing up the entire disk data.

Today I had a little more time and decided to upgrade to
nilfs2-2.0.21, and still the same. Here is what dmesg showed me when I
mount the file system (after I turned on CONFIG_NILFS_DEBUG and "echo
'-vvv recovery' > /proc/fs/nilfs2/debug_option"):


NILFS nilfs_fill_super: start(silent=0)
NILFS warning: broken superblock. using spare superblock.
NILFS warning: broken superblock. using spare superblock.
NILFS(recovery) nilfs_search_super_root: looking segment
(seg_start=1087488, seg_end=1089535, segnum=531, seg_seq=837256)
NILFS(recovery) load_segment_summary: checking segment
(pseg_start=1088825, full_check=1)
NILFS(recovery) load_segment_summary: done (ret=0)
NILFS(recovery) nilfs_search_super_root: found super root: segnum=531,
seq=837256, pseg_start=1088825, pseg_offset=1396
segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
NILFS(dat) nilfs_dat_translate: failed (ret=-2)
NILFS warning (device mmcblk0p1): nilfs_ifile_get_inode_block: unable
to read inode: 2
NILFS: get root inode failed
NILFS(segment) nilfs_segctor_thread: segctord exiting.
NILFS nilfs_fill_super: aborted
NILFS put_nilfs: the_nilfs on bdev mmcblk0p1 was freed


Apparently, it was trying to use the spare superblock, but still
couldn't find the root inode.

I also tried the fsck0.niilfs2 utility from nilfs-utils-2.0.18. It
didn't help either. Here is the output:


Super-block:
    revision = 2.0
    blocksize = 4096
    write time = 2011-01-18 23:22:07
    indicated log: blocknr = 1088825
        segnum = 531, seq = 837256, cno=1787400

Clean FS.
A valid log is pointed to by superblock (No change needed): blocknr = 1088825
    segnum = 531, seq = 837256, cno=1787400
    creation time = 2011-01-18 23:22:07


I'm pretty clueless on what to do next. Any help would be greatly appreciated!

-- 
Regards,
Paul Liu
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
