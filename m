From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/7] nilfs2: remove nilfs_dat_abort_start and
	nilfs_dat_abort_free
Date: Sun, 16 Aug 2009 15:51:04 +0900
Message-ID: <1250405470-23326-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1250405470-23326-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1250405470-23326-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

These functions are not called from any functions.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dat.c |   11 -----------
 fs/nilfs2/dat.h |    1 -
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 8927ca2..1cfcc1a 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -109,12 +109,6 @@ void nilfs_dat_commit_free(struct inode *dat, struct nilfs_palloc_req *req)
 	nilfs_palloc_commit_free_entry(dat, req);
 }
 
-void nilfs_dat_abort_free(struct inode *dat, struct nilfs_palloc_req *req)
-{
-	nilfs_dat_abort_entry(dat, req);
-	nilfs_palloc_abort_free_entry(dat, req);
-}
-
 int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	int ret;
@@ -140,11 +134,6 @@ void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
 	nilfs_dat_commit_entry(dat, req);
 }
 
-void nilfs_dat_abort_start(struct inode *dat, struct nilfs_palloc_req *req)
-{
-	nilfs_dat_abort_entry(dat, req);
-}
-
 int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	struct nilfs_dat_entry *entry;
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index d328b81..4b0b47e 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -39,7 +39,6 @@ void nilfs_dat_abort_alloc(struct inode *, struct nilfs_palloc_req *);
 int nilfs_dat_prepare_start(struct inode *, struct nilfs_palloc_req *);
 void nilfs_dat_commit_start(struct inode *, struct nilfs_palloc_req *,
 			    sector_t);
-void nilfs_dat_abort_start(struct inode *, struct nilfs_palloc_req *);
 int nilfs_dat_prepare_end(struct inode *, struct nilfs_palloc_req *);
 void nilfs_dat_commit_end(struct inode *, struct nilfs_palloc_req *, int);
 void nilfs_dat_abort_end(struct inode *, struct nilfs_palloc_req *);
-- 
1.6.3.4
