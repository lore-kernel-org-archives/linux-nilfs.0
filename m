Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AA140BCDB
	for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 22:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786572756; cv=none; b=Ck7WN+z/+Q9HKYe1qZbCPtW+T/w5GJgE5tlQHBmcTXhUTJsodgL2wsnE28I3p2lQmFK1M9ljm6HPxytYo3SZ8lE/HqHjX0FphLgAHYY9SbNiRyscFIEBjHwXix2kpdZz2gsLojZ06RBJEjvv4qvSH2qsQdByiflYU81fdj+Xegs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786572756; c=relaxed/simple;
	bh=59RWqJsio1nPj2W1r+lB1kt+zvnkFT4OfxTo1o6d3I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHZgweudOJhdaVhOZkYpcEic2WPdneQ4dlMvW1Zc5QXtniJPvWUtXCy4VlVPdfb0ADOtXgxXZxeBcc3i87+S8LKSWmLIeuxpvncAf8SqjMOcoGypTSHtTHLHcClqnW9mouX6UUhhdMsREsXygNmFo8pQuFhRMMAtvD6mStCROBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=k0B5U+o5; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="k0B5U+o5"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-81e9f7491ffso21656437b3.0
        for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 15:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1786572754; x=1787177554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vx6j+PNuXPtNCAhHvs/xK91ts4OMPwcyyq+VucjW0hU=;
        b=k0B5U+o5lwdpVggGTNU5DHiXEMxurb0YNTu1nR3K/0MuNguaLjB12MAJ43ViEyGxJ1
         t84Rop+qGV7jQYAeZFqV1WZeEZ/fjHjBcTACnZFn18JiP4dBQMRkTcGsP16g40iik8W1
         4b7rM1rx6P7s8H0WCUGRm12BMU6rW38cH7fgHn65jxEwiLtF6n7BIDHvKAV6ZIXSvNKY
         Ol4fYj+rwSkfhz6Q79fL81bmu2X2XeOssQ3X2/L+Ze6anlo+Nu2xTtruKtQzK3lIBFYv
         SKusfk8uVxE+IApl7neRuZCT38sdHfFnO26t8GVNRxwMtHasekpbR2sKvpc4oggVX56a
         4vsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786572754; x=1787177554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vx6j+PNuXPtNCAhHvs/xK91ts4OMPwcyyq+VucjW0hU=;
        b=ihqeFvTZoikPfjVBhFNUbvRmlgFRM/jw2Gc/B7QJ7Tm2hhUiYWfF73YK8eQFkkdtXk
         N3RngGNea03F5qCSQu6ZwJFHGvzahrNzPojenKvEV2xP4zndwfwQ6rD9PtZQIu4ubYBq
         VhZUyOA1a0axaZT0+jcI7+8XboPXXTAE75aDLH4tXfW3Bc0X1aTjcKerh2rzXSjQtXVQ
         j4ZSJs0EUenluAqS8j73urARHDHI17hZw8mz6qwKeqppgkhJeY5AmmJSYctF9oY3KtFc
         LQkCObm+9ENZPb+RB4Lg5yHMXiWtgn2Mh6ssZtRzkm1xBW4mdZhm44Y0uf8N2mjLE8rT
         +Rwg==
X-Gm-Message-State: AOJu0YyONmWbBCe4HbBrB7Q32vBGAuvt6AmgTLZ9rG5EHdgQyDkd/EVl
	3JoXs3OzQyK708xVdkS+B1sEXd22c7DSXz/yHjs0L8nx5Crn/L4Hlk6F1UtAB2tbBFo=
X-Gm-Gg: AR+sD11zct+poyj/e/7SztGCedP3PZXA/uoSa2gTt4ChLZKFm9s+SWzWPsWkObE9R2C
	xEUWbEoYHZsllurTDTwd0tsh23chTZwocUjviMoegzppwv+22FWZH0nGZCKNeI+lb7vOPrwioBU
	tXlt0o209Kz8A/b6E/eRoBPVNkfor7LSlh3fYs7/fgvlf1aPGW81torybc5rBsvqnlEt081LNRj
	wukERTF812diXlhOfAQ/QTa0jplRam4dW7HbbluLhbDZYyGiRod8IQAlCLDVt7Pf7tzuwbJtzQt
	jVEW17ybbUeF9wpqeEiyWX+Vu/AIB4r9NZPzT6YYwah1XKcXQKqCqLfmiAnzRUvsRHnTv4l8XSp
	994CRvHCPD0jSJD7Fe/+9Hrgt4jj1y7AUyJmqeDR2ISe1NS6a1zovolN5VsLq/m48FByNYceOmP
	SzL6hUcfCq+O9nh9/zEIa+mmzn0KcejXmG2Ilf3QyYmSZgr5k+ArucTTWKbqNVNRBkwMcVOHqF/
	SqhcAM0OW86+0aIaVkTFm/9pySxVWu4m9DP9OTJpvzZEhdy+6a/kZX1zW4H8JHilvcCrvqVCkap
	DSmnuuTheQP9Xa329A==
