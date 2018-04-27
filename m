From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v11 18/63] page cache: Add and replace pages
 using the XArray
Date: Thu, 26 Apr 2018 20:24:23 -0700
Message-ID: <20180427032423.GB14502@bombadil.infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-19-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=pjYqcpQ2U9vaRThDn5rTx7PM6yGCUTfqjUZsJpvN40U=; b=WteAUqJ4EobZL2AyP04B8JsK5b
 TU6obOgh05K++lQX/WSgerjY4YdjHRAQdFgrLAg1JrYGoyZN9f1uyE5dmW0AKs4zr8ZnbyNcGOrNA
 LNmFr23fTB8vGRVbttw2/IgqEb2/NGB64P5lbgTh82oKT2i9AIFGF8/eqMM5vFXzYIdk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=pjYqcpQ2U9vaRThDn5rTx7PM6yGCUTfqjUZsJpvN40U=; b=ajCAo27WgLUeXDyLdNzkymjnkF
 z0D9Samc0zSXzcoc8TyXdKF0l9wOGhGecC2H5AACtWesbQMccZBQ7Qt6ty7z8m6VKjRAfIntVx78w
 ZbDVw6QdZ3zeytzLcmnFpgM4XYyLOzS2Ejckb7kFmVRfeNeWEuAkHJStRg4VxkmN4Z5s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=pjYqcpQ2U9vaRThDn5rTx7PM6yGCUTfqjUZsJpvN40U=; b=lh8jmDOL5AF1jtIpBE4KME6OC
 QOzQ0dWDxac2k8NpfTwwthON3kKYaEp+d8sAzVOymJL/7hEtOrId3o0ZRt4IeBhoiZ6IGOzGzZXqX
 YuN0B9xUelgUxMKTRy97HNdDyBOWjJGEb7wsBfi7ZjKKCBvWL8roL4ywgP6QC7kUwRbPntgxiqUWr
 b73/oLUdT4Xd+ba3UWTG5eSG+ufaz+LYbK3aDquBanolOIAiH4Rfnvu1gtnS7dK2JQOwRRNqEJWuu
 AjcsfqoTWz6kls0F4sBKTDM4ypEqAmq+vzJvB4H2v6IUokzZ0XpAe4ySS64osedmZaDNPY6ekM+5L
 klppOsTxg==;
Content-Disposition: inline
In-Reply-To: <20180414141316.7167-19-willy@infradead.org>
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

On Sat, Apr 14, 2018 at 07:12:31AM -0700, Matthew Wilcox wrote:
> -	xa_lock_irq(&mapping->i_pages);
> -	error = page_cache_tree_insert(mapping, page, shadowp);
> -	radix_tree_preload_end();
> -	if (unlikely(error))
> -		goto err_insert;
> +	do {
> +		xas_lock_irq(&xas);
> +		old = xas_create(&xas);
> +		if (xas_error(&xas))
> +			goto unlock;
> +		if (xa_is_value(old)) {
> +			mapping->nrexceptional--;
> +			if (shadowp)
> +				*shadowp = old;
> +		} else if (old) {
> +			xas_set_err(&xas, -EEXIST);
> +			goto unlock;
> +		}
> +
> +		xas_store(&xas, page);
> +		mapping->nrpages++;

At LSFMM, I was unable to explain in the moment why I was doing
xas_create() followed by xas_store(), rather than just calling
xas_store().  Looking at this code on my laptop, it was immediately
obvious to me -- the semantics of attempting to insert a page into the
page cache when there's already one there is to return -EEXIST.

We could also write this function this way:

+		old = xas_load(&xas);
+		if (old && !xa_is_value(old))
+			xas_set_err(&xas, -EEXIST);
+		xas_store(&xas, page);
+		if (xas_error(&xas))
+			goto unlock;
+		if (old) {
+			mapping->nrexceptional--;
+			if (shadowp)
+				*shadowp = old;
+		}
+		mapping->nrpages++;

which I think is slightly clearer.  Or for those allergic to gotos, the
entire function could look like (option 3):

+       do {
+               xas_lock_irq(&xas);
+               old = xas_load(&xas);
+		if (old && !xa_is_value(old))
+                       xas_set_err(&xas, -EEXIST);
+               xas_store(&xas, page);
+
+               if (!xas_error(&xas)) {
+               	if (old) {
+                       	mapping->nrexceptional--;
+                       	if (shadowp)
+                               	*shadowp = old;
+               	}
+               	mapping->nrpages++;
+
+               	/*
+               	 * hugetlb pages do not participate in
+               	 * page cache accounting.
+               	 */
+               	if (!huge)
+                       	__inc_node_page_state(page, NR_FILE_PAGES);
+		}
+               xas_unlock_irq(&xas);
+       } while (xas_nomem(&xas, gfp_mask & ~__GFP_HIGHMEM));


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
