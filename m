From: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH]nilfs2: Don't load/check invalid cno
Date: Mon, 27 Jul 2009 17:25:07 +0800
Message-ID: <4A6D7273.5010906@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Cc: qiang.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanhai.zhu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

nilfs2: Don't load/check cp block if specified cno is larger than the
largest exist one.
nilfs2 would load invalid cp block, and report random inconsistent error
message under this situation before.

Signed-off-by: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 fs/nilfs2/cpfile.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index aec942c..43978a9 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -814,9 +814,10 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
 	struct nilfs_checkpoint *cp;
 	void *kaddr;
 	int ret;
-
-	if (cno == 0)
-		return -ENOENT; /* checkpoint number 0 is invalid */
+
+	/* return ENOENT if cno is invalid. */
+	if (cno == 0 || cno >= nilfs_mdt_cno(cpfile))
+		return -ENOENT;
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
-- 
1.6.2.2
