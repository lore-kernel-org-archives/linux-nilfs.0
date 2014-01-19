From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lib/nilfs.c: add missing initializations of ioctl arguments
Date: Mon, 20 Jan 2014 03:26:21 +0900
Message-ID: <1390155981-2985-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Some wrapper functions for ioctl APIs in libnilfs do not initialize
unused arguments passed to kernel space.  This is hurting
extensibility of these ioctls.  This fixes the issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/nilfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/nilfs.c b/lib/nilfs.c
index ebe50b8..7265830 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -448,6 +448,7 @@ int nilfs_change_cpmode(struct nilfs *nilfs, nilfs_cno_t cno, int mode)
 
 	cpmode.cm_cno = cno;
 	cpmode.cm_mode = mode;
+	cpmode.cm_pad = 0;
 	return ioctl(nilfs->n_iocfd, NILFS_IOCTL_CHANGE_CPMODE, &cpmode);
 }
 
@@ -539,6 +540,7 @@ ssize_t nilfs_get_suinfo(const struct nilfs *nilfs, __u64 segnum,
 	argv.v_base = (unsigned long)si;
 	argv.v_nmembs = nsi;
 	argv.v_size = sizeof(struct nilfs_suinfo);
+	argv.v_flags = 0;
 	argv.v_index = segnum;
 	if (ioctl(nilfs->n_iocfd, NILFS_IOCTL_GET_SUINFO, &argv) < 0)
 		return -1;
@@ -579,6 +581,8 @@ ssize_t nilfs_get_vinfo(const struct nilfs *nilfs,
 	argv.v_base = (unsigned long)vinfo;
 	argv.v_nmembs = nvi;
 	argv.v_size = sizeof(struct nilfs_vinfo);
+	argv.v_flags = 0;
+	argv.v_index = 0;
 	if (ioctl(nilfs->n_iocfd, NILFS_IOCTL_GET_VINFO, &argv) < 0)
 		return -1;
 	return argv.v_nmembs;
@@ -603,6 +607,8 @@ ssize_t nilfs_get_bdescs(const struct nilfs *nilfs,
 	argv.v_base = (unsigned long)bdescs;
 	argv.v_nmembs = nbdescs;
 	argv.v_size = sizeof(struct nilfs_bdesc);
+	argv.v_flags = 0;
+	argv.v_index = 0;
 	if (ioctl(nilfs->n_iocfd, NILFS_IOCTL_GET_BDESCS, &argv) < 0)
 		return -1;
 	return argv.v_nmembs;
@@ -636,6 +642,7 @@ int nilfs_clean_segments(struct nilfs *nilfs,
 		return -1;
 	}
 
+	memset(argv, 0, sizeof(argv));
 	argv[0].v_base = (unsigned long)vdescs;
 	argv[0].v_nmembs = nvdescs;
 	argv[0].v_size = sizeof(struct nilfs_vdesc);
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
