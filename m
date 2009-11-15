From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 22/23] nilfs2: add palloc cache to ifile
Date: Sun, 15 Nov 2009 21:47:00 +0900
Message-ID: <1258289221-3827-23-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds the palloc cache to ifile.  The palloc cache is allocated on
the extended region of nilfs_mdt_info struct.  The struct
nilfs_ifile_info defines the extended on memory structure of ifile.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ifile.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index c1c1fd3..922d9dd 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -29,6 +29,17 @@
 #include "alloc.h"
 #include "ifile.h"
 
+
+struct nilfs_ifile_info {
+	struct nilfs_mdt_info mi;
+	struct nilfs_palloc_cache palloc_cache;
+};
+
+static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
+{
+	return (struct nilfs_ifile_info *)NILFS_MDT(ifile);
+}
+
 /**
  * nilfs_ifile_create_inode - create a new disk inode
  * @ifile: ifile inode
@@ -159,13 +170,16 @@ struct inode *nilfs_ifile_new(struct nilfs_sb_info *sbi, size_t inode_size)
 	struct inode *ifile;
 	int err;
 
-	ifile = nilfs_mdt_new(sbi->s_nilfs, sbi->s_super, NILFS_IFILE_INO, 0);
+	ifile = nilfs_mdt_new(sbi->s_nilfs, sbi->s_super, NILFS_IFILE_INO,
+			      sizeof(struct nilfs_ifile_info));
 	if (ifile) {
 		err = nilfs_palloc_init_blockgroup(ifile, inode_size);
 		if (unlikely(err)) {
 			nilfs_mdt_destroy(ifile);
 			return NULL;
 		}
+		nilfs_palloc_setup_cache(ifile,
+					 &NILFS_IFILE_I(ifile)->palloc_cache);
 	}
 	return ifile;
 }
-- 
1.6.3.4
