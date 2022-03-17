From: trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH] nilfs2: move initialization of nr_dirty to decl
Date: Thu, 17 Mar 2022 10:50:43 -0700
Message-ID: <20220317175043.1972081-1-trix@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647539454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CWUmn/QvK/L7nVX8kGPV5onMGWPPEQZ85b495jUko/o=;
        b=VDDw96qB66Qd/IGq+j3AGfY7++eYnxf9FMkO2vxm+Oaz/A9HyWTM+AbiKFcUC9cNPoGCRN
        chb1FuRsASSY5UiTE78US0rrG7VMberxwqCC7e0sfPvpzMK5FX6hgUAKlCV3VdKEgxQGcq
        HuhlJX2dC8lT/5w60qBQntRDjLDtGs4=
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On clang build there is this error
inode.c:227:13: error: variable 'nr_dirty' is
  used uninitialized whenever 'if' condition is false
        } else if (ret) {
                   ^~~

In nilfs_dirty_folio(), if the call to
filemap_dirty_folio() fails and there
are no buffers, nr_dirty will be uninitialized.
Move the initialization out of the buffer
block and to the decl.

Signed-off-by: Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/nilfs2/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index c1219c0678a57..01e58b65c9384 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -204,7 +204,7 @@ static bool nilfs_dirty_folio(struct address_space *mapping,
 {
 	struct inode *inode = mapping->host;
 	struct buffer_head *head;
-	unsigned int nr_dirty;
+	unsigned int nr_dirty = 0;
 	bool ret = filemap_dirty_folio(mapping, folio);
 
 	/*
@@ -214,8 +214,6 @@ static bool nilfs_dirty_folio(struct address_space *mapping,
 	head = folio_buffers(folio);
 	if (head) {
 		struct buffer_head *bh = head;
-
-		nr_dirty = 0;
 		do {
 			/* Do not mark hole blocks dirty */
 			if (buffer_dirty(bh) || !buffer_mapped(bh))
-- 
2.26.3

