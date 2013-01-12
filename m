From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: fix very long mount time issue
Date: Sat, 12 Jan 2013 19:34:48 +0400
Message-ID: <1358004888.2130.18.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=HYhn11WeJg8JW4k/crtygM8fMyA0JGI7yR7IMoEVkzQ=;
	b=dAOSQwX1jpu/Q7+vmUdPbWUPtXyGYlL0SLW1ygFcN7U4FTiNBWS9HMpShFiJdnRbJimum46M5ak6CsioOsITWq053zPSJefNyYLPCfaTTjE3ZXIUNwBLXxcvIMtTYVJD;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: fix very long mount time issue

DESCRIPTION:
It exists situation when GC can work in background alone without any other filesystem activity during significant time. The nilfs_clean_segments() method calls nilfs_segctor_construct() that updates superblocks in the case of NILFS_SC_SUPER_ROOT and THE_NILFS_DISCONTINUED flags are set. But when GC is working alone the nilfs_clean_segments() is called with unset THE_NILFS_DISCONTINUED flag. As a result, the update of superblocks doesn't occurred all this time and in the case of SPOR superblocks keep very old values of last super root placement.

SYMPTOMS:
Trying to mount a NILFS2 volume after SPOR in such environment ends with very long mounting time (it can achieve about several hours in some cases).

REPRODUCING PATH:
1. It needs to use external USB HDD, disable automount and doesn't make any additional filesystem activity on the NILFS2 volume.
2. Generate temporary file with size about 100 - 500 GB (for example, dd if=/dev/zero of=<file_name> bs=1073741824 count=200). The size of file defines duration of GC working.
3. Then it needs to delete file.
4. Start GC manually by means of command "nilfs-clean -p 0". When you start GC by means of such way then, at the end, superblocks is updated by once. So, for simulation of SPOR, it needs to wait sometime (15 - 40 minutes) and simply switch off USB HDD manually.
5. Switch on USB HDD again and try to mount NILFS2 volume. As a result, NILFS2 volume will mount during very long time.

REPRODUCIBILITY: 100%

FIX:
This patch adds checking that superblocks need to update and set THE_NILFS_DISCONTINUED flag before nilfs_clean_segments() call.

Reported-by: Sergey Alexandrov <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index fdb1807..f385935 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -664,8 +664,11 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	if (ret < 0)
 		printk(KERN_ERR "NILFS: GC failed during preparation: "
 			"cannot read source blocks: err=%d\n", ret);
-	else
+	else {
+		if (nilfs_sb_need_update(nilfs))
+			set_nilfs_discontinued(nilfs);
 		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+	}
 
 	nilfs_remove_all_gcinodes(nilfs);
 	clear_nilfs_gc_running(nilfs);
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
