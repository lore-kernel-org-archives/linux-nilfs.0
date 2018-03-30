From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 37/62] shmem: Convert shmem_confirm_swap to
 XArray
Date: Thu, 29 Mar 2018 20:42:20 -0700
Message-ID: <20180330034245.10462-38-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=KuOjcPlTQ9KpziGyEx+C7mqN9cLTotY5ZX0wX57D+RM=; b=h3WV0XLhHw74wnh+SPBsAXNFfK
 zMynRAsx2FbMTgXc4oIMS9AHaOIxcYPgXBbdxTPegbJ/Wfz8r6Po5JEvGnigPV7oagHLjEy9aurMy
 /46MCJvJlkZcArBXfr7wcCtt9rGIOtrCEop8OXq2T9pboT5GkHh21ktnPNsTYk6UPonI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=KuOjcPlTQ9KpziGyEx+C7mqN9cLTotY5ZX0wX57D+RM=; b=i0GLsFj34V5MKIyo+FVWAP707h
 oKwgY4ei5U78vNjT/kk4OrG3yyC6GmWmV4xzcI5/5/Xc+e5fN1kS40Q0mDj+eHOKHUtkAoR03T9zU
 PTQzMblP1Gb4+CwAOllPgw6gtozqsKvkZKCZBNnZ1D5Zh3zZ9Ku0k8q0AeBm+y+bo1SI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=KuOjcPlTQ9KpziGyEx+C7mqN9cLTotY5ZX0wX57D+RM=; b=TTLrp2zUqlWT3dybaZo7SFki1
 h9LhUyCviMKTncQBdeYkb48+o0ivia8mVPbw5sFoYp+tbgUfc1KPojRUJPChS6EozOwaXwXC8ygaP
 tDh1r1eYEKWflQ+GuXl+ALg8xQrIIFeKKd1ro1QHwhIvFZJ7uOVEY4WJX8IZ0o/MQKIPGJH5wDKPW
 E/F7/GXyaKXuxiinxp5mUVxIuKjN0/qs0E5hLWH2hdSYu4XsFQ2qO5S/T37JbF5mRxTs9lRlaBSLX
 +YV5nSjUUwRvF+5ONQLuTBar+AqtU/5ZNjcZ1C6YbWX1FAepDTiOYfsJUBFI/kbHJQiczfTFkrHBX
 NrMG9IhfA==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
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

xa_load has its own RCU locking, so we can eliminate it here.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fced882e0b7a..4b66bcedd21c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -348,12 +348,7 @@ static int shmem_xa_replace(struct address_space *mapping,
 static bool shmem_confirm_swap(struct address_space *mapping,
 			       pgoff_t index, swp_entry_t swap)
 {
-	void *item;
-
-	rcu_read_lock();
-	item = radix_tree_lookup(&mapping->i_pages, index);
-	rcu_read_unlock();
-	return item == swp_to_radix_entry(swap);
+	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
 }
 
 /*
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
