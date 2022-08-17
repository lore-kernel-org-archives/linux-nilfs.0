From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 5/7] nilfs2: Convert nilfs_find_uncommited_extent() to
 use filemap_get_folios_contig()
Date: Wed, 17 Aug 2022 13:33:27 +0900
Message-ID: <CAKFNMome2DoupJxiNT4YtuMDLUgUD1aevHSExd+M+Q+ghXwaEw@mail.gmail.com>
References: <20220816175246.42401-1-vishal.moola@gmail.com> <20220816175246.42401-6-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nOdb6n13ohDqgquF5+hz9jSYLtO6Hr9UX14Xr/YTGlM=;
        b=dMkCJ8QcXk8CCKs+JMzTMBHDLD4h16lKjhPfa818z1aMbkmqmpn4lSJ/hn0QuEWAWS
         OdymGqhTo4Pn/bNpk8llqrNNi6dl8VAXbfkDlgq0LGsfqFbAcRfU/QkVvvQTJ7XjPdlo
         G+V2u884J/ZowvVBoBep11BxqGF+P30pLFDrYUsxDKLvHcyrL3YTPIhXXvypH5+ZedHM
         Q6nLlNLv4ELt/1W812op/++Q7j7T/KiIOBtNGNFaXYckan6OxeLrFHGSmGqS9Sv/ONIM
         vOholq/pwx6EFwcprMgfhLQiGkgA1WhOigSaEZYsgkNRN8sM2DbUANkpN8czCaKsVb/N
         LnWg==
In-Reply-To: <20220816175246.42401-6-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 17, 2022 at 2:54 AM Vishal Moola (Oracle)  wrote:
>
> Converted function to use folios throughout. This is in preparation for
> the removal of find_get_pages_contig(). Now also supports large folios.
>
> Also cleaned up an unnecessary if statement - pvec.pages[0]->index > index
> will always evaluate to false, and filemap_get_folios_contig() returns 0 if
> there is no folio found at index.
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>
> v2:
>   - Fixed a warning regarding a now unused label "out"
>   - Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/page.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 3267e96c256c..14629e03d0da 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -480,13 +480,13 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
>                                             sector_t start_blk,
>                                             sector_t *blkoff)
>  {
> -       unsigned int i;
> +       unsigned int i, nr;
>         pgoff_t index;
>         unsigned int nblocks_in_page;
>         unsigned long length = 0;
>         sector_t b;
> -       struct pagevec pvec;
> -       struct page *page;
> +       struct folio_batch fbatch;
> +       struct folio *folio;
>
>         if (inode->i_mapping->nrpages == 0)
>                 return 0;
> @@ -494,27 +494,24 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
>         index = start_blk >> (PAGE_SHIFT - inode->i_blkbits);
>         nblocks_in_page = 1U << (PAGE_SHIFT - inode->i_blkbits);
>
> -       pagevec_init(&pvec);
> +       folio_batch_init(&fbatch);
>
>  repeat:
> -       pvec.nr = find_get_pages_contig(inode->i_mapping, index, PAGEVEC_SIZE,
> -                                       pvec.pages);
> -       if (pvec.nr == 0)
> +       nr = filemap_get_folios_contig(inode->i_mapping, &index, ULONG_MAX,
> +                       &fbatch);
> +       if (nr == 0)
>                 return length;
>
> -       if (length > 0 && pvec.pages[0]->index > index)
> -               goto out;
> -
> -       b = pvec.pages[0]->index << (PAGE_SHIFT - inode->i_blkbits);
> +       b = fbatch.folios[0]->index << (PAGE_SHIFT - inode->i_blkbits);
>         i = 0;
>         do {
> -               page = pvec.pages[i];
> +               folio = fbatch.folios[i];
>
> -               lock_page(page);
> -               if (page_has_buffers(page)) {
> +               folio_lock(folio);
> +               if (folio_buffers(folio)) {
>                         struct buffer_head *bh, *head;
>
> -                       bh = head = page_buffers(page);
> +                       bh = head = folio_buffers(folio);
>                         do {
>                                 if (b < start_blk)
>                                         continue;
> @@ -532,18 +529,16 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
>

>                         b += nblocks_in_page;

Here, It looks like the block index "b" should be updated with the
number of blocks in the
folio because the loop is now per folio, not per page.

Instead of replacing it with a calculation that uses folio_size(folio)
or folio_shift(folio),
I think it would be better to move the calculation of "b" inside the
branch where the folio
has buffers as follows:

                if (folio_buffers(folio)) {
                        struct buffer_head *bh, *head;
                        sector_t b;

                        b = folio->index << (PAGE_SHIFT - inode->i_blkbits);
                        bh = head = folio_buffers(folio);
                        ...
               } else if (length > 0) {
                       goto out_locked;
               }

This way, we can remove calculations for the block index "b" outside
the above part
and the variable "nblocks_in_page" as well.

Thanks,
Ryusuke Konishi

>                 }
> -               unlock_page(page);
> +               folio_unlock(folio);
>
> -       } while (++i < pagevec_count(&pvec));
> +       } while (++i < nr);
>
> -       index = page->index + 1;
> -       pagevec_release(&pvec);
> +       folio_batch_release(&fbatch);
>         cond_resched();
>         goto repeat;
>
>  out_locked:
> -       unlock_page(page);
> -out:
> -       pagevec_release(&pvec);
> +       folio_unlock(folio);
> +       folio_batch_release(&fbatch);
>         return length;
>  }
> --
> 2.36.1
>
