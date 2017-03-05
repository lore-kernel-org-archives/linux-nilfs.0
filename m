From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 1/3] nilfs2: set the mapping error when calling SetPageError on writeback
Date: Sun,  5 Mar 2017 08:35:33 -0500
Message-ID: <20170305133535.6516-2-jlayton@redhat.com>
References: <20170305133535.6516-1-jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170305133535.6516-1-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@zeniv.linux.org.uk, konishi.ryusuke@lab.ntt.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

In a later patch, we're going to want to make the fsync codepath not do
a TestClearPageError call as that can override the error set in the
address space. To do that though, we need to ensure that filesystems
that are relying on the PG_error bit for reporting writeback errors
also set an error in the address space.

The only place I've found that looks potentially problematic is this
spot in nilfs2. Ensure that it sets an error in the mapping in addition
to setting PageError.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nilfs2/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index bedcae2c28e6..c1041b07060e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1743,6 +1743,7 @@ static void nilfs_end_page_io(struct page *page, int err)
 	} else {
 		__set_page_dirty_nobuffers(page);
 		SetPageError(page);
+		mapping_set_error(page_mapping(page), err);
 	}
 
 	end_page_writeback(page);
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
