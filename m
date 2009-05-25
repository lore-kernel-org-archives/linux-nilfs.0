From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 02/17] nilfs2: remove nilfs_dat_prepare_free
	function
Date: Mon, 25 May 2009 19:18:06 +0900
Message-ID: <1243246701-5193-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1243246701-5193-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1243246701-5193-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This function is unused.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dat.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index bb8a581..1827f62 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -92,21 +92,6 @@ void nilfs_dat_abort_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 	nilfs_palloc_abort_alloc_entry(dat, req);
 }
 
-int nilfs_dat_prepare_free(struct inode *dat, struct nilfs_palloc_req *req)
-{
-	int ret;
-
-	ret = nilfs_palloc_prepare_free_entry(dat, req);
-	if (ret < 0)
-		return ret;
-	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	if (ret < 0) {
-		nilfs_palloc_abort_free_entry(dat, req);
-		return ret;
-	}
-	return 0;
-}
-
 void nilfs_dat_commit_free(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	struct nilfs_dat_entry *entry;
-- 
1.6.2
