From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] fs: nilfs2: Adding new return type vm_fault_t
Date: Thu, 21 Jun 2018 13:38:48 +0900
Message-ID: <1529555928-2411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=vVNt+6pS5w5n9GwgcCx79Wlx39OgH+NrkmlTct5ZOgs=;
        b=RMyhIrosgP9Cwp5L3Ei9MPKpl79RbWhRYAZcZUVYb8Ac/l+HgwvJFmTHqtV1OJorct
         copN+rZNBJyBixQJDl1skVZyJA95PLG36W8yKRfwB/GV0QykSll8iFwrHmjVageMxn8h
         Q+SsTAkCt4yoE+9O7YNdMcWaaJ2Q5F+bHSxUHZdMOGIQ63Q9SYfuzZ/Y5RTJt8euaTcH
         obNatJVDg3E6JgmAet9GNMDZBBUYKbDmdc1dkkKfIq+fguVvHFYdtlvcf1cA+tZ1CWKp
         7aoOF4l0bXDGOy0kmHNAPbYMXTvw8eT+kDmu0S1hWSYB7vkUYr6u8MJ6Au2zvPL60kJH
         Fz+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Souptick Joarder <jrdr.linux@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

From: Souptick Joarder <jrdr.linux@gmail.com>

Use new return type vm_fault_t for page_mkwrite
handler.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index c5fa3de..7da0fac 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -51,7 +51,7 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	return err;
 }
 
-static int nilfs_page_mkwrite(struct vm_fault *vmf)
+static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = vmf->page;
-- 
1.8.3.1

