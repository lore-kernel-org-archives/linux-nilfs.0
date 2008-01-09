From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] fix exception on snapshot mount with an
	invalid option
Date: Wed, 09 Jan 2008 11:43:52 +0900 (JST)
Message-ID: <20080109.114352.71934031.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
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
Content-Type: Text/Plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi folks,

One of my colleages found that a NULL pointer dereference BUG occurs
when trying to mount a snapshot without readonly mount option (i.e. -r).

Here is a patch to fix the problem below.
It can be applied by,

 $ cd nilfs-2.0.0-testing-8
 $ patch -p0 < patch_file

Though the bug doesn't occur for proper options, it would trouble
people trying snapshots.
I'm sorry for the inconvenience if it got you in trouble.

Regards,
Ryusuke Konishi
NILFS team.
---
Index: fs/super.c
===================================================================
--- fs.orig/super.c	2008-01-08 11:56:53.000000000 +0900
+++ fs/super.c	2008-01-08 11:57:08.000000000 +0900
@@ -1146,7 +1146,6 @@
 	sd.cno = 0;
 	sd.flags = flags;
 	if (nilfs_identify((char *)data, &sd)) {
-		close_bdev_excl(sd.bdev);
 		err = -EINVAL;
 		goto failed;
 	}
