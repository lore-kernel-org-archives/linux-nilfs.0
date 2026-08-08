Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E752798EA
	for <linux-nilfs@vger.kernel.org>; Sat,  8 Aug 2026 00:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786149356; cv=none; b=rT/wN9NuN76rWftMBzUzbepNDfTiOhiPfGDf+DAxhEEUEvOMNqoopxA77POuZMBC164cRMIAYWPikwJf9ttlPj3EQGtdXd7QWWz91K3RZiKQTRZSCg8cs906ZCb2g71xE7VlAuH3A39VstaonxMcnrFTIKSHTC0KArYg8Ly+rmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786149356; c=relaxed/simple;
	bh=zV3ThKm8YmgKmBanOF1YJktpFpJt+bdjwJtonrUvbNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyCWNTz3YZjZNJ8AB5JzxA6RB52In/elt2F9tM0hcX65NnbN384U80HqOg3Rl2BumEZY2qHeYNxOSNXJaumklTqGfpsVgnnJFGSOWfpl4URqfkTuJ9LTGRnH/o8I00fwwRFBDROWOX8d90+sAfj5qsRgFoUuHPW5oPS+2T8nv7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=n8CcV7pH; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="n8CcV7pH"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81f36179dd5so1262207b3.2
        for <linux-nilfs@vger.kernel.org>; Fri, 07 Aug 2026 17:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1786149354; x=1786754154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o4GTCuOGlzXbqZf7Wkh3FbOSWCcj9+62dMc4XlomNHE=;
        b=n8CcV7pHC3f5p0ucVUzy4IT+WsATPNofk8GyMza148UM/HWUN7W1ilVwAKwF1QxSna
         eOrEpcpBrpcneB9M3AzWwa6u2+VPZIOGEEaPhcXSlxIwhfvVKv45qnHjDxgSsENUhyUS
         l/v6W0WspaWhj186cT9W3mxyTGIU4XeUzdhQsZlWVPWeYAzG+VDy7Rn/EUE/6XS+eee9
         SiDDZ3BqqkewsLlU4eKXCyYomP7fV5nN9lGW5Jg5aEi4HRC0TC9fhIYsj31FvyBvSxMh
         elSsRwtVsxD3MFWg45QpJ9DAvgzjO5vvLS553Mji9EZiNr32VWrbl+djNB/+kTCNO4Cm
         Qrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786149354; x=1786754154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o4GTCuOGlzXbqZf7Wkh3FbOSWCcj9+62dMc4XlomNHE=;
        b=JvNMFN0Mno4eapDeSpoRZNFlbHnvw2kwzYXwb3vBWfxkOQYJbJQimybJh/85sLrPwo
         KZiQ4JDyYppmUxWbdBYuA3+CGzxXc0FsRrBTw7g1UkVQvocMPUuTK0xmYhBXAeIySJCb
         za8uh4/vZUKpYRj1rdBHvHwli5WWnwtPquBXRMZjITkmCxVuqzH3nfVMsjlg4JuEPh3a
         HeI3KKeF05c0VwzIe670b4Ha1VNfb1G72Vgbfa2Muv6F6JmOiWAmnZGJz3WL3+CmkwVp
         W/Nmn2JSraFRfhj23BgFltBYL2bPd6fGdTxFYOQsfWVRHJvtVpqE9jOoZLInICVVpGL/
         qHww==
X-Gm-Message-State: AOJu0YxtDesk8D95Jdmkw4FYwLYEVfyYGtKng7HFZehKvHoD74ji5LDG
	u06b5Vubr2+afQUXnoQBkOvJdcUr39Byq/pFpXLirkQSJ3UIvgdnqWqNQO9F6PpYH/0=
X-Gm-Gg: AR+sD12U/RZ3NIxv7LME8TBIpNxPF5Tx5Gy72UKgs4fhV1e+PDpcmP9JyBrFr60dGm4
	r6reFCKUdU9jndVUZvdTgYeJ1x9aBdL/Q0+XdU8M7ZvScSNHvWRZOo06+nBC5mtTwLQ6Y7vKD7w
	LDmDgBhKTSnN4MKmGeGsJAS7n1jXz8QARv03wRLZPdNue7HSMd+BFGTMGrNyyToLCuf4+AUI29+
	0vu36lSrDnIPLAcpr9BmZzZIdqIJE42v3kmtn/x65Oc5rRmqkGNsd2ClTSDripO3lU5+Au0KbIA
	2AFQumXsbZXc3E0jSYNDXcEoM100dSrteIJ0SZvopWP3iE1Er3EeZGQiArQF5qX3bj6RaCBx9lN
	nSZ7uvOUojDdK7p6KHBO6m6vfCJkXSXcua1HK0VJdaeEGEqb53RzVw8NYXGgPnWi0AlnT/+oBEA
	njljov8F/jkPMFQ5XNuuTCldgjsuTo7rId6dCOLSY9Eptcu1zoTpgqEd/MdqkaKqHQsz1bGD4g9
	cz4WsA5wgtFhwqE7f68RGuQYzYy8qdeRRKps4qYXBWMqMVRiiYr7+uD7hLYmwfMn0by5HxKDRGY
	5gpB1d8c/Z1fjewdgQ==
