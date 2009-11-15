From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 20/23] nilfs2: add palloc cache to dat
Date: Sun, 15 Nov 2009 21:46:58 +0900
Message-ID: <1258289221-3827-21-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds the palloc cache to DAT file.  The palloc cache is allocated
on the extended region of nilfs_mdt_info struct.  The struct
nilfs_dat_info defines the extended on memory structure of DAT.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dat.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index eff3169..187dd07 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -33,6 +33,16 @@
 #define NILFS_CNO_MIN	((__u64)1)
 #define NILFS_CNO_MAX	(~(__u64)0)
 
+struct nilfs_dat_info {
+	struct nilfs_mdt_info mi;
+	struct nilfs_palloc_cache palloc_cache;
+};
+
+static inline struct nilfs_dat_info *NILFS_DAT_I(struct inode *dat)
+{
+	return (struct nilfs_dat_info *)NILFS_MDT(dat);
+}
+
 static int nilfs_dat_prepare_entry(struct inode *dat,
 				   struct nilfs_palloc_req *req, int create)
 {
@@ -445,16 +455,20 @@ struct inode *nilfs_dat_new(struct the_nilfs *nilfs, size_t entry_size)
 {
 	static struct lock_class_key dat_lock_key;
 	struct inode *dat;
+	struct nilfs_dat_info *di;
 	int err;
 
-	dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, 0);
+	dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, sizeof(*di));
 	if (dat) {
 		err = nilfs_palloc_init_blockgroup(dat, entry_size);
 		if (unlikely(err)) {
 			nilfs_mdt_destroy(dat);
 			return NULL;
 		}
-		lockdep_set_class(&NILFS_MDT(dat)->mi_sem, &dat_lock_key);
+
+		di = NILFS_DAT_I(dat);
+		lockdep_set_class(&di->mi.mi_sem, &dat_lock_key);
+		nilfs_palloc_setup_cache(dat, &di->palloc_cache);
 	}
 	return dat;
 }
-- 
1.6.3.4
