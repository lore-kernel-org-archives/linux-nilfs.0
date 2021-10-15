From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 14/30] fat: use bdev_nr_sectors instead of open coding it
Date: Fri, 15 Oct 2021 15:26:27 +0200
Message-ID: <20211015132643.1621913-15-hch@lst.de>
References: <20211015132643.1621913-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=l6H+xWHI2buGGvGsIZb/A3dvICuo/7ewDE4S1/fqN/c=; b=PZKuiIv/qJljrkxnxnKD+h7ASp
        t1DY8S37VxTjS5GVdTkbLu2mMuhS6r19M9P18jq5XWRRb/cDXTKEhdKZpbi6BYfjD+qVUx98A7XOx
        dOceraYZgfKi6i/cyCWYpqxoLOymY2Qbs01Ah8Y+ZKKT9clwZtoud58n6FEGbl464S2EYE1cDTPWl
        4k2uxiZ1Ufz8ImJJ9J6PAiEaI3OVRm7cm1hnYyVq9H/QoM0+iG2ltlqYPdw3Ica7l/zAFYvuR19Li
        1xrYDx5RlNaWSbE2njYmuPk8oSACh0P63MHKOWIgGLbA1JAiNrz3A7Mcdmlh/tLrvL90Jz6F3+CFW
        fbcCjk3g==;
In-Reply-To: <20211015132643.1621913-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>, Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Phillip Lougher <phillip-Y7wUz+saRi+tmTQ+vhA3Yw@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TaqPxH82wqD4g@public.gmane.org

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 fs/fat/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index de0c9b013a851..9f3cd03668adc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1536,14 +1536,11 @@ static int fat_read_static_bpb(struct super_block *sb,
 	struct fat_bios_param_block *bpb)
 {
 	static const char *notdos1x = "This doesn't look like a DOS 1.x volume";
-
+	sector_t bd_sects = bdev_nr_sectors(sb->s_bdev);
 	struct fat_floppy_defaults *fdefaults = NULL;
 	int error = -EINVAL;
-	sector_t bd_sects;
 	unsigned i;
 
-	bd_sects = i_size_read(sb->s_bdev->bd_inode) / SECTOR_SIZE;
-
 	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
 	if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90) {
 		if (!silent)
-- 
2.30.2

