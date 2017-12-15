From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 03/78] xarray: Add the xa_lock to the
 radix_tree_root
Date: Fri, 15 Dec 2017 14:03:35 -0800
Message-ID: <20171215220450.7899-4-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=HBd4W9R4hAts7yxtzj4f2Rp7fQvuLrbnzeEwD/CORbY=; b=SW0Il9lUAZ5dHdtcnp8Tq/lSRE
 sm6a2UJWsZJNi56NLWfxgEV8fmaycHucWJkdREfuu+1U8G2o7SDdLFmzQjvpTBTb/V1XWpMCPISdI
 760oqCOJwe+4dh/Qnk6H3h3TfP6fvbiQQiGoQ+PfA2L0l4aTxCTcRXpzcKKDq9OYrVx4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=HBd4W9R4hAts7yxtzj4f2Rp7fQvuLrbnzeEwD/CORbY=; b=GPtYeFDo7HHKGXy3DDan5T9cD5
 YsKJmpog3ZNaIKwrGNgRBd8O8GLh0hO+ZMjbhjzJxpmDlAQT08AjW5bYj3uDABoTxIcIbKkNXhcNe
 7KhMP4pkuW8TIqSO+FI/Cykbivb4SgM5G6oIwJJWolsu/g3xYWtCDIFQK1dUM43oVzSg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=HBd4W9R4hAts7yxtzj4f2Rp7fQvuLrbnzeEwD/CORbY=; b=RGdxM/LgAp6Djw04cgsskaacN
 tiaavxAmU5uxdi3aecDLs5bbu3+fxQKcSlUOGlCb+LeVoEonDfq3EAekQMjtH99Sa3ZrecqmCe6Qq
 wXE0Y6yoLGV1q3w1MzQVZcKfu5GsXTkyFrUwYFltJ3GI6KLJ5YDFmMHVXYkfBHLmKSsYiiGGG+g9W
 0O1eqNX/Q9piD8sfhzcW07ELbGsn3+sOtr/vXWmLt7owO+eO28eTv91JVEAyamGaH0ZcyW/FyO1D3
 Qa7q63VERs26N+ctGeHvCyBniJDaFOTu47ddkvQfPd2OpinoDosew+1vVnBFHL3rrpV+J3+u4EQzZ
 z97tDzLJA==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This results in no change in structure size on 64-bit x86 as it fits in
