From: Artem Bityutskiy <dedekind@infradead.org>
Subject: [PATCH v2 11/17] NILFS: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:48 +0300
Message-ID: <1244112114-23144-12-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, users@nilfs.org, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: users@nilfs.org
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segment.c   |    2 +-
 fs/nilfs2/super.c     |   18 +++++++++---------
 fs/nilfs2/the_nilfs.c |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index fb70ec3..0dcac79 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2069,7 +2069,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	if (update_sr) {
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
-		sbi->s_super->s_dirt = 1;
+		mark_sb_dirty(sbi->s_super);
 
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7262e84..6f3707b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -307,7 +307,7 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 		nilfs->ns_sbwtime[1] = t;
 	}
-	sbi->s_super->s_dirt = 0;
+	mark_sb_clean(sbi->s_super);
 	return nilfs_sync_super(sbi, dupsb);
 }
 
@@ -318,7 +318,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		nilfs_write_super(sb);
 
 	nilfs_detach_segment_constructor(sbi);
@@ -344,17 +344,17 @@ static void nilfs_put_super(struct super_block *sb)
  * @sb: super_block
  *
  * nilfs_write_super() gets a fs-dependent lock, writes super block(s), and
- * clears s_dirt.  This function is called in the section protected by
- * lock_super().
+ * clears the superblock.  This function is called in the section protected
+ * by lock_super().
  *
- * The s_dirt flag is managed by each filesystem and we protect it by ns_sem
- * of the struct the_nilfs.  Lock order must be as follows:
+ * The super block s_dirt flag is managed by each filesystem and we protect
+ * it by ns_sem of the struct the_nilfs.  Lock order must be as follows:
  *
  *   1. lock_super()
  *   2.    down_write(&nilfs->ns_sem)
  *
- * Inside NILFS, locking ns_sem is enough to protect s_dirt and the buffer
- * of the super block (nilfs->ns_sbp[]).
+ * Inside NILFS, locking ns_sem is enough to protect the super block s_dirt
+ * and the buffer of the super block (nilfs->ns_sbp[]).
  *
  * In most cases, VFS functions call lock_super() before calling these
  * methods.  So we must be careful not to bring on deadlocks when using
@@ -383,7 +383,7 @@ static void nilfs_write_super(struct super_block *sb)
 		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
 		nilfs_commit_super(sbi, dupsb);
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	up_write(&nilfs->ns_sem);
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7f65b3b..5b02f50 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -278,7 +278,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto failed;
 		}
 		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
-			sbi->s_super->s_dirt = 1;
+			mark_sb_dirty(sbi->s_super);
 	}
 
 	set_nilfs_loaded(nilfs);
-- 
1.6.0.6

