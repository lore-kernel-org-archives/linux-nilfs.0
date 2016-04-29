From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 09/11] nilfs2: replace __attribute__((packed)) with __packed
Date: Fri, 29 Apr 2016 22:15:45 +0900
Message-ID: <1461935747-10380-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=5RU6QRNg9+5h919cIwWqf/R4cwMDHtWTLNaIgaR1TYY=;
        b=jx+VT7Fbzzoxpe1Ec9fsA3oNe0Ls4mE8ltCMgQyIwnh2/1YpOO7nnYZ0yszoa9PeN7
         Lr05JoWkL6YogdG4FYcwWautyzB/9LPuD/Tcweip520C4Lq5vkoD5ekxtT88QnJtEYtQ
         oph7oe+zx9EoMsi0qIn04KOWu0AcXxK+CLWYWMWFASjYitEYzGbbwT3R3FW/MaRLagpK
         YX6ap3RYsWKUzfBSA4M/YVOGThp+xhrF+RJfUAJt2cUeSNijmTpT61RHDE3Qa8DYsE2l
         KXeAQDAxHt2htiAv27wgdwOpjp809H5Lo2yEC9PiSmRWagoCaQzXb2RvnI+C5LCLm+OD
         C/JA==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes the following checkpatch.pl warning:

  WARNING: __packed is preferred over __attribute__((packed))
  #23: FILE: export.h:23:
  +} __attribute__ ((packed));

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/export.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/export.h b/fs/nilfs2/export.h
index 19ccbf9..00107fd 100644
--- a/fs/nilfs2/export.h
+++ b/fs/nilfs2/export.h
@@ -20,6 +20,6 @@ struct nilfs_fid {
 
 	u32 parent_gen;
 	u64 parent_ino;
-} __attribute__ ((packed));
+} __packed;
 
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
