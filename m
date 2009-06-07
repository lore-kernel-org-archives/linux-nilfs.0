From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/6] nilfs2: remove meaningless EBUSY case from nilfs_get_sb function
Date: Mon,  8 Jun 2009 01:39:28 +0900
Message-ID: <1244392773-14230-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244392773-14230-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1244392773-14230-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, users@nilfs.org

The following EBUSY case in nilfs_get_sb() is meaningless.  Indeed,
this error code is never returned to the caller.

    if (!s->s_root) {
          ...
    } else if (!(s->s_flags & MS_RDONLY)) {
        err = -EBUSY;
    }

This simply removes the else case.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 6989b03..8131615 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1172,8 +1172,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
 		s->s_flags |= MS_ACTIVE;
 		need_to_close = 0;
-	} else if (!(s->s_flags & MS_RDONLY)) {
-		err = -EBUSY;
 	}
 
 	up(&sd.bdev->bd_mount_sem);
-- 
1.6.2