X-Received: by 2002:a05:690c:f07:b0:81e:7dfa:b799 with SMTP id 00721157ae682-82022484477mr145496487b3.24.1786149354024;
        Fri, 07 Aug 2026 17:35:54 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:891e:7b31:87a7:701f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-823f577c580sm19024407b3.27.2026.08.07.17.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 17:35:53 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: konishi.ryusuke@gmail.com,
	hch@lst.de
Cc: linux-nilfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	lilinmao@kylinos.cn,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v2 2/2] nilfs2: switch O_DIRECT to iomap based operations
Date: Fri,  7 Aug 2026 17:35:23 -0700
Message-ID: <20260808003523.2760509-3-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260808003523.2760509-1-slava@dubeyko.com>
References: <20260808003523.2760509-1-slava@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patch eliminates blockdev_direct_IO() from
nilfs2 entirely:

 - nilfs_file_open() now sets FMODE_CAN_ODIRECT explicitly, since
   permission to open the file O_DIRECT was previously implied by
   aops->direct_IO being non-NULL.
 - nilfs_file_read_iter() dispatches O_DIRECT reads to iomap_dio_rw()
   using nilfs_iomap_ops; everything else still goes through
   generic_file_read_iter() as before.
 - nilfs_file_write_iter() strips IOCB_DIRECT and falls through to
   generic_file_write_iter()'s ordinary buffered path. NILFS2 cannot
   perform true direct I/O writes: new blocks are delay-allocated and
   only given a real disk address by the segment constructor, which
   works on buffer_head lists, not iomap. This reproduces today's
   actual behavior: the old nilfs_direct_IO() already just returned 0
   for WRITE.
 - nilfs_direct_IO() and the .direct_IO callback on nilfs_aops are
   removed.
 - drop the unnecessary "select LEGACY_DIRECT_IO" from Kconfig
   in favor of "select FS_IOMAP".

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
cc: linux-nilfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/nilfs2/Kconfig |  2 +-
 fs/nilfs2/file.c  | 40 +++++++++++++++++++++++++++++++++++++---
 fs/nilfs2/inode.c | 13 -------------
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 7dae168e346e..0a5ace60e6ab 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -3,7 +3,7 @@ config NILFS2_FS
 	tristate "NILFS2 file system support"
 	select BUFFER_HEAD
 	select CRC32
-	select LEGACY_DIRECT_IO
+	select FS_IOMAP
 	help
 	  NILFS2 is a log-structured file system (LFS) supporting continuous
 	  snapshotting.  In addition to versioning capability of the entire
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index f93b68c4877c..ad2e87c049c9 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -10,9 +10,12 @@
 #include <linux/fs.h>
 #include <linux/filelock.h>
 #include <linux/mm.h>
+#include <linux/uio.h>
+#include <linux/iomap.h>
 #include <linux/writeback.h>
 #include "nilfs.h"
 #include "segment.h"
+#include "iomap.h"
 
 int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
@@ -133,20 +136,51 @@ static int nilfs_file_mmap_prepare(struct vm_area_desc *desc)
 	return 0;
 }
 
+static int nilfs_file_open(struct inode *inode, struct file *file)
+{
+	file->f_mode |= FMODE_CAN_ODIRECT;
+	return generic_file_open(inode, file);
+}
+
+static ssize_t nilfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		return iomap_dio_rw(iocb, to, &nilfs_iomap_ops,
+				    NULL, 0, NULL, 0);
+	} else
+		return generic_file_read_iter(iocb, to);
+}
+
+static ssize_t nilfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	/*
+	 * NILFS2 cannot perform true direct I/O writes: new blocks are
+	 * delay-allocated and are only given a real disk address when
+	 * the segment constructor writes them out as part of a log,
+	 * which works directly on buffer_head lists rather than
+	 * through iomap. Fall back to the ordinary buffered write path
+	 * for O_DIRECT writes.
+	 */
+	if (iocb->ki_flags & IOCB_DIRECT)
+		iocb->ki_flags &= ~IOCB_DIRECT;
+
+	return generic_file_write_iter(iocb, from);
+}
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the nilfs filesystem.
  */
 const struct file_operations nilfs_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.read_iter	= nilfs_file_read_iter,
+	.write_iter	= nilfs_file_write_iter,
 	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
 #endif	/* CONFIG_COMPAT */
 	.mmap_prepare	= nilfs_file_mmap_prepare,
-	.open		= generic_file_open,
+	.open		= nilfs_file_open,
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
 	.splice_read	= filemap_splice_read,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 51f7e125a311..f4a9d9ea9c3f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -257,18 +257,6 @@ static int nilfs_write_end(const struct kiocb *iocb,
 	return err ? : copied;
 }
 
-static ssize_t
-nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-
-	if (iov_iter_rw(iter) == WRITE)
-		return 0;
-
-	/* Needs synchronization with the cleaner */
-	return blockdev_direct_IO(iocb, inode, iter, nilfs_get_block);
-}
-
 const struct address_space_operations nilfs_aops = {
 	.read_folio		= nilfs_read_folio,
 	.writepages		= nilfs_writepages,
@@ -277,7 +265,6 @@ const struct address_space_operations nilfs_aops = {
 	.write_begin		= nilfs_write_begin,
 	.write_end		= nilfs_write_end,
 	.invalidate_folio	= block_invalidate_folio,
-	.direct_IO		= nilfs_direct_IO,
 	.migrate_folio		= buffer_migrate_folio_norefs,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 };
-- 
2.43.0

