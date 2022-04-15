From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/27] ntfs3: use bdev_logical_block_size instead of open coding it
Date: Fri, 15 Apr 2022 06:52:40 +0200
Message-ID: <20220415045258.199825-10-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bh+vV8H1PUD+w/3YWj6wMRz8JdOJ8okMcDjW6Mx/Fiw=; b=EDKTioiwyVTPK+3osA6SlCjZIh
        XT2MFqWZOTWCp0TzWu6P4fqhDWPMpkttHrN+m9dRro3N5CDnlXbRs0EPkfGOyM+igunHSMpD1drYP
        wVG9uOkzBpiVKojyqfYhi6+OMNU5l2i8PZR4B1REL+uCtnEoooz23D6FVFibL3Fu1/dIA+0rTSxtr
        oKyzI2WMLHHUV9rvM0v15/lCAj3aZ6PKIBUE2kOCt4TslhWmWNZKgszd/7d2ie8DKfEQnXgchcj36
        NzfvLJkjkLxSqax1JuD1ELqlJ8gRaVf5Gn7y07gnCWPWGyuEN/9bXBtizUFBY7p5eDKr/MYNHjMCe
        ltnYH85Q==;
In-Reply-To: <20220415045258.199825-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 278dcf5024102..cd30e81abbce0 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -920,7 +920,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	/* Parse boot. */
-	err = ntfs_init_from_boot(sb, rq ? queue_logical_block_size(rq) : 512,
+	err = ntfs_init_from_boot(sb, bdev_logical_block_size(bdev),
 				  bdev_nr_bytes(bdev));
 	if (err)
 		goto out;
-- 
2.30.2

