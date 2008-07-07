From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: fix hang problem after rw-remount
Date: Mon, 07 Jul 2008 16:16:51 +0900 (JST)
Message-ID: <20080707.161651.71912559.ryusuke@osrg.net>
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

Dear Volkov and other folks,

I found another remount problem of NILFS2 that may be exposed when
using it for root partition.

On one of my test machines with a recent kernel, NILFS2 eventually
hung after remounting a read only filesystem to read/write mode.  Then
I found that a missing semaphore operation caused the problem.

Here I post a patch to fix the bug.  If you are bothered by that kind
of problem, try this patch please.

The patch is also available on the git tree found on
http://www.nilfs.org/git/, and will be included in the next release.

Regards,
Ryusuke Konishi

--
diff --git a/fs/super.c b/fs/super.c
index 9520efc..432910d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1093,6 +1093,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		if (err)
 			goto rw_remount_failed;
 
+		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sbi);
 		up_write(&nilfs->ns_sem);
