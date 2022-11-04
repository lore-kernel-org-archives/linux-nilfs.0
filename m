From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix use-after-free bug of ns_writer on remount
Date: Fri,  4 Nov 2022 23:29:59 +0900
Message-ID: <20221104142959.28296-1-konishi.ryusuke@gmail.com>
References: <00000000000065986a05ec569d46@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/INqBg29xQCVOPRWt/oM9Rh3Qb0O2X04nJrvWO+N8bM=;
        b=PgZOfSV6WxTknTAGZqM5mLnrHQ/5stWVVX+nX4veVTwHIhzkcpwuJBpvkEqGyMfxrf
         sIPMCAPNkvOKBvfYVUO72QYWR1zYWHwjGpOkPeCZqEVX22SV1t3k5P8eNP9XZLZjaIxs
         d4m3+4gO7WHRf1ODVNNg4smpChMmIlRQxEqPIGfo+wwQq67GXWEcH6HviDe11556yrVx
         RmYyagpZaslh1vT9Bm6Alf6Gfk4B1uKIq0TrnIccUEUWQDxP9lieYhtfPtEW9/T3QT5H
         HCw/hfZwIATRfX042YM43wMROExOZfnyTb45OgGx8EJrN8Ns8Trb1HVjqW226jECOo8n
         xRDQ==
In-Reply-To: <00000000000065986a05ec569d46-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+f816fa82f8783f7a02bb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shigeru Yoshida <syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

If a nilfs2 filesystem is downgraded to read-only due to metadata
corruption on disk and is remounted read/write, or if emergency
read-only remount is performed, detaching a log writer and
synchronizing the filesystem can be done at the same time.

In these cases, use-after-free of the log writer (hereinafter
nilfs->ns_writer) can happen as shown in the scenario below:

 Task1                               Task2
 --------------------------------    ------------------------------
 nilfs_construct_segment
   nilfs_segctor_sync
     init_wait
     init_waitqueue_entry
     add_wait_queue
     schedule
                                     nilfs_remount (R/W remount case)
				       nilfs_attach_log_writer
                                         nilfs_detach_log_writer
                                           nilfs_segctor_destroy
                                             kfree
     finish_wait
       _raw_spin_lock_irqsave
         __raw_spin_lock_irqsave
           do_raw_spin_lock
             debug_spin_lock_before  <-- use-after-free

While Task1 is sleeping, nilfs->ns_writer is freed by Task2.  After
Task1 waked up, Task1 accesses nilfs->ns_writer which is already
freed.  This scenario diagram is based on the Shigeru Yoshida's post
[1].

This patch fixes the issue by not detaching nilfs->ns_writer on
remount so that this UAF race doesn't happen.  Along with this change,
this patch also inserts a few necessary read-only checks with
superblock instance where only the ns_writer pointer was used to check
if the filesystem is read-only.

Link: https://syzkaller.appspot.com/bug?id=79a4c002e960419ca173d55e863bd09e8112df8b
Link: https://lkml.kernel.org/r/20221103141759.1836312-1-syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org [1]
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+f816fa82f8783f7a02bb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Reported-by: Shigeru Yoshida <syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/segment.c | 15 ++++++++-------
 fs/nilfs2/super.c   |  2 --
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b4cebad21b48..3335ef352915 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -317,7 +317,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (!sci || !sci->sc_flush_request)
+	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2242,7 +2242,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2280,7 +2280,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2776,11 +2776,12 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem was remounted
-		 * read/write after nilfs_error degenerated it into a
-		 * read-only mount.
+		 * This happens if the filesystem is made read-only by
+		 * __nilfs_error or nilfs_remount and then remounted
+		 * read/write.  In these cases, reuse the existing
+		 * writer.
 		 */
-		nilfs_detach_log_writer(sb);
+		return 0;
 	}
 
 	nilfs->ns_writer = nilfs_segctor_new(sb, root);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index ba108f915391..6edb6e0dd61f 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1133,8 +1133,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out;
 	if (*flags & SB_RDONLY) {
-		/* Shutting down log writer */
-		nilfs_detach_log_writer(sb);
 		sb->s_flags |= SB_RDONLY;
 
 		/*
-- 
2.34.1

