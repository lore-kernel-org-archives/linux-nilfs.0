From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 05/78] xarray: Replace exceptional entries
Date: Tue, 26 Dec 2017 20:15:42 +0300
Message-ID: <20171226171542.v25xieedd46y5peu@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-6-willy@infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jr8NOOxzIubYLIHdqXXUoaf9tR/vdjl0sKdW7zQqqd8=;
        b=E4xnHI39EM8KXHPwcmynrpFW26m7Qgq3qc0sMVvfLS++BfVf32AL9ttMuM3vfYUdAN
         iz+Y9R2bErgdgFZaW68iqk3Rvsnd4+t5/LSvhRTmAJjfMRVds6uQYjFPJQtCeO7vGgIx
         BkWCxlVF+UA2SDlgq2wDbw6iAXM0svM6lRTDc3+sEWK+YZGxmABUAmfaOl3h9n74TiAn
         r73S9rAnZvud0jEPuvAX3z62EoUjGbUkWYXzdHlWFRkF1TXargiKKkPmrZ8ELtO9bnS2
         4KXXGkHJ31wMfgJBynIWx7vk8zNpavjhuY0xYN6HRrv+6PGVv//CBg/lXtGXt54/9XD5
         Wu1Q==
Content-Disposition: inline
In-Reply-To: <20171215220450.7899-6-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Fri, Dec 15, 2017 at 02:03:37PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Introduce xarray value entries to replace the radix tree exceptional
> entry code.  This is a slight change in encoding to allow the use of an
> extra bit (we can now store BITS_PER_LONG - 1 bits in a value entry).
> It is also a change in emphasis; exceptional entries are intimidating
> and different.  As the comment explains, you can choose to store values
> or pointers in the xarray and they are both first-class citizens.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h    |   4 +-
>  arch/powerpc/include/asm/nohash/64/pgtable.h    |   4 +-
>  drivers/gpu/drm/i915/i915_gem.c                 |  17 ++--
>  drivers/staging/lustre/lustre/mdc/mdc_request.c |   2 +-
>  fs/btrfs/compression.c                          |   2 +-
>  fs/btrfs/inode.c                                |   4 +-
>  fs/dax.c                                        | 115 ++++++++++++------------
>  fs/proc/task_mmu.c                              |   2 +-
>  include/linux/fs.h                              |  48 ++++++----
>  include/linux/radix-tree.h                      |  36 ++------
>  include/linux/swapops.h                         |  19 ++--
>  include/linux/xarray.h                          |  40 +++++++++
>  lib/idr.c                                       |  63 ++++++-------
>  lib/radix-tree.c                                |  21 ++---
>  mm/filemap.c                                    |  10 +--
>  mm/khugepaged.c                                 |   2 +-
>  mm/madvise.c                                    |   2 +-
>  mm/memcontrol.c                                 |   2 +-
>  mm/mincore.c                                    |   2 +-
>  mm/readahead.c                                  |   2 +-
>  mm/shmem.c                                      |  10 +--
>  mm/swap.c                                       |   2 +-
>  mm/truncate.c                                   |  12 +--
>  mm/workingset.c                                 |  12 ++-
>  tools/testing/radix-tree/idr-test.c             |   6 +-
>  tools/testing/radix-tree/linux/radix-tree.h     |   1 +
>  tools/testing/radix-tree/multiorder.c           |  47 +++++-----
>  tools/testing/radix-tree/test.c                 |   2 +-
>  28 files changed, 249 insertions(+), 240 deletions(-)

Everything looks fine to me after quick scan, but hat's a lot of changes for
one patch...

> @@ -565,7 +565,7 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
>  			if (index > end)
>  				break;
>  
> -			if (radix_tree_exceptional_entry(page)) {
> +			if (xa_is_value(page)) {
>  				invalidate_exceptional_entry(mapping, index,
>  							     page);
>  				continue;
> @@ -696,7 +696,7 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
>  			if (index > end)
>  				break;
>  
> -			if (radix_tree_exceptional_entry(page)) {
> +			if (xa_is_value(page)) {
>  				if (!invalidate_exceptional_entry2(mapping,
>  								   index, page))
>  					ret = -EBUSY;

invalidate_exceptional_entry? Are we going to leave the terminology here as is?

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
