From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: deleted struct
	nilfs_dat_group_desc
Date: Sun, 15 Nov 2009 13:49:44 +0900
Message-ID: <1258260585-3479-2-git-send-email-jir@unicus.jp>
References: <1258260585-3479-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258260585-3479-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

struct nilfs_dat_group_desc is not used both in kernel and user spaces.
struct nilfs_palloc_group_desc is used instead.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 include/linux/nilfs2_fs.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 3c92223..56e5714 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -425,15 +425,6 @@ struct nilfs_dat_entry {
 };
 
 /**
- * struct nilfs_dat_group_desc - block group descriptor
- * @dg_nfrees: number of free virtual block numbers in block group
- */
-struct nilfs_dat_group_desc {
-	__le32 dg_nfrees;
-};
-
-
-/**
  * struct nilfs_snapshot_list - snapshot list
  * @ssl_next: next checkpoint number on snapshot list
  * @ssl_prev: previous checkpoint number on snapshot list
-- 
1.5.6.5
