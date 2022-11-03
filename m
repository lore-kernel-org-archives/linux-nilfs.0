From: Shigeru Yoshida <syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] nilfs: Avoid use-after-free caused by nilfs->ns_writer
Date: Thu,  3 Nov 2022 23:17:59 +0900
Message-ID: <20221103141759.1836312-1-syoshida@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667485089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7sFhbFjsyed+EphiRBlueeREBkJAs1QiqobCz6ZZTfY=;
        b=K+WxXayITKcz2e4xpEGpZZr1+QLKsNauZ4S7CS+kiOfMxUimslN9BX8wZ/PfRG/rU2kbk2
        QeBwQ0fCY0TxqT7banXultIFaFovdEsEC1Fey0kaRaA7ztxlFXkUhALoQpoKJ3EGCPAzdJ
        R+TH1gIjGBrqND75cK9FoS9HvIGcesg=
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Shigeru Yoshida <syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, syzbot+f816fa82f8783f7a02bb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

syzbot reported use-after-free in nilfs_segctor_sync() [1].

The use-after-free occurs with nilfs->ns_writer.  The scenario for the
issue is as follows:

Task1                                   Task2
----------------------------------------------------------------------
nilfs_construct_segment
  nilfs_segctor_sync
    init_wait
    init_waitqueue_entry
    add_wait_queue
    schedule
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
freed.

This patch fixes the issue by taking nilfs->ns_segctor_sem in
nilfs_construct_segment() so that nilfs->ns_segctor_sem cannot be
freed while nilfs_segctor_sync() is sleeping.

Link: https://syzkaller.appspot.com/bug?id=79a4c002e960419ca173d55e863bd09e8112df8b [1]
Reported-by: syzbot+f816fa82f8783f7a02bb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Signed-off-by: Shigeru Yoshida <syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/nilfs2/segment.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b4cebad21b48..d4f10d82664d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2239,16 +2239,24 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
 int nilfs_construct_segment(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
-	struct nilfs_sc_info *sci = nilfs->ns_writer;
+	struct nilfs_sc_info *sci;
 	struct nilfs_transaction_info *ti;
+	int ret;
 
-	if (!sci)
+	down_write(&nilfs->ns_segctor_sem);
+	sci = nilfs->ns_writer;
+	if (!sci) {
+		up_write(&nilfs->ns_segctor_sem);
 		return -EROFS;
+	}
 
 	/* A call inside transactions causes a deadlock. */
 	BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
 
-	return nilfs_segctor_sync(sci);
+	ret = nilfs_segctor_sync(sci);
+	up_write(&nilfs->ns_segctor_sem);
+
+	return ret;
 }
 
 /**
-- 
2.37.3