the padding between the gfp_t and the void *.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/f2fs/gc.c                   |  2 +-
 include/linux/idr.h            | 12 ++++++------
 include/linux/radix-tree.h     |  7 +++++--
 include/linux/xarray.h         | 33 +++++++++++++++++++++++++++++++++
 kernel/pid.c                   |  2 +-
 tools/include/linux/spinlock.h |  1 +
 6 files changed, 47 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/xarray.h

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index d844dcb80570..aac1e02f75df 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -991,7 +991,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 	unsigned int init_segno = segno;
 	struct gc_inode_list gc_list = {
 		.ilist = LIST_HEAD_INIT(gc_list.ilist),
-		.iroot = RADIX_TREE_INIT(GFP_NOFS),
+		.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 	};
 
 	trace_f2fs_gc_begin(sbi->sb, sync, background,
diff --git a/include/linux/idr.h b/include/linux/idr.h
index 8432bbfe02ce..45a77d32dcf6 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -31,11 +31,11 @@ struct idr {
 /* Set the IDR flag and the IDR_FREE tag */
 #define IDR_RT_MARKER		((__force gfp_t)(3 << __GFP_BITS_SHIFT))
 
-#define IDR_INIT							\
+#define IDR_INIT(name)							\
 {									\
-	.idr_rt = RADIX_TREE_INIT(IDR_RT_MARKER)			\
+	.idr_rt = RADIX_TREE_INIT(name, IDR_RT_MARKER)			\
 }
-#define DEFINE_IDR(name)	struct idr name = IDR_INIT
+#define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
 /**
  * idr_get_cursor - Return the current position of the cyclic allocator
@@ -194,10 +194,10 @@ struct ida {
 	struct radix_tree_root	ida_rt;
 };
 
-#define IDA_INIT	{						\
-	.ida_rt = RADIX_TREE_INIT(IDR_RT_MARKER | GFP_NOWAIT),		\
+#define IDA_INIT(name)	{						\
+	.ida_rt = RADIX_TREE_INIT(name, IDR_RT_MARKER | GFP_NOWAIT),	\
 }
-#define DEFINE_IDA(name)	struct ida name = IDA_INIT
+#define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
 
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask);
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id);
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index fc55ff31eca7..d2253b540cd7 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -109,20 +109,23 @@ struct radix_tree_node {
 #define ROOT_TAG_SHIFT	(__GFP_BITS_SHIFT + 1)
 
 struct radix_tree_root {
+	spinlock_t		xa_lock;
 	gfp_t			gfp_mask;
 	struct radix_tree_node	__rcu *rnode;
 };
 
-#define RADIX_TREE_INIT(mask)	{					\
+#define RADIX_TREE_INIT(name, mask)	{				\
+	.xa_lock = __SPIN_LOCK_UNLOCKED(name.xa_lock),			\
 	.gfp_mask = (mask),						\
 	.rnode = NULL,							\
 }
 
 #define RADIX_TREE(name, mask) \
-	struct radix_tree_root name = RADIX_TREE_INIT(mask)
+	struct radix_tree_root name = RADIX_TREE_INIT(name, mask)
 
 #define INIT_RADIX_TREE(root, mask)					\
 do {									\
+	spin_lock_init(&(root)->xa_lock);				\
 	(root)->gfp_mask = (mask);					\
 	(root)->rnode = NULL;						\
 } while (0)
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
new file mode 100644
index 000000000000..931a0ff61315
--- /dev/null
+++ b/include/linux/xarray.h
@@ -0,0 +1,33 @@
+#ifndef _LINUX_XARRAY_H
+#define _LINUX_XARRAY_H
+/*
+ * eXtensible Arrays
+ * Copyright (c) 2017 Microsoft Corporation
+ * Author: Matthew Wilcox <mawilcox@microsoft.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/spinlock.h>
+
+#define xa_trylock(xa)		spin_trylock(&(xa)->xa_lock)
+#define xa_lock(xa)		spin_lock(&(xa)->xa_lock)
+#define xa_unlock(xa)		spin_unlock(&(xa)->xa_lock)
+#define xa_lock_bh(xa)		spin_lock_bh(&(xa)->xa_lock)
+#define xa_unlock_bh(xa)	spin_unlock_bh(&(xa)->xa_lock)
+#define xa_lock_irq(xa)		spin_lock_irq(&(xa)->xa_lock)
+#define xa_unlock_irq(xa)	spin_unlock_irq(&(xa)->xa_lock)
+#define xa_lock_irqsave(xa, flags) \
+				spin_lock_irqsave(&(xa)->xa_lock, flags)
+#define xa_unlock_irqrestore(xa, flags) \
+				spin_unlock_irqrestore(&(xa)->xa_lock, flags)
+
+#endif /* _LINUX_XARRAY_H */
diff --git a/kernel/pid.c b/kernel/pid.c
index b13b624e2c49..b050b4643eee 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -58,7 +58,7 @@ int pid_max_max = PID_MAX_LIMIT;
  */
 struct pid_namespace init_pid_ns = {
 	.kref = KREF_INIT(2),
-	.idr = IDR_INIT,
+	.idr = IDR_INIT(init_pid_ns.idr),
 	.pid_allocated = PIDNS_ADDING,
 	.level = 0,
 	.child_reaper = &init_task,
diff --git a/tools/include/linux/spinlock.h b/tools/include/linux/spinlock.h
index 4ed569fcb139..b21b586b9854 100644
--- a/tools/include/linux/spinlock.h
+++ b/tools/include/linux/spinlock.h
@@ -7,6 +7,7 @@
 
 #define spinlock_t		pthread_mutex_t
 #define DEFINE_SPINLOCK(x)	pthread_mutex_t x = PTHREAD_MUTEX_INITIALIZER;
+#define __SPIN_LOCK_UNLOCKED(x)	(pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER
 
 #define spin_lock_irqsave(x, f)		(void)f, pthread_mutex_lock(x)
 #define spin_unlock_irqrestore(x, f)	(void)f, pthread_mutex_unlock(x)
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
