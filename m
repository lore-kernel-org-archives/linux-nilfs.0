From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/6] nilfs2: return EBUSY against delete
	request on snapshot
Date: Mon,  8 Jun 2009 15:07:15 +0900
Message-ID: <1244441239-20032-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244441239-20032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1244441239-20032-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This helps userland programs like the rmcp command to distinguish
error codes returned against a checkpoint removal request.

Previously -EPERM was returned, and not discriminable from real
permission errors.  This also allows removal of the latest checkpoint
because the deletion leads to create a new checkpoint, and thus it's
harmless for the filesystem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 93d1da0..7d49813 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -295,10 +295,6 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		return -EINVAL;
 	}
 
-	/* cannot delete the latest checkpoint */
-	if (start == nilfs_mdt_cno(cpfile) - 1)
-		return -EPERM;
-
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
 
 	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
@@ -542,20 +538,14 @@ int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
 	struct nilfs_cpinfo ci;
 	__u64 tcno = cno;
 	ssize_t nci;
-	int ret;
 
 	nci = nilfs_cpfile_do_get_cpinfo(cpfile, &tcno, &ci, sizeof(ci), 1);
 	if (nci < 0)
 		return nci;
 	else if (nci == 0 || ci.ci_cno != cno)
 		return -ENOENT;
-
-	/* cannot delete the latest checkpoint nor snapshots */
-	ret = nilfs_cpinfo_snapshot(&ci);
-	if (ret < 0)
-		return ret;
-	else if (ret > 0 || cno == nilfs_mdt_cno(cpfile) - 1)
-		return -EPERM;
+	else if (nilfs_cpinfo_snapshot(&ci))
+		return -EBUSY;
 
 	return nilfs_cpfile_delete_checkpoints(cpfile, cno, cno + 1);
 }
-- 
1.6.2
