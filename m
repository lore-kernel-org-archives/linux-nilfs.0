From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix a wrong type conversion in nilfs_ioctl()
Date: Wed, 31 Mar 2010 15:41:00 +0800
Message-ID: <20100331074100.GA11787@xhl>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:cc:subject
         :message-id:mail-followup-to:mime-version:content-type
         :content-disposition:x-operating-system:user-agent;
        bh=xmhywPi5k/yDH8lor1dLPBz5lHb2L5/dwyzdkKNOxCU=;
        b=Cqi/sqFhI79aS1sIPPFDtdtu0vTST27lhnm+oKfEy4oHADXbgM/A8FLcxV8H53RAG1
         I/II2mJIUcklqUqWt8FU0DaAYRgenG7xXWpxpMQmVEJRd0SLl6MgNexkOZTtM8D5D1gm
         vf8lrcwOgrB8uRtOX5xmnYYyHFWBXQFuJcrMI=
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(void * __user *) should be (void __user *)

Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 313d0a2..c446017 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -648,7 +648,7 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
-	void __user *argp = (void * __user *)arg;
+	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
 	case NILFS_IOCTL_CHANGE_CPMODE:
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
