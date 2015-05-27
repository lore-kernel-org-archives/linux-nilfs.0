From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/1] NILFS2: support NFSv2 export
Date: Wed, 27 May 2015 14:22:33 +0900
Message-ID: <1432704153-18897-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1432704153-18897-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=WcuYPSHoG5ZPxrZ7RiMNexLb6WK9ZXbM+/5D+LCO6dk=;
        b=p56F5+zjrQBIazNNBtC5oNV7cuscHxfVngayh1x628YyKHsl94lWpNE2ubB24sHkQk
         df1n1uAzcHKBbH1J0YM0F8HfIlbn0HnUlv9HEX6QNc4HrQ9UwlLuugREI/fpExU6aiJy
         q/Tbd2+5PSurbszYZGLfvE9uvRqz9BHQo/xoZtzBX/c6+e4zfPP9Lo6f686Tr+6lZTTB
         NwHFhbFcYtxXWDWlPvibnsIHec1muDDZJ7b/gBO6qabFJWmV2KezyoZFPl9vCSxteHrj
         niCqTmvBOUueVSCT1clCxogyNp+XgANixBAc/LsOT6Gwe5axeMbJB6w9t3W9xubExB6F
         RUMA==
In-Reply-To: <1432704153-18897-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

The "fh_len" passed to ->fh_to_* is not guaranteed to be that same as
that returned by encode_fh - it may be larger.

With NFSv2, the filehandle is fixed length, so it may appear longer
than expected and be zero-padded.

So we must test that fh_len is at least some value, not exactly equal
to it.

Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/namei.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 2218083..37dd6b0 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -496,8 +496,7 @@ static struct dentry *nilfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 {
 	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
 
-	if ((fh_len != NILFS_FID_SIZE_NON_CONNECTABLE &&
-	     fh_len != NILFS_FID_SIZE_CONNECTABLE) ||
+	if (fh_len < NILFS_FID_SIZE_NON_CONNECTABLE ||
 	    (fh_type != FILEID_NILFS_WITH_PARENT &&
 	     fh_type != FILEID_NILFS_WITHOUT_PARENT))
 		return NULL;
@@ -510,7 +509,7 @@ static struct dentry *nilfs_fh_to_parent(struct super_block *sb, struct fid *fh,
 {
 	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
 
-	if (fh_len != NILFS_FID_SIZE_CONNECTABLE ||
+	if (fh_len < NILFS_FID_SIZE_CONNECTABLE ||
 	    fh_type != FILEID_NILFS_WITH_PARENT)
 		return NULL;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
