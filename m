From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix incomplete buffer cleanup in nilfs_btnode_abort_change_key()
Date: Sat, 13 May 2023 19:24:28 +0900
Message-ID: <20230513102428.10223-1-konishi.ryusuke@gmail.com>
References: <000000000000d1d6c205ebc4d512@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683973455; x=1686565455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdWliSyw9Vs0a4+Mx5Ea0mS03ZFAZO0XAn6m7qo+Pro=;
        b=TYUf0yciahwHAoINMlmasYHsNIj0mB0vwA8sRRG+HcY+oJopfvY6iqibdm5kAMp8xZ
         VAOmON3bpEOSXqaTShgAQEZ1330E/h/aJbAWTNo6qwReBwPbhMIBPBJp6hxxVm413onX
         zeQoRP6rUV7uzyU53vXr2GkhozaGfQ3aqBMfCwdfCubhDJis+A0ZiNjN8+Iv1gc7BabQ
         wSE1o0qu9P96h1khnyfGgq2sa2EWxfHlmm9sru/jczengeor+hZXj0Ddtl5kjiPYxNVa
         UMpgGBpOTi7S3UDhk7DLOm40xPPECl2+QAfOisqQ4tSTyAKRU0aeles6EApESs/xhbW+
         S5Pw==
In-Reply-To: <000000000000d1d6c205ebc4d512-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+b0a35a5c1f7e846d3b09-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

A syzbot fault injection test reported that nilfs_btnode_create_block,
a helper function that allocates a new node block for b-trees, causes a
kernel BUG for disk images where the file system block size is smaller
than the page size.

This was due to unexpected flags on the newly allocated buffer head, and
it turned out to be because the buffer flags were not cleared by
nilfs_btnode_abort_change_key() after an error occurred during a b-tree
update operation and the buffer was later reused in that state.

Fix this issue by using nilfs_btnode_delete() to abandon the unused
preallocated buffer in nilfs_btnode_abort_change_key().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+b0a35a5c1f7e846d3b09-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Closes: https://lkml.kernel.org/r/000000000000d1d6c205ebc4d512-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/btnode.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index e956f886a1a1..5710833ac1cc 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -285,6 +285,14 @@ void nilfs_btnode_abort_change_key(struct address_space *btnc,
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		xa_erase_irq(&btnc->i_pages, newkey);
 		unlock_page(ctxt->bh->b_page);
-	} else
-		brelse(nbh);
+	} else {
+		/*
+		 * When canceling a buffer that a prepare operation has
+		 * allocated to copy a node block to another location, use
+		 * nilfs_btnode_delete() to initialize and release the buffer
+		 * so that the buffer flags will not be in an inconsistent
+		 * state when it is reallocated.
+		 */
+		nilfs_btnode_delete(nbh);
+	}
 }
-- 
2.34.1

