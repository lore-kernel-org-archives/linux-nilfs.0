From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/4] nilfs2: add helper to get if volume is in
	a valid state
Date: Fri, 20 Nov 2009 02:09:12 +0900
Message-ID: <1258650553-10743-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258650553-10743-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258650553-10743-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds a helper function, nilfs_valid_fs() which returns if nilfs
is in a valid state or not.  This is a preparation for the successive
patch to add norepair mount option.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    6 +-----
 fs/nilfs2/the_nilfs.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index aea2b58..890a8d3 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -261,16 +261,12 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	struct nilfs_recovery_info ri;
 	unsigned int s_flags = sbi->s_super->s_flags;
 	int really_read_only = bdev_read_only(nilfs->ns_bdev);
-	unsigned valid_fs;
+	int valid_fs = nilfs_valid_fs(nilfs);
 	int err;
 
 	if (nilfs_loaded(nilfs))
 		return 0;
 
-	down_write(&nilfs->ns_sem);
-	valid_fs = (nilfs->ns_mount_state & NILFS_VALID_FS);
-	up_write(&nilfs->ns_sem);
-
 	if (!valid_fs) {
 		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
 		if (s_flags & MS_RDONLY) {
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 20abd55..589786e 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -258,6 +258,16 @@ static inline void nilfs_put_sbinfo(struct nilfs_sb_info *sbi)
 		kfree(sbi);
 }
 
+static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
+{
+	unsigned valid_fs;
+
+	down_read(&nilfs->ns_sem);
+	valid_fs = (nilfs->ns_mount_state & NILFS_VALID_FS);
+	up_read(&nilfs->ns_sem);
+	return valid_fs;
+}
+
 static inline void
 nilfs_get_segment_range(struct the_nilfs *nilfs, __u64 segnum,
 			sector_t *seg_start, sector_t *seg_end)
-- 
1.6.3.4
