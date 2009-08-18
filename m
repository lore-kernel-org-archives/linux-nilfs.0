From: Zhang Qiang <zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH]nilfs2:missing a read lock for segment writer
	in nilfs_attach_checkpoint()
Date: Tue, 18 Aug 2009 14:58:24 +0800
Message-ID: <4A8A5110.6080806@gmail.com>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Zhang Qiang <qiang.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhu Yanhai <yanhai.zhu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

'ns_cno' of structure 'the_nilfs' must be protected from segment writer, in other words, 
the caller of nilfs_get_check_point should hold read lock for nilfs->ns_segctor_sem. 
This patch adds the lock/unlock operations in nilfs_attach_checkpoint() when calling 
nilfs_cpfile_get_checkpoint().

Signed-off-by: Zhang Qiang <zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 fs/nilfs2/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 05174c5..55f3d6b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -371,8 +371,10 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	if (unlikely(err))
 		goto failed;
 
+	down_read(&nilfs->ns_segctor_sem);
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
 					  &bh_cp);
+	up_read(&nilfs->ns_segctor_sem);
 	if (unlikely(err)) {
 		if (err == -ENOENT || err == -EINVAL) {
 			printk(KERN_ERR
-- 
1.6.0.6
