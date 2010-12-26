From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: fix a checkpatch error in page.c
Date: Mon, 27 Dec 2010 01:02:37 +0900
Message-ID: <1293379362-3340-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1293379362-3340-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293379362-3340-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Will correct the following checkpatch error:

 ERROR: trailing whitespace
 #494: FILE: page.c:494:
 + $

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/page.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 48a775e..0c43241 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -491,7 +491,7 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
 	}
 	return nc;
 }
- 
+
 void nilfs_mapping_init_once(struct address_space *mapping)
 {
 	memset(mapping, 0, sizeof(*mapping));
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
