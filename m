Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795847257;
	b=zmx6WCfL2lkhQNsSr0Cjbh9V08cmnNm9LhvpRu1IzRbl9pCfbMcMR7kFm39cCdNkJMvk
	 8uIKw/+B+ZPmF4PP6ClDszwN1fnujN40MsoZ4XmZmiErIE71JT3nEK8OaBpYyN6nKMtEJ
	 Dz4d+C1scPuqQ3l/ErFz5h9oHYf+IOTMtUTNFTUf/p1LAiXibytAQG6WMMB9z65RTK1QB
	 sH/NyZD7nDXOGMdPuqLdQl9O/EXpr9f7pHnD5ymqneylo/dsvlrAKIH5ugP97Uz9pHg6s
	 G4PjztbHIoKPr6cnXzFu2eBJnTt+a6t6UmhE7v+OvpjT2ZauRUs9NzIJtEywrqwNhMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795847257;
	h=Received:DKIM-Signature:Date:To:Cc:From:Message-Id:Subject;
	bh=Yi70muY8BSbsDAjf/zdBSv3thFF1heU7/tlv6UdnSls=;
	b=VaF6ZdZr+0K0dqiPegwWA+IB5Q6HVGTiDOCrIiPbsHnHIHjJgFVgu4kt012LPkhZCuFq
	 ktBtIwzMCqssNCLhmqBmW3Ep7VfUQ4RXMd1n3g+mAkXbD8OcJpjkMJSScZvuX75XSJ6Th
	 Z5TvId+cnYbAaysdFA0vZA04w49/tBcDRX3wt6hhsz6aEnOicQbSxPl8XFwuc7qzxgidD
	 dRr9+gsWdQzAP6UWK5IGMu7cCpMQ1BqCyp4w1mEgEhhZEiuB+7zJvgQlWA1lGonaC3OQf
	 Ueu27CiW7Y5DSHIPX1Or37BkSNhMsarQU9KHnid1nXgGATmSgE9+7pYYkehETHVpqIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=abilCd7C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAFB606A31C
	for <linux-nilfs@vger.kernel.org>; Sat, 28 Nov 2026 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=abilCd7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840F11F000C1;
	Sat, 28 Nov 2026 06:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795847257;
	bh=Yi70muY8BSbsDAjf/zdBSv3thFF1heU7/tlv6UdnSls=;
	h=Date:To:Cc:From:Subject;
	b=abilCd7CDnyEfNwDkUt0kMv0DR/IjUQYppx+Rpk5J88P+kD209C6fBiCKdmQc1+hM
	 bD0+glurK/Qfu9LfmFeSQIEG6+MOXMz2lZZKgr15dO97btCjUcS8ZMtHY/JP0F8oFU
	 kcTtJPulo3ZbhRiQeyswyrTvSf5V72ZZ4ZTlfSCY=
Date: Fri, 27 Nov 2026 22:27:37 -0800
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <0ee434a194ce4d8090007b8082a3667d.1@linux-foundation.org>
Subject: [PATCH] nilfs2: report mapping errors from fsync()
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list

From: Andrew Morton <akpm@linux-foundation.org>
Subject: nilfs2: report mapping errors from fsync()
Date: Sun, 22 Nov 2026 17:23:26 -0800

nilfs_sync_file() constructs a segment and flushes the device, but never
looks at the error state of the file's mapping.  Nothing else in nilfs2
does either.  So an error which was recorded with mapping_set_error() is
never reported to the application.

memory_failure() records -EIO that way when it has to discard a dirty
page-cache page.  On other filesystems the next fsync() then fails with
EIO, which is how the application learns that data it wrote has been
lost.  On nilfs2 fsync() returns 0.  The memory-failure selftest, once it
checks for this, fails on nilfs2 in 20 of 20 runs:

  memory-failure.c:413:dirty_pagecache:Expected fsync(fd) (0) == -1 (-1)

Call file_check_and_advance_wb_err() in nilfs_sync_file().  Call it even
when segment construction or the flush has failed, so that the recorded
error is consumed for this file either way, and return it if nothing
failed earlier.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>

 fs/nilfs2/file.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/file.c~nilfs2-report-mapping-errors-from-fsync
+++ a/fs/nilfs2/file.c
@@ -29,7 +29,7 @@ int nilfs_sync_file(struct file *file, l
 	 */
 	struct the_nilfs *nilfs;
 	struct inode *inode = file->f_mapping->host;
-	int err = 0;
+	int err = 0, wb_err;
 
 	if (nilfs_inode_dirty(inode)) {
 		if (datasync)
@@ -43,6 +43,15 @@ int nilfs_sync_file(struct file *file, l
 	if (!err)
 		err = nilfs_flush_device(nilfs);
 
+	/*
+	 * Report an error which was recorded in the mapping, for example by
+	 * memory_failure() on a dirty page.  Check even if the above failed,
+	 * so that the error is consumed for this file.
+	 */
+	wb_err = file_check_and_advance_wb_err(file);
+	if (!err)
+		err = wb_err;
+
 	return err;
 }
 
_
