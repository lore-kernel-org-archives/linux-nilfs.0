From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch] nilfs2: nilfs_iget_for_gc() returns ERR_PTR
Date: Tue, 23 Nov 2010 09:26:02 +0300
Message-ID: <20101123062602.GG1522@bicker>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:cc:subject
         :message-id:mime-version:content-type:content-disposition:user-agent;
        bh=VvVGOPOC0CpZInuIBivMkqq3EgZNXJ6rYdrLQHLNasA=;
        b=v1r/aRMBAJSZa/S1aNBENt0hGrmlic/bu2j85VRzXGViG9D+ilOCuG+OQTnU0I5S+c
         2rVHlXSzeYK0QIKSrX+pIEWAXoCaS+0niYvoL2rbUiEWqwiTDO3PPonIP4R3q6/A10kG
         cUESTkYjkRbNqCRmTbp40nL2MgO8gQdPvSWVU=
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs_iget_for_gc() returns an ERR_PTR() on failure and doesn't return
NULL.

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 3e90f86..5bf426f 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -349,8 +349,8 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 		ino = vdesc->vd_ino;
 		cno = vdesc->vd_cno;
 		inode = nilfs_iget_for_gc(sb, ino, cno);
-		if (unlikely(inode == NULL)) {
-			ret = -ENOMEM;
+		if (unlikely(IS_ERR(inode))) {
+			ret = PTR_ERR(inode);
 			goto failed;
 		}
 		do {
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
