From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: fix deadlock of segment constructor during recovery
Date: Tue,  3 Mar 2015 20:59:43 +0900
Message-ID: <1425383983-29404-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1425383983-29404-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=SEi9unQ3ud9bjXq8+owMhTPo2TZjoLW2Z7XjNYiJetg=;
        b=nNJHSk2xohhqqZMgR+rDZuwa/cUtCAabL8/l1ajiN5aEVcKXs64+YM7e2YKqkNjkaN
         0LTZk9+CRg+mGuU61J2uacWo++FwOccCMhXGi0RlhEZw/T3ZKLo7HJa1vPxOLwDm/3Q8
         HLQ45HL1i5miL8/j2kMNKl+11GMCnoPyj1bnkodxlspPb49H4UYto8vSaemwTFmgF6Ik
         nc3Ubv1DNxI41d3wEOz0C/qp4JCfeyBpd0NY5aj3j4IhvP+dlPBBbh9NvA63WNHRugd/
         iKhNlA/COOvIISWnn/QP4WIPXoEHAi+U/lu0pn8/GSXUFHIUgU1M8Jcl8MOFMAXSh4IR
         faIQ==
In-Reply-To: <1425383983-29404-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

According to a report from Yuxuan Shui, nilfs2 in kernel 3.19 got
stuck during recovery at mount time.  The code path that caused the
deadlock was as follows:

  nilfs_fill_super()
    load_nilfs()
      nilfs_salvage_orphan_logs()
        * Do roll-forwarding, attach segment constructor for recovery,
          and kick it.

        nilfs_segctor_thread()
          nilfs_segctor_thread_construct()
           * A lock is held with nilfs_transaction_lock()
             nilfs_segctor_do_construct()
               nilfs_segctor_drop_written_files()
                 iput()
                   iput_final()
                     write_inode_now()
                       writeback_single_inode()
                         __writeback_single_inode()
                           do_writepages()
                             nilfs_writepage()
                               nilfs_construct_dsync_segment()
                                 nilfs_transaction_lock() --> deadlock

This can happen if commit 7ef3ff2fea8b ("nilfs2: fix deadlock of
segment constructor over I_SYNC flag") is applied and roll-forward
recovery was performed at mount time.  The roll-forward recovery can
happen if datasync write is done and the file system crashes
immediately after that.  For instance, we can reproduce the issue with
the following steps:

 < nilfs2 is mounted on /nilfs (device: /dev/sdb1) >
 # dd if=/dev/zero of=/nilfs/test bs=4k count=1 && sync
 # dd if=/dev/zero of=/nilfs/test conv=notrunc oflag=dsync bs=4k
 count=1 && reboot -nfh
 < the system will immediately reboot >
 # mount -t nilfs2 /dev/sdb1 /nilfs

The deadlock occurs because iput() can run segment constructor through
writeback_single_inode() if MS_ACTIVE flag is not set on sb->s_flags.
The above commit changed segment constructor so that it calls iput()
asynchronously for inodes with i_nlink == 0, but that change was
imperfect.

This fixes the another deadlock by deferring iput() in segment
constructor even for the case that mount is not finished, that is, for
the case that MS_ACTIVE flag is not set.

Reported-by: Yuxuan Shui <yshuiv7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/segment.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 469086b..0c3f303 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1907,6 +1907,7 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 					     struct the_nilfs *nilfs)
 {
 	struct nilfs_inode_info *ii, *n;
+	int during_mount = !(sci->sc_super->s_flags & MS_ACTIVE);
 	int defer_iput = false;
 
 	spin_lock(&nilfs->ns_inode_lock);
@@ -1919,10 +1920,10 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 		brelse(ii->i_bh);
 		ii->i_bh = NULL;
 		list_del_init(&ii->i_dirty);
-		if (!ii->vfs_inode.i_nlink) {
+		if (!ii->vfs_inode.i_nlink || during_mount) {
 			/*
-			 * Defer calling iput() to avoid a deadlock
-			 * over I_SYNC flag for inodes with i_nlink == 0
+			 * Defer calling iput() to avoid deadlocks if
+			 * i_nlink == 0 or mount is not yet finished.
 			 */
 			list_add_tail(&ii->i_dirty, &sci->sc_iput_queue);
 			defer_iput = true;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
