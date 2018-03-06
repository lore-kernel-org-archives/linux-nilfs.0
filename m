From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 08/63] fscache: Use appropriate radix tree accessors
Date: Tue,  6 Mar 2018 11:23:18 -0800
Message-ID: <20180306192413.5499-9-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gTwaAOmkxOUrfIJir/pggY0Nw3BL5DZX3vgbsCoydCU=; b=LL25MKlQyoMas0TIqXwdBy/Zb
        CC+RdB9ERpDEVlXsvPZG526LhQMMP+SXFro7+jNNX50z/FPTI2G1l+Xu69RZ+dGD/5UfKn1Now+7v
        9qW8viPP7XW13aqNn359eOl2rm6fPd7kYNVdRX84+YhYYH9exinRf9/KpHtavLsBKFfwORM7kNbEa
        V6aYY35lUOKTlTykDxPCup4LYlgXngSikvacEVGP9SwxP2bSlUMf7Fuw6nPdSq27xkvCytw+VgsHG
        qJzMULoQCKjdhwnbWQiEeUkmJmiAlFT4h5o5uhm5Npmj+RhUnMI5hxMQ2A0o0FI8+31P2cxpSNWn3
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Don't open-code accesses to data structure internals.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fscache/cookie.c | 2 +-
 fs/fscache/object.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index ff84258132bb..e9054e0c1a49 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -608,7 +608,7 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, bool retire)
 	/* Clear pointers back to the netfs */
 	cookie->netfs_data	= NULL;
 	cookie->def		= NULL;
-	BUG_ON(cookie->stores.rnode);
+	BUG_ON(!radix_tree_empty(&cookie->stores));
 
 	if (cookie->parent) {
 		ASSERTCMP(atomic_read(&cookie->parent->usage), >, 0);
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 7a182c87f378..aa0e71f02c33 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -956,7 +956,7 @@ static const struct fscache_state *_fscache_invalidate_object(struct fscache_obj
 	 * retire the object instead.
 	 */
 	if (!fscache_use_cookie(object)) {
-		ASSERT(object->cookie->stores.rnode == NULL);
+		ASSERT(radix_tree_empty(&object->cookie->stores));
 		set_bit(FSCACHE_OBJECT_RETIRED, &object->flags);
 		_leave(" [no cookie]");
 		return transit_to(KILL_OBJECT);
-- 
2.16.1

