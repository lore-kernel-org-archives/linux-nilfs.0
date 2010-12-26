From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/6] nilfs2: get rid of loaded flag from nilfs object
Date: Mon, 27 Dec 2010 01:02:38 +0900
Message-ID: <1293379362-3340-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1293379362-3340-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293379362-3340-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

NILFS_LOADED flag of the nilfs object is not used now, so this will
remove it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    1 -
 fs/nilfs2/the_nilfs.h |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 0254be2..95e4443 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -329,7 +329,6 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	printk(KERN_INFO "NILFS: recovery complete.\n");
 
  skip_recovery:
-	set_nilfs_loaded(nilfs);
 	nilfs_clear_recovery_info(&ri);
 	sbi->s_super->s_flags = s_flags;
 	return 0;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 69226e1..fd85e4c 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -36,8 +36,6 @@
 /* the_nilfs struct */
 enum {
 	THE_NILFS_INIT = 0,     /* Information from super_block is set */
-	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
-				   the latest checkpoint was loaded */
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
 	THE_NILFS_GC_RUNNING,	/* gc process is running */
 	THE_NILFS_SB_DIRTY,	/* super block is dirty */
@@ -178,7 +176,6 @@ static inline int nilfs_##name(struct the_nilfs *nilfs)			\
 }
 
 THE_NILFS_FNS(INIT, init)
-THE_NILFS_FNS(LOADED, loaded)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
 THE_NILFS_FNS(SB_DIRTY, sb_dirty)
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
