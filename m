From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/7] nilfs2: fix code indent coding style issue
Date: Tue, 10 May 2016 22:24:27 +0900
Message-ID: <1462886671-3521-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=yEjYVUuvv8Ss9oJTGqd3MYGAQhyZkgHizv/1Kr6C0f4=;
        b=Hd63LispuP9DwOQKMO7Xygc2OTBwD55Bai8PJZMpgv9T5W1bZ+wjiXp6G8G0Quml9H
         GPydtQivUdm2D+XUKBLoVrA2UBa9hELVgWpq0JOKFdnSU6s2x3kO48DmdlkmJMBCvo1Z
         TD78S19grq2gDWpE8bvF+2lWTdVa4phrz5USznujATiiEjBM1Wf8iFzTeVjYH4wis3sB
         q2Jn7w8r3P0FyGxb/7KAFy+GZD7IP4T2XNrWyKz7WT84on63DKQyoxnxKYoc2Lp2HIal
         qdUYQZgj4ep5tcJUn7WaJLG4NlDTpfERqIWWSXK+PPMkb5WvirTs5ClWJ9zJ7inptWum
         fV4w==
In-Reply-To: <1462886671-3521-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes checkpatch.pl warning "WARNING: suspect code indent for
conditional statements".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0271784..666107a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -273,7 +273,7 @@ struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
 		}
 	} else if (sbp[1] &&
 		   sbp[1]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
-			memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 	}
 
 	if (flip && sbp[1])
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
