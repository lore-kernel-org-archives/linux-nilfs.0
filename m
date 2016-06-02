From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 7/8] nilfs2: do not use yield()
Date: Thu,  2 Jun 2016 22:58:10 +0900
Message-ID: <1464875891-5443-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=U+Lzv1u09OG6AnjwwfqIYrKx0mt/JUiguaUoAXTCSNA=;
        b=R17m4s+MoDjq8gIMwDYFUVI0i9sBv4DKFzBRuvdw4CIN0x/adrcwulfsPq4T56fy1+
         kAV5FnQFcnUMZLhH0iNco36iudZifITP8A0+1Q3oIMOZqSdurQFv40Cq9iA0Hkglxm5T
         0eH9x7/vdJX1WD2uSRp8H1ZpK0R1ioSrnhCD+Zqrf4WDkZ4+6zJfoOlI4DdhwG5nTsmW
         022FksuESKqdlurV7fegQ5F+fLAdP029ln9dYZf0ErZRh01L13ZKTMH/LfLYF4Rj2/LX
         pxAxZIfVRAqwR4NeVwt1dajADIERBNq69TdmSbEPJnqC7+KwmDCjZL4DqOJH9t6E/SRy
         citw==
In-Reply-To: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Use cond_resched() instead of yield() in the loop of
nilfs_transaction_lock() since the usage corresponds to the "be nice
for others" case that the comment of yield() says.

This removes the following checkpatch.pl warning:

 "WARNING: Using yield() is generally wrong. See yield() kernel-doc
  (sched/core.c)"

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 7e1864c..5a97282 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -373,7 +373,7 @@ static void nilfs_transaction_lock(struct super_block *sb,
 		nilfs_segctor_do_immediate_flush(sci);
 
 		up_write(&nilfs->ns_segctor_sem);
-		yield();
+		cond_resched();
 	}
 	if (gcflag)
 		ti->ti_flags |= NILFS_TI_GC;
-- 
1.8.3.1