X-Received: by 2002:a05:690c:e145:b0:81e:eaaa:535b with SMTP id 00721157ae682-834772d1cc5mr3961987b3.35.1786572754081;
        Wed, 12 Aug 2026 15:12:34 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:8bd1:139b:3c08:1f5b])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8346e1a08b7sm2365367b3.37.2026.08.12.15.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 15:12:33 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: konishi.ryusuke@gmail.com,
	hch@lst.de,
	brauner@kernel.org
Cc: linux-nilfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	lilinmao@kylinos.cn,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v3 1/2] nilfs2: add iomap operations for direct I/O
Date: Wed, 12 Aug 2026 15:11:53 -0700
Message-ID: <20260812221154.1119137-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812221154.1119137-1-slava@dubeyko.com>
References: <20260812221154.1119137-1-slava@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patch adds iomap.h with declaration of iomaps
operations and iomap.c with implementation of
nilfs_iomap_begin(). This method is based on calling
the nilfs_bmap_lookup_contig() method. It resolves
the file's block-mapping to find the sequence of
physically-contiguous blocks starting at starting
block. Offsets at or beyond i_size are reported
as a hole. For offsets within i_size, the requested
length is first clamped to the block-aligned end of the file.
Both the hole and mapped cases then report iomap->offset
aligned to the containing block (blkoff << i_blkbits)
rather than the raw request offset.

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Co-developed-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
cc: Christoph Hellwig <hch@lst.de>
cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
cc: linux-nilfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/nilfs2/Makefile |  2 +-
 fs/nilfs2/iomap.c  | 72 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/iomap.h  | 13 +++++++++
 3 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 fs/nilfs2/iomap.c
 create mode 100644 fs/nilfs2/iomap.h

diff --git a/fs/nilfs2/Makefile b/fs/nilfs2/Makefile
index 43b60b8a4d07..516e6b85a03c 100644
--- a/fs/nilfs2/Makefile
+++ b/fs/nilfs2/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_NILFS2_FS) += nilfs2.o
 nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
 	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
 	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
-	ifile.o alloc.o gcinode.o ioctl.o sysfs.o
+	ifile.o alloc.o gcinode.o ioctl.o sysfs.o iomap.o
diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
new file mode 100644
index 000000000000..e130ed63abd9
--- /dev/null
+++ b/fs/nilfs2/iomap.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * NILFS iomap support implementation.
+ *
+ * Written by Viacheslav Dubeyko.
+ */
+
+#include <linux/iomap.h>
+#include <linux/pagemap.h>
+#include "nilfs.h"
+#include "mdt.h"
+#include "iomap.h"
+
+static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
+			     loff_t length, unsigned int flags,
+			     struct iomap *iomap, struct iomap *srcmap)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	sector_t blkoff = offset >> inode->i_blkbits;
+	loff_t iomap_offset = (loff_t)blkoff << inode->i_blkbits;
+	unsigned int maxblocks;
+	__u64 blknum = 0;
+	int ret;
+
+	/* Completely beyond EOF. Treat as hole */
+	if (i_size_read(inode) <= offset) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->offset = offset;
+		iomap->length = length;
+		return 0;
+	}
+
+	/* Clamp length if the requested range goes beyond i_size */
+	if (offset + length > i_size_read(inode)) {
+		loff_t i_size = i_size_read(inode);
+		unsigned int blocksize = i_blocksize(inode);
+
+		length = round_up(i_size, blocksize) - offset;
+	}
+
+	maxblocks = min_t(loff_t, length >> inode->i_blkbits, INT_MAX);
+	if (maxblocks == 0)
+		maxblocks = 1;
+
+	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+	ret = nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, maxblocks);
+	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+
+	if (ret == -ENOENT) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->offset = iomap_offset;
+		iomap->length = i_blocksize(inode);
+		return 0;
+	} else if (ret < 0)
+		return ret;
+
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = iomap_offset;
+	iomap->length = (loff_t)ret << inode->i_blkbits;
+	iomap->addr = (loff_t)blknum << inode->i_blkbits;
+	iomap->type = IOMAP_MAPPED;
+	iomap->flags = IOMAP_F_MERGED;
+
+	return 0;
+}
+
+const struct iomap_ops nilfs_iomap_ops = {
+	.iomap_begin = nilfs_iomap_begin,
+};
diff --git a/fs/nilfs2/iomap.h b/fs/nilfs2/iomap.h
new file mode 100644
index 000000000000..adef3e22346d
--- /dev/null
+++ b/fs/nilfs2/iomap.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * NILFS iomap support declarations.
+ *
+ * Written by Viacheslav Dubeyko.
+ */
+
+#ifndef _NILFS_IOMAP_H
+#define _NILFS_IOMAP_H
+
+extern const struct iomap_ops nilfs_iomap_ops;
+
+#endif /* _NILFS_IOMAP_H */
-- 
2.43.0

