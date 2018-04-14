From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 16/63] page cache: Rearrange address_space
Date: Sat, 14 Apr 2018 07:12:29 -0700
Message-ID: <20180414141316.7167-17-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=un4avSvOogrmnJWx5tkjRNG7Tovebi2mPlmeatqfQHs=; b=h5k3SVqLTwiyw0IgynbfXfPytp
 DjJAfdQ7Rb7A74hMbGX4IbZ04180fW+BTixSE8CHOSlBqFkYbVxuVIEBBZB9I8086DeNLZqCM5x00
 XXrImMI/iWZ70AvzLlDJKOyTGpRWkk0AiW3asfA/+0aM/ZDhOGJ29X8yF8jDd1cHvP8k=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=un4avSvOogrmnJWx5tkjRNG7Tovebi2mPlmeatqfQHs=; b=ZUHBiDD+lDnc3E2s5iIB4Xlcdc
 TwE46t0TSIFJ/cGl4uwqfvz7514PGSlBOT/lFOxTFTsUSr+iMGShxTPS3/Z3kcit+fZ8t24MIpA21
 a4ub3VmDdqUvhi8cTiy+aaoV4JXzSDYTIpB0f0T8IVPZZSRhwCMgHR+kovD1ne6+NJ54=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=un4avSvOogrmnJWx5tkjRNG7Tovebi2mPlmeatqfQHs=; b=Fil13i6tdbp+paMcz/dQohnOQ
 g0actZicalU0yPbXk/LY+Stg2Ik4QX8DxPi1GWeLS1sQ6RoXa3KCRulT3W3UZyGqXegwrQUg/l1AO
 dmbnE/q/TQXT7ovdZKlPWBuMV7nOYroN/OPwux+KyT58UzQOH8hrKCeIxwWx2Luyxe7UnI7Q/DomO
 Vy6TxOeBxPgWppIiidhFu1h/kuHRgSi472utAc7jFD+BCl041CGcgz2SgS14zkGEoHwxXdqMlX3bD
 /3dLLE/ZU0JCOF195EkoCgw6wenMDj2vWOkaZtVDwGLMrEXpS7mkyMbCclHapaEYgOrTs7mwapz2q
 HQsCsPjrg==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Change i_pages from a radix_tree_root to an xarray, convert the
documentation into kernel-doc format and change the order of the elements
to pack them better on 64-bit systems.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/fs.h | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index bf3d5039c708..0a4e213f1069 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -389,24 +389,40 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata);
 
+/**
+ * struct address_space - Contents of a cacheable, mappable object.
+ * @host: Owner, either the inode or the block_device.
+ * @i_pages: Cached pages.
+ * @gfp_mask: Memory allocation flags to use for allocating pages.
+ * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap: Tree of private and shared mappings.
+ * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
+ * @nrpages: Number of page entries, protected by the i_pages lock.
+ * @nrexceptional: Shadow or DAX entries, protected by the i_pages lock.
+ * @writeback_index: Writeback starts here.
+ * @a_ops: Methods.
+ * @flags: Error bits and flags (AS_*).
+ * @wb_err: The most recent error which has occurred.
+ * @private_lock: For use by the owner of the address_space.
+ * @private_list: For use by the owner of the address_space.
+ * @private_data: For use by the owner of the address_space.
+ */
 struct address_space {
-	struct inode		*host;		/* owner: inode, block_device */
-	struct radix_tree_root	i_pages;	/* cached pages */
-	atomic_t		i_mmap_writable;/* count VM_SHARED mappings */
-	struct rb_root_cached	i_mmap;		/* tree of private and shared mappings */
-	struct rw_semaphore	i_mmap_rwsem;	/* protect tree, count, list */
-	/* Protected by the i_pages lock */
-	unsigned long		nrpages;	/* number of total pages */
-	/* number of shadow or DAX exceptional entries */
+	struct inode		*host;
+	struct xarray		i_pages;
+	gfp_t			gfp_mask;
+	atomic_t		i_mmap_writable;
+	struct rb_root_cached	i_mmap;
+	struct rw_semaphore	i_mmap_rwsem;
+	unsigned long		nrpages;
 	unsigned long		nrexceptional;
-	pgoff_t			writeback_index;/* writeback starts here */
-	const struct address_space_operations *a_ops;	/* methods */
-	unsigned long		flags;		/* error bits */
-	spinlock_t		private_lock;	/* for use by the address_space */
-	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
-	struct list_head	private_list;	/* for use by the address_space */
-	void			*private_data;	/* ditto */
+	pgoff_t			writeback_index;
+	const struct address_space_operations *a_ops;
+	unsigned long		flags;
 	errseq_t		wb_err;
+	spinlock_t		private_lock;
+	struct list_head	private_list;
+	void			*private_data;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
