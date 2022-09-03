From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 18/23] nilfs2: Convert
 nilfs_lookup_dirty_data_buffers() to use filemap_get_folios_tag()
Date: Sun, 4 Sep 2022 02:38:06 +0900
Message-ID: <CAKFNMo=YwdFOQNUuwNvYn6u41C8A2M905-nDkEFRejPZ2_svYg@mail.gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-19-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662226713;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=xX2O58QMupv9rWIX/wz0TD9J8Ed7HqVnisBNPZl6V04=;
	b=jVXkiaz8Gir7sybLH7mheQle2iu6zydWn1BPPQWYmQVl6hx5ZzR71KP5MEshkIQGyqFExL
	Wt6hbgWORgCFZNBEzQRySlSDxKGFKt/R9xV00ulRLSX0TYEyOeebNQCdP392dcXrsr6Fqc
	kT8xH2n8WqlDH2LNU4P/2daNq9vaZAs=
In-Reply-To: <20220901220138.182896-19-vishal.moola@gmail.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Fri, Sep 2, 2022 at 7:07 AM Vishal Moola (Oracle) wrote:
>
> Convert function to use folios throughout. This is in preparation for
> the removal of find_get_pages_range_tag().
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  fs/nilfs2/segment.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 0afe0832c754..e95c667bdc8f 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -680,7 +680,7 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
>                                               loff_t start, loff_t end)
>  {
>         struct address_space *mapping = inode->i_mapping;
> -       struct pagevec pvec;
> +       struct folio_batch fbatch;
>         pgoff_t index = 0, last = ULONG_MAX;
>         size_t ndirties = 0;
>         int i;
> @@ -694,23 +694,26 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
>                 index = start >> PAGE_SHIFT;
>                 last = end >> PAGE_SHIFT;
>         }
> -       pagevec_init(&pvec);
> +       folio_batch_init(&fbatch);
>   repeat:
>         if (unlikely(index > last) ||
> -           !pagevec_lookup_range_tag(&pvec, mapping, &index, last,
> -                               PAGECACHE_TAG_DIRTY))
> +             !filemap_get_folios_tag(mapping, &index, last,
> +                     PAGECACHE_TAG_DIRTY, &fbatch))
>                 return ndirties;
>
> -       for (i = 0; i < pagevec_count(&pvec); i++) {
> +       for (i = 0; i < folio_batch_count(&fbatch); i++) {
>                 struct buffer_head *bh, *head;
> -               struct page *page = pvec.pages[i];
> +               struct folio *folio = fbatch.folios[i];
>
> -               lock_page(page);
> -               if (!page_has_buffers(page))
> -                       create_empty_buffers(page, i_blocksize(inode), 0);
> -               unlock_page(page);

> +               head = folio_buffers(folio);
> +               folio_lock(folio);

Could you please swap these two lines to keep the "head" check in the lock?

Thanks,
Ryusuke Konishi


> +               if (!head) {
> +                       create_empty_buffers(&folio->page, i_blocksize(inode), 0);
> +                       head = folio_buffers(folio);
> +               }
> +               folio_unlock(folio);
>
> -               bh = head = page_buffers(page);
> +               bh = head;
>                 do {
>                         if (!buffer_dirty(bh) || buffer_async_write(bh))
>                                 continue;
> @@ -718,13 +721,13 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
>                         list_add_tail(&bh->b_assoc_buffers, listp);
>                         ndirties++;
>                         if (unlikely(ndirties >= nlimit)) {
> -                               pagevec_release(&pvec);
> +                               folio_batch_release(&fbatch);
>                                 cond_resched();
>                                 return ndirties;
>                         }
>                 } while (bh = bh->b_this_page, bh != head);
>         }
> -       pagevec_release(&pvec);
> +       folio_batch_release(&fbatch);
>         cond_resched();
>         goto repeat;
>  }
> --
> 2.36.1
>

