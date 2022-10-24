From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 02/23] filemap: Added
 filemap_get_folios_tag()
Date: Mon, 24 Oct 2022 20:42:29 +0100
Message-ID: <Y1bqpYNvnxmZL+KW@casper.infradead.org>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-3-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666640577;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=59TRiYUXIr5hwsRyZRrFskT3Jp1v+y3YCFk34nmAHUA=;
	b=AMBen2vZ4EVUuUintI/JlKuY69niou9Epp2xsjQofd09RrL08JwZjYftTvh14asQXHFohZ
	YALNOqEC1azD2k7a9uWzhdNkQ9zZrnqFOQLNDH5703uzIkGdEvaiUC4Gn9N7UzF8K1nqIQ
	DphpaFXVvsuu16UbKWEjkXQirsvqsNs=
In-Reply-To: <20221017202451.4951-3-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Mon, Oct 17, 2022 at 01:24:30PM -0700, Vishal Moola (Oracle) wrote:
> This is the equivalent of find_get_pages_range_tag(), except for folios
> instead of pages.
> 
> One noteable difference is filemap_get_folios_tag() does not take in a
> maximum pages argument. It instead tries to fill a folio batch and stops
> either once full (15 folios) or reaching the end of the search range.
> 
> The new function supports large folios, the initial function did not
> since all callers don't use large folios.

Reviewed-by: Matthew Wilcow (Oracle) <willy@infradead.org>

> +/**
> + * filemap_get_folios_tag - Get a batch of folios matching @tag.
> + * @mapping:    The address_space to search
> + * @start:      The starting page index
> + * @end:        The final page index (inclusive)
> + * @tag:        The tag index
> + * @fbatch:     The batch to fill
> + *
> + * Same as filemap_get_folios, but only returning folios tagged with @tag

If you add () after filemap_get_folios, it turns into a nice link in
the html documentation.

> + *
> + * Return: The number of folios found

Missing full stop at the end of this line.

> + * Also update @start to index the next folio for traversal

Ditto.

> + */
> +unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
> +			pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch)
> +{
> +	XA_STATE(xas, &mapping->i_pages, *start);
> +	struct folio *folio;
> +
> +	rcu_read_lock();
> +	while ((folio = find_get_entry(&xas, end, tag)) != NULL) {
> +		/* Shadow entries should never be tagged, but this iteration
> +		 * is lockless so there is a window for page reclaim to evict
> +		 * a page we saw tagged. Skip over it.
> +		 */

For multiline comments, the "/*" should be on a line by itself.

