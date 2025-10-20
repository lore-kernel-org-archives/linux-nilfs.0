Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5902F83DF;
	Mon, 20 Oct 2025 12:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.158.23.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760963179; cv=none; b=QiB6hhTHqvhKXQ/lrZ/PUHWA07CoggZ8zevKjGhodF27fORztSn4HRvlPicNEJG7DVUSTynhwHRlAcXGCjWXFrJJTxtkaK1jpVIGjlbfLUGs73ltH8UI/lxt6BtcgQSGIAmv6/57f+bcve4BuzmNzpudr+xFGAlopOOrJmuh50g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760963179; c=relaxed/simple;
	bh=iFtNqAALTnaGMyjG4E8hOCEExNpCalehkWAxAsxgxcE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Id4J3PkUD2+/SR/Tp3PLEk5bbUEhED8I6Fko/Qh+wOdyaiZBwI1L5B8X32Jj2/prqiI1qMp+m39KM4sqExuNWVuKJ4IAPmYAYK/mwCo9EX4ujfz0pGGO6/z3XNSK+bF6HDxZBMo0yQFW/oaLp+A+0SmjEs01OJlQaaJsby4KfOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=fOC+eo+2; arc=none smtp.client-ip=35.158.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="fOC+eo+2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1760963173; x=1792499173;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pLrkDc9uOZVP5QDcEFJpTtan3stKZzUb4ru8DIN6Jio=;
  b=fOC+eo+2cjyx3LnwMEYK83XHVLMzOaD7namg5jVCriv4p4qe1wfjFiYV
   oShjZYudTuvuZg7ERUo0jN/ZkFAOhdQXbMynxpG7KXUKwMpbn/PFOwPxG
   RxfKUEaVdHY9L/NgC5L5WXYTwW2gb3vPJZhBopKFjMcTmo0ViOsyo7t29
   novvirFPicueTsKXc7xeqvUul1INisuG0/s31p9iM3hwAqjjFLhoaqqRk
   qZurTGMsEwfXDKKObDQ+2GoYAFGXWIFtT2bQ3BeGhM4Umi0Qz4xV6ixC3
   pPoVWAtjnmX2/sSgiFKLVXHuARMjMb1YtSMNA6pjCZiVy9q3bOKr2J1yf
   g==;
X-CSE-ConnectionGUID: XMphiMhvTgeNxgLfSTa9kg==
X-CSE-MsgGUID: 5gVlu9EYQo6obBnfNFlH0Q==
X-IronPort-AV: E=Sophos;i="6.19,242,1754956800"; 
   d="scan'208";a="3882177"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 12:25:59 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:4783]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.169:2525] with esmtp (Farcaster)
 id 71ef932b-06b0-4cee-8a75-9885cd1ac552; Mon, 20 Oct 2025 12:25:59 +0000 (UTC)
X-Farcaster-Flow-ID: 71ef932b-06b0-4cee-8a75-9885cd1ac552
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 20 Oct 2025 12:25:56 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 20 Oct 2025
 12:25:49 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Luis Chamberlain
	<mcgrof@kernel.org>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Jens Axboe" <axboe@kernel.dk>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>
Subject: [PATCH 6.6 1/2] block: fix race between set_blocksize and read paths
Date: Mon, 20 Oct 2025 14:25:38 +0200
Message-ID: <20251020122541.7227-1-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0e473a0d226479e8e925d5ba93f751d8df628e9 upstream.

With the new large sector size support, it's now the case that
set_blocksize can change i_blksize and the folio order in a manner that
conflicts with a concurrent reader and causes a kernel crash.

Specifically, let's say that udev-worker calls libblkid to detect the
labels on a block device.  The read call can create an order-0 folio to
read the first 4096 bytes from the disk.  But then udev is preempted.

Next, someone tries to mount an 8k-sectorsize filesystem from the same
block device.  The filesystem calls set_blksize, which sets i_blksize to
8192 and the minimum folio order to 1.

Now udev resumes, still holding the order-0 folio it allocated.  It then
tries to schedule a read bio and do_mpage_readahead tries to create
bufferheads for the folio.  Unfortunately, blocks_per_folio == 0 because
the page size is 4096 but the blocksize is 8192 so no bufferheads are
attached and the bh walk never sets bdev.  We then submit the bio with a
NULL block device and crash.

