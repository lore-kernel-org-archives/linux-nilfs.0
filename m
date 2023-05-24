From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix possible out-of-bounds segment allocation in resize ioctl
Date: Wed, 24 May 2023 18:43:48 +0900
Message-ID: <20230524094348.3784-1-konishi.ryusuke@gmail.com>
References: <0000000000005434c405fbbafdc5@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684921450; x=1687513450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwdYQx8FcXFV0J8oDNY/gZUVBoAXgW87pt+1+NvkXAw=;
        b=b1/obuKfWcYZskj6Rc4AdZaTyvTCf9MxLyeApNb1hkqVz1FePSBrjH7ZWnp+6ETncM
         gWthai388O2oeNLLGPc2kK/XDvK078yjSnjFOuS+A8sVsa5doAIWhdJrZoOAW0KfrAo9
         bD4GxQSWNVUBZRTdoUJgmkkY/pNh2tRWyEJfmK9f4DzkUtf0ZjRJDqqPzAy/xvvCyed7
         rmRPS9bNZQQZUVrZiz8N2KoxHQAhYXySH4hykWsaNdgFHKnC0TL9sm2wg+d6WCMpMEzE
         QWTDr7Udwh+QaNMkXeGh9QTo7E5IYh23CMf10Y8fm0ofyf5qWXOeIxI7o6vlMXUpl8cv
         q+pQ==
In-Reply-To: <0000000000005434c405fbbafdc5-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+33494cd0df2ec2931851-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Syzbot reports that in its stress test for resize ioctl, the log writing
function nilfs_segctor_do_construct hits a WARN_ON in
nilfs_segctor_truncate_segments().

It turned out that there is a problem with the current implementation of
the resize ioctl, which changes the writable range on the device
(the range of allocatable segments) at the end of the resize process.

This order is necessary for file system expansion to avoid corrupting
the superblock at trailing edge.  However, in the case of a file system
shrink, if log writes occur after truncating out-of-bounds trailing
segments and before the resize is complete, segments may be allocated
from the truncated space.

The userspace resize tool was fine as it limits the range of allocatable
segments before performing the resize, but it can run into this issue if
the resize ioctl is called alone.

Fix this issue by changing nilfs_sufile_resize() to update the range of
allocatable segments immediately after successful truncation of segment
space in case of file system shrink.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+33494cd0df2ec2931851-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Closes: https://lkml.kernel.org/r/0000000000005434c405fbbafdc5-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Fixes: 4e33f9eab07e ("nilfs2: implement resize ioctl")
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/sufile.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index dc359b56fdfa..2c6078a6b8ec 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -779,6 +779,15 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 			goto out_header;
 
 		sui->ncleansegs -= nsegs - newnsegs;
+
+		/*
+		 * If the sufile is successfully truncated, immediately adjust
+		 * the segment allocation space while locking the semaphore
+		 * "mi_sem" so that nilfs_sufile_alloc() never allocates
+		 * segments in the truncated space.
+		 */
+		sui->allocmax = newnsegs - 1;
+		sui->allocmin = 0;
 	}
 
 	kaddr = kmap_atomic(header_bh->b_page);
-- 
2.34.1

