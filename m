From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 02/78] fscache: Use appropriate radix tree
 accessors
Date: Fri, 15 Dec 2017 14:03:34 -0800
Message-ID: <20171215220450.7899-3-willy@infradead.org>
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
 bh=vfTHNsdwFGpi7ydpzSJRnXEUDiapLKw7OJTphxv2dNs=; b=gqm2/ILZa5PD6kWhtlm0mid1O+
 vjIStnHlVsyfFWj8RBRDEEWWM9CR5MM5aRZYkdNkrMbZiABjM52O/eynkjV3d9pewuZht8y9rICvR
 xOosPKJC5vYIxEsfO4/EVHHCd691Ap9p6L3Qy7yQxG1ElGOXPcdjJ6BZqn33NfVTlaWY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=vfTHNsdwFGpi7ydpzSJRnXEUDiapLKw7OJTphxv2dNs=; b=e45/Z2XO1qivDFDzXHbA68F8fN
 Ig0bErs87bp0QjbTZ+krmKUXYeJOKMqCFAzNpEDduQ1N8uACz7xF34fPFKJkY262OcPHhjnygd0hv
 4s/Na/KvB5nlhhBji7eS8oJQwNc3V2q1oiss3ChNPGzrVOchAEffaPnTR1GnEpTk7k70=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=vfTHNsdwFGpi7ydpzSJRnXEUDiapLKw7OJTphxv2dNs=; b=JDEjPuRy59r+sWiuU0gfec/A3
 rg347JNkoauS1M8Ca4KZkr61Pr8HPCEwLfxFVdP2XynP0sjNLF6BVbY3ubY5zadsvoj2inJK5Tusn
 PTZ023LZ1vPJN+WmUL3SLTvltHA8iSAW+mlxR83a4mWkewwF4dQnzuinDvZ8jSxatxg0EVU3ty9lM
 JOegjQNZbYpW4dD2TYFbuDNQhdq+aLBsc3TJQlmQq/hed7YY7uhYCNwnj40pD7aS5nS+aF42aTTU+
 69EVis2JSZhzY1GdqTdrRoNQNUquq1QssWsORTAHUoOWHZ4U4ZPSg/ioF8JYZ5MP/ZUeJ/Pc7uvRI
 3eQaNSKQg==;
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

Don't open-code accesses to data structure internals.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
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
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
