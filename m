From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 8/9] btrfs: handle a NULL folio in
 extent_range_redirty_for_io
Date: Wed, 18 Jan 2023 16:08:57 +0000
Message-ID: <Y8gZmTFB6vCivxsY@casper.infradead.org>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-9-hch@lst.de>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674058165;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=JEUOAZ78kJr603e3fslTqPJIm0KVjgSmMPI95SNsLdQ=;
	b=VXkkdbeaoJ3mAdZuFf1FOwnu7prX8Cr2mZ31LOf2CdTuG/zd4wyFBU8FMgEs//lKJ4GDV9
	WxDSS78KHiiXHoSQON+KpNT/gj3IzsUnknJretWFOCmDpBlLqnB6B1b/PfevQ5Vo7jkZK6
	wA4HS1PbYYYSkw6Dp1kqRGjS2pkJu2E=
In-Reply-To: <20230118094329.9553-9-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Jan 18, 2023 at 10:43:28AM +0100, Christoph Hellwig wrote:
> filemap_get_folio can return NULL, skip those cases.

Hmm, I'm not sure that's true.  We have one place that calls
extent_range_redirty_for_io(), and it previously calls
extent_range_clear_dirty_for_io() which has an explicit

                BUG_ON(!page); /* Pages should be in the extent_io_tree */

so I'm going to say this one can't happen either.  I haven't delved far
enough into btrfs to figure out why it can't happen.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/extent_io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d55e4531ffd212..a54d2cf74ba020 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -230,6 +230,8 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
>  
>  	while (index <= end_index) {
>  		folio = filemap_get_folio(mapping, index);
> +		if (!folio)
> +			continue;
>  		filemap_dirty_folio(mapping, folio);
>  		folio_account_redirty(folio);
>  		index += folio_nr_pages(folio);
> -- 
> 2.39.0
> 

