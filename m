From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix deadlock in nilfs_count_free_blocks()
Date: Sat, 29 Oct 2022 13:49:12 +0900
Message-ID: <20221029044912.9139-1-konishi.ryusuke@gmail.com>
References: <000000000000fbf46f05eb3645d0@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=euh2my+Sy+qXwfAid3AtEb0nPeWmqr+fHHInSeKPPc0=;
        b=EUB36euj9XgdqD9PfFhr6RPcN0XLaM9nL58cjW4OidgmsavA6U7bO4E3/PbC7zIXpY
         b1XYr0B2wA7Qjh9wBE0w3xb5+/STwpPfWoxDXM/Vmak3RC31Un265kFVreu2+qUWPyd4
         GCRBgPjqT12EzMLX1DRZzY5Munjeg7hJCseU7/S2QDgvxQ/RZ5iHGnf+B+y9ZBv1RKa7
         +p/gNUWmM3wlS7hcO6LRVybjqmVq1gFt9P7RbKEIkkvcj95RGdFQoB8ey+wTpFGjuEtO
         81O5QknK0M34Mr3Z2eSWThmDTSK0CSL0AgknRtmMGkQ/ucTHtluPySLXjnhgRZHb4MBr
         ucxg==
In-Reply-To: <000000000000fbf46f05eb3645d0-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+45d6ce7b7ad7ef455d03-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

A semaphore deadlock can occur if nilfs_get_block() detects metadata
corruption while locating data blocks and a superblock writeback
occurs at the same time:

task 1                               task 2
------                               ------
* A file operation *
nilfs_truncate()
  nilfs_get_block()
    down_read(rwsem A) <--
    nilfs_bmap_lookup_contig()
      ...                            generic_shutdown_super()
                                       nilfs_put_super()
                                         * Prepare to write superblock *
                                         down_write(rwsem B) <--
                                         nilfs_cleanup_super()
      * Detect b-tree corruption *         nilfs_set_log_cursor()
      nilfs_bmap_convert_error()             nilfs_count_free_blocks()
        __nilfs_error()                        down_read(rwsem A) <--
          nilfs_set_error()
            down_write(rwsem B) <--

                           *** DEADLOCK ***

Here, nilfs_get_block() readlocks rwsem A (= NILFS_MDT(dat_inode)->mi_sem)
and then calls nilfs_bmap_lookup_contig(), but if it fails due to metadata
corruption, __nilfs_error() is called from nilfs_bmap_convert_error()
inside the lock section.

Since __nilfs_error() calls nilfs_set_error() unless the filesystem is
read-only and nilfs_set_error() attempts to writelock rwsem B
(= nilfs->ns_sem) to write back superblock exclusively, hierarchical lock
acquisition occurs in the order rwsem A -> rwsem B.

Now, if another task starts updating the superblock, it may writelock
rwsem B during the lock sequence above, and can deadlock trying to
readlock rwsem A in nilfs_count_free_blocks().

However, there is actually no need to take rwsem A in
nilfs_count_free_blocks() because it, within the lock section, only
reads a single integer data on a shared struct with
nilfs_sufile_get_ncleansegs().  This has been the case after
commit aa474a220180 ("nilfs2: add local variable to cache the number
of clean segments"), that is, even before this bug was introduced.

So, this resolves the deadlock problem by just not taking the
semaphore in nilfs_count_free_blocks().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+45d6ce7b7ad7ef455d03-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: e828949e5b42 ("nilfs2: call nilfs_error inside bmap routines")
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v2.6.38+
---
 fs/nilfs2/the_nilfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 3b4a079c9617..c8b89b4f94e0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -690,9 +690,7 @@ int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
 {
 	unsigned long ncleansegs;
 
-	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
-	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
 	return 0;
 }
-- 
2.34.1

