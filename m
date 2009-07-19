From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: clean up nilfs_write_super
Date: Sun, 19 Jul 2009 14:26:21 +0900
Message-ID: <1247981182-14831-3-git-send-email-jir@unicus.jp>
References: <1247981182-14831-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1247981182-14831-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Separated conditions to check if syncing super block and alternative
super block are required as inline functions to reuse the conditions.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/super.c     |    9 +++------
 fs/nilfs2/the_nilfs.h |   12 ++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index ba69601..d85b360 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -368,17 +368,14 @@ static void nilfs_write_super(struct super_block *sb)
 
 	down_write(&nilfs->ns_sem);
 	if (!(sb->s_flags & MS_RDONLY)) {
-		struct nilfs_super_block **sbp = nilfs->ns_sbp;
 		u64 t = get_seconds();
-		int dupsb;
 
-		if (!nilfs_discontinued(nilfs) && t >= nilfs->ns_sbwtime[0] &&
-		    t < nilfs->ns_sbwtime[0] + NILFS_SB_FREQ) {
+		if (!nilfs_discontinued(nilfs) &&
+		    !nilfs_sb_need_update(nilfs, t)) {
 			up_write(&nilfs->ns_sem);
 			return;
 		}
-		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
-		nilfs_commit_super(sbi, dupsb);
+		nilfs_commit_super(sbi, nilfs_altsb_need_update(nilfs, t));
 	}
 	sb->s_dirt = 0;
 	up_write(&nilfs->ns_sem);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index e8adbff..0a77fb5 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -202,6 +202,18 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
 #define NILFS_SB_FREQ		10
 #define NILFS_ALTSB_FREQ	60  /* spare superblock */
 
+static inline int nilfs_sb_need_update(struct the_nilfs *nilfs, u64 t)
+{
+	return t < nilfs->ns_sbwtime[0] ||
+		 t > nilfs->ns_sbwtime[0] + NILFS_SB_FREQ;
+}
+
+static inline int nilfs_altsb_need_update(struct the_nilfs *nilfs, u64 t)
+{
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	return sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
+}
+
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
 struct the_nilfs *find_or_create_nilfs(struct block_device *);
 void put_nilfs(struct the_nilfs *);
-- 
1.5.6.5
