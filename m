From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 4/4] nilfs2: use octal for unreadable permission macro
Date: Mon, 30 Oct 2017 21:52:15 +0900
Message-ID: <1509367935-3086-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1509367935-3086-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=AUH89S8IncksMoGtj9QqmuFndTg1S+gMirmxQREOID0=;
        b=UPXTQHWejSywpp0f3vvdRgg6iBxZWGLF9jbo5LNM9j2mqVgHh/fC/qiZV1D4VOlSSZ
         EjcDgoGpop0y7yFP0Ghqb5YCSu5tVSEvbXuaW/EM4f27OO52SmNNQ5WI7V/02P43ofyL
         vgBPxsJEEmby9Hx2f9FsxMaF54zZUU0h2hUZdTixEHosbeuBmBKn1qEa8Fp1dATSLoO3
         pcoOsgixHwwfrxN5HheQ3vDRW6cE1KCaOuRUpYnlGSptWLxQ98qyoa+bCRhOT+u6zK26
         caNjJ2kXIbhyxKuS3oiUvhHOybJSxreF36TevEhmJ4OFzHLuN5mNU9HHLfxxzV7i8wHB
         HfSA==
In-Reply-To: <1509367935-3086-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Replace S_IRWXUGO with 0777 because symbolic permissions are
considered harmful:

 https://lwn.net/Articles/696229/

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 515d13c..1a2894a 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -150,7 +150,7 @@ static int nilfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (err)
 		return err;
 
-	inode = nilfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	inode = nilfs_new_inode(dir, S_IFLNK | 0777);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out;
-- 
1.8.3.1

