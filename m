From: Jan Kara <jack@suse.cz>
Subject: [PATCH 19/24] nilfs2: Convert to properly refcounting bdi
Date: Thu,  2 Feb 2017 18:34:17 +0100
Message-ID: <20170202173422.3240-20-jack@suse.cz>
References: <20170202173422.3240-1-jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170202173422.3240-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

Similarly to set_bdev_super() NILFS2 just used block device reference to
bdi. Convert it to properly getting bdi reference. The reference will
get automatically dropped on superblock destruction.

CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
CC: linux-nilfs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/nilfs2/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index e1872f36147f..feb796a38b8d 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1068,7 +1068,8 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 	sb->s_max_links = NILFS_LINK_MAX;
 
-	sb->s_bdi = bdev_get_queue(sb->s_bdev)->backing_dev_info;
+	sb->s_bdi = bdi_get(sb->s_bdev->bd_bdi);
+	sb->s_iflags |= SB_I_DYNBDI;
 
 	err = load_nilfs(nilfs, sb);
 	if (err)
-- 
2.10.2

