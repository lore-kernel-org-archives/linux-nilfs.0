From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 70/74] page cache: Finish XArray conversion
Date: Sat, 16 Jun 2018 19:00:48 -0700
Message-ID: <20180617020052.4759-71-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=LeMKahj/PRRicsA35gt3pl12oVGucoAeWFm4Rznk8kI=; b=OtMrRQSdBaG2L7odCr68d5HXut
 d+0HRlT2VxVTZ7kTRN6HTX7TPa8+sXvBhYRhpSUgUz80lpOBoA4QsfhQBUfMz5HAHm+8seKdoFJ5G
 V9Abf6A0/KQkbCHUqAWo1U7pCHDbLKvJmQeEvpF0/CQhvEFXjzBwClPMW+ga2R8wTBgc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=LeMKahj/PRRicsA35gt3pl12oVGucoAeWFm4Rznk8kI=; b=Zzq2YN5gWF70T9Kuy8q0RJgEeO
 osvUX5xeCxHMbzxkcq0AFXqP4Pk7RBPyRgBbnPa4OWfvXCANYAru5Pz1P0A2ibWV2o4IvxEHGfKsk
 egtuUz8qTueOK6DWkcsz2kKF9BvA3wlWMLkd2v5qPe9y2LzWVXS4HeMLXsUqVDowL7JE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=LeMKahj/PRRicsA35gt3pl12oVGucoAeWFm4Rznk8kI=; b=L0zQsAnKQFSFlP3s4Uy7N75+1
 nPC4veNqYhTZLIm1yjdBG+P6y3GcDSB2X9TGr+5MrJDgw/DNWH3i0UBTn/GipemFOLO/glEMXyBqd
 ILhchaMO4//6rB+Grco2oSAKKl/oyajy7B7vWxpILaRurOWbPMhitMD54hpel9HFj7b6fFyPWkAAa
 XA6NPtza3i2uZcZbm1gi3gtHWo0oRwbBU9j/whTZWYiE+vBIRlsXjvBI7zGFDtmkO6Febfx4viKX1
 FRnEEeAZe0dsRtQNsgXVyePntwpIa84EzsioDduDmJjoDn2T4Y0p35yN3dAfYvngIMAi1VaZYSVvw
 50CcmW4LA==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

With no more radix tree API users left, we can drop the GFP flags
and use xa_init() instead of INIT_RADIX_TREE().

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/inode.c      | 2 +-
 mm/swap_state.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 077a6174dfd5..8ab03bf193a4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -349,7 +349,7 @@ EXPORT_SYMBOL(inc_nlink);
 
 static void __address_space_init_once(struct address_space *mapping)
 {
-	INIT_RADIX_TREE(&mapping->i_pages, GFP_ATOMIC | __GFP_ACCOUNT);
+	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5cd42d05177e..3d813d2b5dff 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -596,7 +596,7 @@ int init_swap_address_space(unsigned int type, unsigned long nr_pages)
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
 		space = spaces + i;
-		INIT_RADIX_TREE(&space->i_pages, GFP_ATOMIC|__GFP_NOWARN);
+		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
 		atomic_set(&space->i_mmap_writable, 0);
 		space->a_ops = &swap_aops;
 		/* swap cache doesn't use writeback related tags */
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
