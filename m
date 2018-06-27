From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v14 00/74] Convert page cache to XArray
Date: Wed, 27 Jun 2018 04:05:29 -0700
Message-ID: <20180627110529.GA19606@bombadil.infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
 <20180619031257.GA12527@linux.intel.com>
 <20180619092230.GA1438@bombadil.infradead.org>
 <20180619164037.GA6679@linux.intel.com>
 <20180619171638.GE1438@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=AAlExSFvFVxQo8Umv+Bv+kndvRO1cNE2u5Zfi2qlroU=; b=ekfVTTHwYtstQGoAaLo/XbgDKr
 uEUW/EzDAmETTr0tSOYtaMnb6537geVgLF0IVs7FS3LyfMRhzPOMKnqC/40/+CnjsHM4YlrirNtFF
 bKzpxKlUnRZTlvQ5h4Hb8W839dNvtQX6qcJ40wCbn2Hvb3M4y2/fk1EAxxEP2SBIitfQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:
 From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=AAlExSFvFVxQo8Umv+Bv+kndvRO1cNE2u5Zfi2qlroU=; b=WL5x119n2+ks1cAygmpZyXPV72
 6XhMMPhQ0tLEtPkbN95bm8OUe66oGAxTvUKEpDTt+cf7epw5w5baYsQ7BvxH+VgesRAtBqFxl3gOS
 uzociqQ/3obRJNrI70XWouAgB0M8su1162Q9CP3Dkj3tDO0sLrVtA5v4szx/b5c1NRTg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=AAlExSFvFVxQo8Umv+Bv+kndvRO1cNE2u5Zfi2qlroU=; b=glmVDMt45pfxpDWnWVSBQ0Aab
 l7me4qHFaH2HJzvMynUprc/NyGAXlkyq6TyRwSroV7mu1Oczni0MCMFvDZk0dH8SX53z2IqKBi7bY
 Qm9vbGc5L73nnJut9FAU0Lf4JH+DpQbftr76NOYx5tkH8/xPIL4146oM6/nirinxusEAKCRt8nY2Y
 t15pQsuDof3eAq8s81IodNun/Q5kBwG4IiYSc2QOKg9aKasY6nL0gl5/zbyh4emFJNa1yCvrKZb6O
 C5BdYobNlS1Pfdb+Hrzb2sBnQnzGebn8RCyuJ7bVmQ4XDoV5idK6ywPLpFvMs9ootG9djDhnOt3WZ
 SMD3y2wgw==;
Content-Disposition: inline
In-Reply-To: <20180619171638.GE1438@bombadil.infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

On Tue, Jun 19, 2018 at 10:16:38AM -0700, Matthew Wilcox wrote:
> I think I see a bug.  No idea if it's the one you're hitting ;-)
> 
> I had been intending to not use the 'entry' to decide whether we were
> waiting on a 2MB or 4kB page, but rather the xas.  I shelved that idea,
> but not before dropping the DAX_PMD flag being passed from the PMD
> pagefault caller.  So if I put that back ...

Did you get a chance to test this?

> diff --git a/fs/dax.c b/fs/dax.c
> index 9919b6b545fb..75cc160d2f0b 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -367,13 +367,13 @@ static struct page *dax_busy_page(void *entry)
>   * a VM_FAULT code, encoded as an xarray internal entry.  The ERR_PTR values
>   * overlap with xarray value entries.
>   */
> -static
> -void *grab_mapping_entry(struct xa_state *xas, struct address_space *mapping)
> +static void *grab_mapping_entry(struct xa_state *xas,
> +		struct address_space *mapping, unsigned long size)
>  {
>  	bool pmd_downgrade = false; /* splitting 2MiB entry into 4k entries? */
>  	void *locked = dax_make_entry(pfn_to_pfn_t(0),
> -						DAX_EMPTY | DAX_LOCKED);
> -	void *unlocked = dax_make_entry(pfn_to_pfn_t(0), DAX_EMPTY);
> +						size | DAX_EMPTY | DAX_LOCKED);
> +	void *unlocked = dax_make_entry(pfn_to_pfn_t(0), size | DAX_EMPTY);
>  	void *entry;
>  
>  retry:
> @@ -1163,7 +1163,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	if (write && !vmf->cow_page)
>  		flags |= IOMAP_WRITE;
>  
> -	entry = grab_mapping_entry(&xas, mapping);
> +	entry = grab_mapping_entry(&xas, mapping, 0);
>  	if (xa_is_internal(entry)) {
>  		ret = xa_to_internal(entry);
>  		goto out;
> @@ -1396,7 +1396,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	 * page is already in the tree, for instance), it will return
>  	 * VM_FAULT_FALLBACK.
>  	 */
> -	entry = grab_mapping_entry(&xas, mapping);
> +	entry = grab_mapping_entry(&xas, mapping, DAX_PMD);
>  	if (xa_is_internal(entry)) {
>  		result = xa_to_internal(entry);
>  		goto fallback;
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
