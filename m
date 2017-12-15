From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 61/78] dax: Convert
 __dax_invalidate_mapping_entry to XArray
Date: Fri, 15 Dec 2017 14:04:33 -0800
Message-ID: <20171215220450.7899-62-willy@infradead.org>
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
 bh=yyg9GwGijNepWmDuuPGXIREk1oB9BbBSB674iPSyOjo=; b=TtU5am3k4rvvhlVqki51WpDOe5
 aILR/kogiXnQbtUEF5IRpNalYE/Ipq9nETfmZ9K6ib4GY7/s1GyO3Psjkrd2zEKjusnn9ikYKu6Nb
 TD9UHh+rL8/P5tAbKCrH5Mv4br3YILZYNk252BYjTrnWN+faPmYznUsB/vQUHrEyqsFI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=yyg9GwGijNepWmDuuPGXIREk1oB9BbBSB674iPSyOjo=; b=anRNN6F70JtvVEYpN+nb5JvVKl
 D2vElYhBoMGKSQ9uIOwU7oXzj4xqlmZDA9tZDq26wGJbt3yB79ilOyTR9j1sDWhNTwkx+jL8dWAzd
 uGqGeUvo6TTPx4xAIjDvbBwv0cqmFO9oKe+9mXR6D5XPc6+vE5etGS1VUbGio7xRjPcw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=yyg9GwGijNepWmDuuPGXIREk1oB9BbBSB674iPSyOjo=; b=Sp5KMkSpREEpzygKvSpuuheY+
 38tVO48nM/TLJ3MzAv1FycLNSzCkbYXleiQUWv48CDCVXjXwmlA/3ZnKcKxJc+L9uBjPvYHuzzc8k
 uoj4A8qzEVbHNg8HqoulgD2plNOOVwoJO9pfUQubJBGswHRlw6tfXOWxlm1sa+V32QJoQSt+rUsqO
 lBxmm1LvV4c7knR3jnVbZFO/vFQGaMClPpvENHxEDFqhmrEgkqV3VyqXup9F4AphJBX91P8vF7iyf
 ahZ38g6+M172PEIlB4YTKj9Kvgcu4N8Hk/Nbn1MqsJKTvH63AuJv/FVk/SsTOZly0ZbditgaNP4T2
 QLMyk2HKg==;
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

Simple now that we already have an xa_state!

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 2629ffa70575..d3894c15609a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -413,24 +413,24 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	XA_STATE(xas, &mapping->pages, index);
 	int ret = 0;
 	void *entry;
-	struct radix_tree_root *pages = &mapping->pages;
 
 	xa_lock_irq(&mapping->pages);
 	entry = get_unlocked_mapping_entry(&xas);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
-	    (radix_tree_tag_get(pages, index, PAGECACHE_TAG_DIRTY) ||
-	     radix_tree_tag_get(pages, index, PAGECACHE_TAG_TOWRITE)))
+	    (xas_get_tag(&xas, PAGECACHE_TAG_DIRTY) ||
+	     xas_get_tag(&xas, PAGECACHE_TAG_TOWRITE)))
 		goto out;
-	radix_tree_delete(pages, index);
+	xas_store(&xas, NULL);
 	mapping->nrexceptional--;
 	ret = 1;
 out:
 	put_unlocked_mapping_entry(&xas, entry);
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	return ret;
 }
+
 /*
  * Delete DAX entry at @index from @mapping.  Wait for it
  * to be unlocked before deleting it.
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
