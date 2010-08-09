From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: insert feature compatibility check in nilfs_open
Date: Mon,  9 Aug 2010 23:39:02 +0900
Message-ID: <1281364742-4857-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This inserts compatibility check in nilfs_open function so that it
refuses to open the nilfs partition whose super block has incompatible
features that nilfs-utils doesn't know about.

It is verified only when NILFS_OPEN_RAW mode is specified.  Moreover,
only incompat feature set is tested because the current nilfs_open
doesn't open the device in read/write mode.

Programs that want to write to the nilfs partition not via io-control
must confirm read-only compat feature set as well as the incompat
feature set.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/nilfs.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/nilfs.c b/lib/nilfs.c
index 982e874..44e368b 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -281,6 +281,7 @@ int nilfs_opt_test_mmap(struct nilfs *nilfs)
 struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 {
 	struct nilfs *nilfs;
+	__u64 features;
 	int oflags;
 
 	if (!(flags & (NILFS_OPEN_RAW | NILFS_OPEN_RDONLY |
@@ -314,6 +315,13 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 			goto out_fd;
 		if (nilfs_read_sb(nilfs) < 0)
 			goto out_fd;
+
+		features = le64_to_cpu(nilfs->n_sb->s_feature_incompat) &
+			~NILFS_FEATURE_INCOMPAT_SUPP;
+		if (features) {
+			errno = ENOTSUP;
+			goto out_fd;
+		}
 	}
 
 	if (flags &
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
