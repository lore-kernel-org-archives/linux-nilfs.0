Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A711613C3F2
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683408; cv=none; b=KnQvWptaTWRv99S4IrrYlkYUEQdC8FQZqQvo7wztputffeSxJ+4gQHNfrFVsvIv5jF7gfsnwjfYBZjTulAYHcyL4tHxXQotr+JYo2iZy6ViNvXgv+aLznSB6HEwKECIFI3lOg+UdQmTdjHgdZPEs7xUXZTF82xl/ynacEYztnMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683408; c=relaxed/simple;
	bh=38eoRGEubcYhm0LEaXWhVzm15aLYCh/PtM9dcgDBOMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=On7CZyn/2RhMwE7nUWvihKc8M4UOb3kB9Jm0pnjGtQhE4XuG37U7/sKtWJYWQPV163/V8/TSshjMl8vM+NrKydqNDt514JZp4Rovt7GfTF+uBQS9khB85ON1spXY93xCjw65CK9XPJ/SKYhjUJlY5F+WFsBPyqfRNDxsmIpz4Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MXeB2OHW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MXeB2OHW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gmk6UY0ifNacBZS6hRDUsVAF+0Q8EhjseRaa2kGCGwQ=; b=MXeB2OHW7xMuu6fzu6wJcJwq2g
	Da7YIVpfRwjENHnaSEOyWONKADDluuCdobSSuz68KHcHSiUSFCQEBjO6+Ttq1q9G6a7sGfb6kr2Ff
	Ib5H+GJtIz7xB+l8ItiFkykpztpnBbHebNDTpg8LmgAOvxMbc/0VWbZ/rREhkRDeD6LgarFc0SNBm
	QIL+O28NSqKJmsGKgzL9Vh9GDcYolVC01BbHQo1/Wle9+OHbU07DrZ/168CX0mABJZpiJrqfSlV5x
	CNvG1agAdiHL7y50kMMVb012kxuHA9BoOlCa/JXpxoeA2UrM54xL5pLNmh6moIj57eEppkarxXIOZ
	CfWB9u5w==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8x-0000000HOth-2MrJ;
	Thu, 08 May 2025 05:50:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] mm: remove the for_reclaim field from struct writeback_control
Date: Thu,  8 May 2025 07:47:49 +0200
Message-ID: <20250508054938.15894-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508054938.15894-1-hch@lst.de>
References: <20250508054938.15894-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This field is now only set to one in the i915 gem code that only
calls writeback_iter on it, which ignores the flag.  All other
checks are thuse dead code and the field can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |  1 -
 fs/fuse/file.c                            | 11 -----------
 fs/nfs/write.c                            |  2 +-
 include/linux/writeback.h                 |  1 -
 include/trace/events/btrfs.h              |  7 ++-----
 include/trace/events/writeback.h          |  8 ++------
 6 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index dbb7a78ceea7..7dac121d35a4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -303,7 +303,6 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
 		.nr_to_write = SWAP_CLUSTER_MAX,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
-		.for_reclaim = 1,
 	};
 	struct folio *folio = NULL;
 	int error = 0;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e203dd4fcc0f..c950317bd3dd 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1902,17 +1902,6 @@ int fuse_write_inode(struct inode *inode, struct writeback_control *wbc)
 	struct fuse_file *ff;
 	int err;
 
-	/*
-	 * Inode is always written before the last reference is dropped and
-	 * hence this should not be reached from reclaim.
-	 *
-	 * Writing back the inode from reclaim can deadlock if the request
-	 * processing itself needs an allocation.  Allocations triggering
-	 * reclaim while serving a request can't be prevented, because it can
-	 * involve any number of unrelated userspace processes.
-	 */
-	WARN_ON(wbc->for_reclaim);
-
 	ff = __fuse_write_file_get(fi);
 	err = fuse_flush_times(inode, ff);
 	if (ff)
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 374fc6b34c79..cf1d720b8251 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -720,7 +720,7 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGES);
 
 	if (!(mntflags & NFS_MOUNT_WRITE_EAGER) || wbc->for_kupdate ||
-	    wbc->for_background || wbc->for_sync || wbc->for_reclaim) {
+	    wbc->for_background || wbc->for_sync) {
 		ioc = nfs_io_completion_alloc(GFP_KERNEL);
 		if (ioc)
 			nfs_io_completion_init(ioc, nfs_io_completion_commit,
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9e960f2faf79..a2848d731a46 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -59,7 +59,6 @@ struct writeback_control {
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
 	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
-	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 	unsigned unpinned_netfs_wb:1;	/* Cleared I_PINNING_NETFS_WB */
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index bebc252db865..0adc40f5e72b 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -686,7 +686,6 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		__field(	loff_t, range_start		)
 		__field(	loff_t, range_end		)
 		__field(	char,   for_kupdate		)
-		__field(	char,   for_reclaim		)
 		__field(	char,   range_cyclic		)
 		__field(	unsigned long,  writeback_index	)
 		__field(	u64,    root_objectid		)
@@ -700,7 +699,6 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		__entry->range_start	= wbc->range_start;
 		__entry->range_end	= wbc->range_end;
 		__entry->for_kupdate	= wbc->for_kupdate;
-		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
@@ -709,13 +707,12 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 	TP_printk_btrfs("root=%llu(%s) ino=%llu page_index=%lu "
 		  "nr_to_write=%ld pages_skipped=%ld range_start=%llu "
 		  "range_end=%llu for_kupdate=%d "
-		  "for_reclaim=%d range_cyclic=%d writeback_index=%lu",
+		  "range_cyclic=%d writeback_index=%lu",
 		  show_root_type(__entry->root_objectid),
 		  __entry->ino, __entry->index,
 		  __entry->nr_to_write, __entry->pages_skipped,
 		  __entry->range_start, __entry->range_end,
-		  __entry->for_kupdate,
-		  __entry->for_reclaim, __entry->range_cyclic,
+		  __entry->for_kupdate, __entry->range_cyclic,
 		  __entry->writeback_index)
 );
 
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 0ff388131fc9..1e23919c0da9 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -459,7 +459,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(int, sync_mode)
 		__field(int, for_kupdate)
 		__field(int, for_background)
-		__field(int, for_reclaim)
 		__field(int, range_cyclic)
 		__field(long, range_start)
 		__field(long, range_end)
@@ -473,23 +472,20 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->sync_mode	= wbc->sync_mode;
 		__entry->for_kupdate	= wbc->for_kupdate;
 		__entry->for_background	= wbc->for_background;
-		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
 		__entry->range_start	= (long)wbc->range_start;
 		__entry->range_end	= (long)wbc->range_end;
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
 	),
 
-	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
-		"bgrd=%d reclm=%d cyclic=%d "
-		"start=0x%lx end=0x%lx cgroup_ino=%lu",
+	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d bgrd=%d "
+		"cyclic=%d start=0x%lx end=0x%lx cgroup_ino=%lu",
 		__entry->name,
 		__entry->nr_to_write,
 		__entry->pages_skipped,
 		__entry->sync_mode,
 		__entry->for_kupdate,
 		__entry->for_background,
-		__entry->for_reclaim,
 		__entry->range_cyclic,
 		__entry->range_start,
 		__entry->range_end,
-- 
2.47.2