Therefore, truncate the page cache after flushing but before updating
i_blksize.  However, that's not enough -- we also need to lock out file
IO and page faults during the update.  Take both the i_rwsem and the
invalidate_lock in exclusive mode for invalidations, and in shared mode
for read/write operations.

I don't know if this is the correct fix, but xfs/259 found it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/174543795699.4139148.2086129139322431423.stgit@frogsfrogsfrogs
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[use bdev->bd_inode instead]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
    Fixes CVE-2025-38073.

 block/bdev.c      | 17 +++++++++++++++++
 block/blk-zoned.c |  5 ++++-
 block/fops.c      | 16 ++++++++++++++++
 block/ioctl.c     |  6 ++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index 5a54977518eeae..a8357b72a27b86 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -147,9 +147,26 @@ int set_blocksize(struct block_device *bdev, int size)
 
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_inode->i_blkbits != blksize_bits(size)) {
+		/*
+		 * Flush and truncate the pagecache before we reconfigure the
+		 * mapping geometry because folio sizes are variable now.  If a
+		 * reader has already allocated a folio whose size is smaller
+		 * than the new min_order but invokes readahead after the new
+		 * min_order becomes visible, readahead will think there are
+		 * "zero" blocks per folio and crash.  Take the inode and
+		 * invalidation locks to avoid racing with
+		 * read/write/fallocate.
+		 */
+		inode_lock(bdev->bd_inode);
+		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
+
 		sync_blockdev(bdev);
+		kill_bdev(bdev);
+
 		bdev->bd_inode->i_blkbits = blksize_bits(size);
 		kill_bdev(bdev);
+		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+		inode_unlock(bdev->bd_inode);
 	}
 	return 0;
 }
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 619ee41a51cc8c..644bfa1f6753ea 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -401,6 +401,7 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		op = REQ_OP_ZONE_RESET;
 
 		/* Invalidate the page cache, including dirty pages. */
+		inode_lock(bdev->bd_inode);
 		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
 		if (ret)
@@ -423,8 +424,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 			       GFP_KERNEL);
 
 fail:
-	if (cmd == BLKRESETZONE)
+	if (cmd == BLKRESETZONE) {
 		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+		inode_unlock(bdev->bd_inode);
+	}
 
 	return ret;
 }
diff --git a/block/fops.c b/block/fops.c
index 7c257eb3564d0c..088143fa9ac9e1 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -681,7 +681,14 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			ret = direct_write_fallback(iocb, from, ret,
 					blkdev_buffered_write(iocb, from));
 	} else {
+		/*
+		 * Take i_rwsem and invalidate_lock to avoid racing with
+		 * set_blocksize changing i_blkbits/folio order and punching
+		 * out the pagecache.
+		 */
+		inode_lock_shared(bd_inode);
 		ret = blkdev_buffered_write(iocb, from);
+		inode_unlock_shared(bd_inode);
 	}
 
 	if (ret > 0)
@@ -693,6 +700,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	loff_t pos = iocb->ki_pos;
 	size_t shorted = 0;
@@ -728,7 +736,13 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			goto reexpand;
 	}
 
+	/*
+	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
+	 * changing i_blkbits/folio order and punching out the pagecache.
+	 */
+	inode_lock_shared(bd_inode);
 	ret = filemap_read(iocb, to, ret);
+	inode_unlock_shared(bd_inode);
 
 reexpand:
 	if (unlikely(shorted))
@@ -771,6 +785,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	if ((start | len) & (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 
 	/*
@@ -811,6 +826,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
  fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return error;
 }
 
diff --git a/block/ioctl.c b/block/ioctl.c
index 231537f79a8cb4..024767fa1e52d5 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -114,6 +114,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (err)
@@ -121,6 +122,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 	err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 
@@ -146,12 +148,14 @@ static int blk_ioctl_secure_erase(struct block_device *bdev, blk_mode_t mode,
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	inode_lock(bdev->bd_inode);
 	filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (!err)
 		err = blkdev_issue_secure_erase(bdev, start >> 9, len >> 9,
 						GFP_KERNEL);
 	filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+	inode_unlock(bdev->bd_inode);
 	return err;
 }
 
@@ -184,6 +188,7 @@ static int blk_ioctl_zeroout(struct block_device *bdev, blk_mode_t mode,
 		return -EINVAL;
 
 	/* Invalidate the page cache, including dirty pages */
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end);
 	if (err)
@@ -194,6 +199,7 @@ static int blk_ioctl_zeroout(struct block_device *bdev, blk_mode_t mode,
 
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

