From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 08/23] nilfs2: eliminate inlines to directly
	read/write inode of metadata files
Date: Sun, 15 Nov 2009 21:46:46 +0900
Message-ID: <1258289221-3827-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Removes two inline functions: nilfs_mdt_read_inode_direct() and
nilfs_mdt_write_inode_direct().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.h     |   17 -----------------
 fs/nilfs2/segment.c |   12 ++++++------
 2 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 3eb40e8..cd2903a 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -105,21 +105,4 @@ static inline __u64 nilfs_mdt_cno(struct inode *inode)
 #define nilfs_mdt_bgl_lock(inode, bg) \
 	(&NILFS_MDT(inode)->mi_bgl->locks[(bg) & (NR_BG_LOCKS-1)].lock)
 
-
-static inline int
-nilfs_mdt_read_inode_direct(struct inode *inode, struct buffer_head *bh,
-			    unsigned n)
-{
-	return nilfs_read_inode_common(
-		inode, (struct nilfs_inode *)(bh->b_data + n));
-}
-
-static inline void
-nilfs_mdt_write_inode_direct(struct inode *inode, struct buffer_head *bh,
-			     unsigned n)
-{
-	nilfs_write_inode_common(
-		inode, (struct nilfs_inode *)(bh->b_data + n), 1);
-}
-
 #endif /* _NILFS_MDT_H */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 6eff66a..d21179b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -974,12 +974,12 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 			      nilfs->ns_nongc_ctime : sci->sc_seg_ctime);
 	raw_sr->sr_flags = 0;
 
-	nilfs_mdt_write_inode_direct(
-		nilfs_dat_inode(nilfs), bh_sr, NILFS_SR_DAT_OFFSET(isz));
-	nilfs_mdt_write_inode_direct(
-		nilfs->ns_cpfile, bh_sr, NILFS_SR_CPFILE_OFFSET(isz));
-	nilfs_mdt_write_inode_direct(
-		nilfs->ns_sufile, bh_sr, NILFS_SR_SUFILE_OFFSET(isz));
+	nilfs_write_inode_common(nilfs_dat_inode(nilfs), (void *)raw_sr +
+				 NILFS_SR_DAT_OFFSET(isz), 1);
+	nilfs_write_inode_common(nilfs->ns_cpfile, (void *)raw_sr +
+				 NILFS_SR_CPFILE_OFFSET(isz), 1);
+	nilfs_write_inode_common(nilfs->ns_sufile, (void *)raw_sr +
+				 NILFS_SR_SUFILE_OFFSET(isz), 1);
 }
 
 static void nilfs_redirty_inodes(struct list_head *head)
-- 
1.6.3.4
