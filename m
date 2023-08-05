From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix general protection fault in nilfs_lookup_dirty_data_buffers()
Date: Sat,  5 Aug 2023 22:20:38 +0900
Message-ID: <20230805132038.6435-1-konishi.ryusuke@gmail.com>
References: <0000000000002930a705fc32b231@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691241644; x=1691846444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KV92l3VXPcz++LN5c2ebdhb5o5BZtos4ufCZ4CtDds=;
        b=WzzZvM9gTNfDEIujV/M/qP23gW84ZJ2QwT3vGcElbafal6B4GJAWzGfq65IuYQspFd
         gB/lcTu47O6lvi9g0BWOSx/FY4tV+cUrrStbyc9VWja/K7OPaz/vKSPiFYpX8tv71em2
         ZS4pm+lTsHMveKT9TIgENcQ2wGyN3rONNR69dkHYE0cZx1G4soMxUQvwgFDfu13B2wft
         il08WTfFQKpjUoUI5+qGJuaa+cpH8Nt1DwEP48SfsRWHtiFsWR0L/ZkCLMU+itBLdOsx
         9w7VGk2JXE4TIJ0Bqn0sLDwsukKsPtiXjH87i3+s+f5qg2vk1NgnG/PgOpgtUQa1npQM
         uMqQ==
In-Reply-To: <0000000000002930a705fc32b231-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+0ad741797f4565e7e2d2-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

A syzbot stress test reported that create_empty_buffers() called from
nilfs_lookup_dirty_data_buffers() can cause a general protection fault.

Analysis using its reproducer revealed that the back reference "mapping"
from a page/folio has been changed to NULL after dirty page/folio gang
lookup in nilfs_lookup_dirty_data_buffers().

Fix this issue by excluding pages/folios from being collected if, after
acquiring a lock on each page/folio, its back reference "mapping"
differs from the pointer to the address space struct that held the
page/folio.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+0ad741797f4565e7e2d2-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Closes: https://lkml.kernel.org/r/0000000000002930a705fc32b231-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 fs/nilfs2/segment.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 581691e4be49..7ec16879756e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -725,6 +725,11 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		struct folio *folio = fbatch.folios[i];
 
 		folio_lock(folio);
+		if (unlikely(folio->mapping != mapping)) {
+			/* Exclude folios removed from the address space */
+			folio_unlock(folio);
+			continue;
+		}
 		head = folio_buffers(folio);
 		if (!head) {
 			create_empty_buffers(&folio->page, i_blocksize(inode), 0);
-- 
2.34.1

