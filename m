From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 60/63] page cache: Finish XArray conversion
Date: Sat, 14 Apr 2018 07:13:13 -0700
Message-ID: <20180414141316.7167-61-willy@infradead.org>
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
 bh=t982aATI1KUU8A/cOs32vyhE+b75xD9UG9ZnYsA24FY=; b=c7X4XlsvLTifae75hBIWZOtWoc
 Z1Lc+iC2kfPHGI0DgP8iqh4C1y9nXXKQtBtKklOIKHvI8uGK2nDUrRPL+hHOianv9bU3gmoGclxWM
 6XtdDth8b4BOvWabDaInBeUcph9DzGoPwn6/WT88Pcl+IB0NNsA6t1ij+N0H0FD+ACKo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=t982aATI1KUU8A/cOs32vyhE+b75xD9UG9ZnYsA24FY=; b=nJpohzu9JPMZBOY7mTV4dhB2FZ
 7BoHz1IbaUfd4ORTWkJdm+CgilKNGJ6m2LI0zzRUq5eCW/QjKtSRzJjHDkm3lm4il9XsECdBTQgd/
 hNxnYVR56w8vUKqCo17253rnqFvb2chJ+YTh9+sbtfBtQp6KpPixlfqFmI87k3S6NoWw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=t982aATI1KUU8A/cOs32vyhE+b75xD9UG9ZnYsA24FY=; b=tuWAnQwIOsYaIfmcpnAHrVe84
 eXaM76L7q0pl3LJ1XrCj8PEyajhfKook6cRrBeYEfPif0kpqx+WbsCbLrzxwyfATXL4X+V4bdyJ0E
 okn26Gj/eQ2eQKrHNLjKcGmiukCrVzXwVUwpTMFToJDhQjbYhbH1pQlWO1ULMBgT/IFej8et1fVzc
 5bzwmBH2ZMecRgj4CKYW4Pch4pZZyGUtDunnTHmct6Os4njHdhh5zy7+vexFTDP4pVc8cb3nOwgb8
 BNCSLqaqs36+DZtlRxHEgL+nkUunki/VLNvUbM39ZwYJNnxc1/sck19gQ3dF08lptGhrt0fisTJmJ
 k/s36GLcw==;
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

With no more radix tree API users left, we can drop the GFP flags
and use xa_init() instead of INIT_RADIX_TREE().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/inode.c      | 2 +-
 mm/swap_state.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 13ceb98c3bd3..d40c1c16febe 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(inc_nlink);
 
 static void __address_space_init_once(struct address_space *mapping)
 {
-	INIT_RADIX_TREE(&mapping->i_pages, GFP_ATOMIC | __GFP_ACCOUNT);
+	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a0a562fbc65f..208a95ad00e6 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -599,7 +599,7 @@ int init_swap_address_space(unsigned int type, unsigned long nr_pages)
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
 		space = spaces + i;
-		INIT_RADIX_TREE(&space->i_pages, GFP_ATOMIC|__GFP_NOWARN);
+		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
 		atomic_set(&space->i_mmap_writable, 0);
 		space->a_ops = &swap_aops;
 		/* swap cache doesn't use writeback related tags */
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
