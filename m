From: Zhang Qiang <zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH]nilfs2: An unassigned variable is assigned to
 a never used structure member
Date: Sun, 09 Aug 2009 19:13:10 +0800
Message-ID: <4A7EAF46.6090302@gmail.com>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: Zhang Qiang <qiang.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhu Yanhai <yanhai.zhu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

nilfs2: In procedure 'nilfs_get_sb()', when a nilfs filesysttem is mounted for the first time, local variable 'nilfs->ns_last_cno' is used before loading the latest checkpoint number from disk (in 'nilfs_fill_super'). 'nilfs->ns_last_cno' is assigned to 'sd.cno', but 'sd.cno' has never been used in the procedure.
 
Signed-off-by: Zhang Qiang <zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 fs/nilfs2/super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8e2ec43..d8bfcfd 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1125,10 +1125,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	 */
 	sd.sbi = nilfs_find_sbinfo(nilfs, !(flags & MS_RDONLY), sd.cno);
 
-	if (!sd.cno)
-		/* trying to get the latest checkpoint.  */
-		sd.cno = nilfs_last_cno(nilfs);
-
 	/*
 	 * Get super block instance holding the nilfs_sb_info struct.
 	 * A new instance is allocated if no existing mount is present or
-- 
1.6.0.6
