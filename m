Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489B144C4F0
	for <linux-nilfs@vger.kernel.org>; Fri, 24 Jul 2026 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784932086; cv=none; b=sSP5YmKc5nVl7lBKqtjKI61QlkDmc1C3CRZmyvL3ht4ki+RhhrlgDtNU5blIbrLlqW0QyZfvKc9giKfdxCjq12Q13aE2Ffd+DGW8ldX48kgiIgFgwrIeiSOm6eexmrWdCTY5Pp6rO2mHOC6AkUad3vW/mNPc3lr2rV70sbRsJ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784932086; c=relaxed/simple;
	bh=KPv4KkbHpDLjFoMbEPupXdFgpw/p2FaSa2WoYX6AXAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfUbxkTf6HFd72izl4bFMK4Bj2eLowaps7b109S6uFE9pLN7poJgJ0A+iLgxRa5EHnumqtkY7jZyp36d1q5T7/2xgSU7jeX7y6OEtAHJ+P7Zi22pL4F2PREOOFhbDZRZtTLv7I5r7f0ksbRQcv6FVjzyMBqjhr0qHMmPP8zx4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=iq/jpDEl; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="iq/jpDEl"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6626b5ace23so1923346d50.0
        for <linux-nilfs@vger.kernel.org>; Fri, 24 Jul 2026 15:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1784932084; x=1785536884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W5ucNxoq8oX/9er0chVBnOyqnwlgREIEe3hS2bG+kEw=;
        b=iq/jpDEltMYAxz2RcTjZ5It4p8lv2PhPz1wU2cB0BuINZ4zMA8au8tIgZjthmJ9rrO
         cCTG9LWDQ5HGZDHhwRe6ibvKAsTXT41P6HRmUEje8PCijUjx3XQ5rsdYrm9ujtRErDJ9
         f4WYVlB8hXwKATMY4eZw17vZZgSSjIdqp+bo+EKq5GuMV5aW9QjUIK66o1Wt79YiQkzZ
         PSanNwfSVNp3r3zZIOlA63ik3VxMBqqcKvAdEb10PM+SD8ZqUjtDdENRln+5Uu23+GBh
         Tnm1Qs4dWHn2c/hh4jinHzgiS6gKqCxqWGKTDC0kjpftgDTit/QaTpnM/5qkdp4CXnZY
         lKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784932084; x=1785536884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W5ucNxoq8oX/9er0chVBnOyqnwlgREIEe3hS2bG+kEw=;
        b=q4InTXsFMN6vfJOUj9azyfnlr8lDDzB8u4tEn35eaL8i/OfzcpSPEiI8CIJPz/DThB
         olzLW7avpg6X+TMnCzI6KJG5RCRycXKAtOpxIF+KDYic9sm1Q4NCL91HW1EPhdDomR5t
         AVVup5j9eh+EeZYxab+LsDU1tHo9xC4DHevPUTxqkre/whrS4jAsy93D29lt+AVOgkNo
         6Ku52DV/HtmvXYPIc8Ga17JOivPdo4yU9gzKpDsFJIFep2eqqhFQtBENwsfNIIF8XHQD
         bSE882hcRVVYTr/uMGheUAjF5YphDBBgyg9wCj+kwTKl2SD83OHHQSTJBeegpf/YPX4a
         NLqA==
X-Gm-Message-State: AOJu0YwXdnvJC9AHPc9a/tlpX1v/JwKOJwMhi5r8o5tTQY7cmn7URb7W
	JeF532bbWmUHHEXWhcdHIEfwNffsIvmBCXHQOaFK/uW+y0Em1JKbWEt3VDjxwjuuNqc=
X-Gm-Gg: AR+sD11kXSbXsNQ9HAS47ssWA9oYz9prsOSyHCmKB/0YTpGwo8VtwaduvjGyFHCNjA/
	CTdYhd9qpxQeMfjiJQRFSaAF0sAKRLTTKcGpYgtpfT2v+iMhyxD4MxqWn2uJjjWE/aoDPRbLimy
	bCYNatsUA0q9kCE/ljYadbLpKMl+lgshObyIUlIOIKdk7XZWR+Q9MeGnR4XDOvGmXQWJDCH/PN8
	HRzjyBfeVQExHDVP5i/K6rWmzWC7zcJ5Bl7GGLa3bNfXpCL6vjTc/Q7IdQvMw6T+6UosC1a5vuI
	0IofFq189fQt2clB2qsb5rl9SZo7WANRhDSTkRb5dE/KBxYttDeKllCAq6qGnWQ1XVw/Z8s2+RP
	T+L8WjK2lWt6aEiV2WbTAwfQah8Hp6PQOPv2YdagurDgam3f8dKE0SbxWipu4pPKrdA2rq2ebJs
	0Dfci7XfTmVjz88k2KEM2ZA7G4PU6bEJM9w9k6B1biP0K/sOKWLwj2rmSD+gmxs1nReJyTinbW4
	lK/E5CCNld6GnX1BMqfmyAR2rP0SJ84QUmRi7aGFPT9RA==
X-Received: by 2002:a53:ed01:0:b0:664:d5ff:2856 with SMTP id 956f58d0204a3-668bfd9f557mr534973d50.14.1784932084236;
        Fri, 24 Jul 2026 15:28:04 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:62ee:74f6:cfbb:28e0])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-668c7041256sm90525d50.19.2026.07.24.15.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:28:03 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: konishi.ryusuke@gmail.com,
	hch@lst.de
Cc: linux-nilfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 1/2] nilfs2: add iomap operations for direct I/O reads
Date: Fri, 24 Jul 2026 15:27:44 -0700
Message-ID: <20260724222745.2107464-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724222745.2107464-1-slava@dubeyko.com>
References: <20260724222745.2107464-1-slava@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add iomap.c and iomap.h with a read-only nilfs_iomap_ops,
wrapping the existing nilfs_bmap_lookup_contig() lookup
to report a mapped range, a real hole, or an EOF-clamped
range to iomap core.

NILFS2 is a log-structured, copy-on-write filesystem:
newly allocated blocks are only given a real disk address
when the segment constructor writes them out as part of a log,
which walks buffer_head lists directly and is not integrated
with the generic address_space writeback path. Because of that,
only the read-only side of the mapping is added - buffered writes,
writeback, and mmap's ->page_mkwrite() will stay on the existing
buffer_head based path (nilfs_get_block(), nilfs_write_begin/end(),
nilfs_writepages(), nilfs_dirty_folio(), block_page_mkwrite()).

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
cc: linux-nilfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/nilfs2/Makefile |  2 +-
 fs/nilfs2/iomap.c  | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/iomap.h  | 13 +++++++++
 3 files changed, 85 insertions(+), 1 deletion(-)
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
index 000000000000..3ae3bf6ed368
--- /dev/null
+++ b/fs/nilfs2/iomap.c
@@ -0,0 +1,71 @@
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
+		iomap->offset = offset;
+		iomap->length = min_t(loff_t, length, i_blocksize(inode));
+		return 0;
+	} else if (ret < 0)
+		return ret;
+
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = offset;
+	iomap->length = min_t(loff_t, length, (loff_t)ret << inode->i_blkbits);
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

