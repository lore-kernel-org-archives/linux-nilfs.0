From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [dm-devel] [PATCH 01/19] fs: remove mpage_alloc
Date: Wed, 23 Mar 2022 18:29:23 +0900
Message-ID: <CAKFNMonANUN7_99oVBOq=iCJpt6jQs3qhu1ez5SwMm2g7sZUyw@mail.gmail.com>
References: <20220124091107.642561-1-hch@lst.de> <20220124091107.642561-2-hch@lst.de>
 <20220322211915.GA2413063@roeck-us.net> <CAKFNMonRd5QQMzLoH3T=M=C=2Q_j9d86EYzZeY4DU2HQAE3E8w@mail.gmail.com>
 <20220323064248.GA24874@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RTdntLwWP7UcoqdxIbtO2gBEwkCYFZ/lgUjrNqmrzxY=;
        b=T61hvAd7cJiSJIGmZk3tv26qPToF8HN5U/lQ/m08EAvWa2SmtE6To2nDTNf374lnhT
         GPKcxTCuuPtJXa5gmEw+gX2f1CnhO+VLeiTWr2XmuaL6dVuTtvBLqYJtSXHPPzFlHs5d
         Ri/6Ne7YUODQm8T3VMLlOYE4KOjFASZnLeZ8IqhaE9iuhu7q9KNKFvXczv/h7Sgwfpuk
         P+Ovst/9RkkokTnzdrENQ2gJQlJX7TsW9sSFizNo9ppyZqVHj+5ghhwpu4GTzkQKNuQt
         kjsxCrJT+nOf4qUF+msiy+R5Tj/zMWQPy3RSPf7HIGYLtyZhwIakdPpQAIpFcLhlFiZB
         DguA==
In-Reply-To: <20220323064248.GA24874@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Philipp Reisner <philipp.reisner@linbit.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>, device-mapper development <dm-devel@redhat.com>, "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev, Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com

On Wed, Mar 23, 2022 at 3:42 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Mar 23, 2022 at 06:38:22AM +0900, Ryusuke Konishi wrote:
> > This looks because the mask of GFP_KERNEL is removed along with
> > the removal of mpage_alloc().
> >
>
> > The default value of the gfp flag is set to GFP_HIGHUSER_MOVABLE by
> > inode_init_always().
> > So, __GFP_HIGHMEM hits the gfp warning at bio_alloc() that
> > do_mpage_readpage() calls.
>
> Yeah.  Let's try this to match the iomap code:
>
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 9ed1e58e8d70b..d465883edf719 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -148,13 +148,11 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
>         int op = REQ_OP_READ;
>         unsigned nblocks;
>         unsigned relative_block;
> -       gfp_t gfp;
> +       gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
>
>         if (args->is_readahead) {
>                 op |= REQ_RAHEAD;
> -               gfp = readahead_gfp_mask(page->mapping);
> -       } else {
> -               gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
> +               gfp |= __GFP_NORETRY | __GFP_NOWARN;
>         }
>
>         if (page_has_buffers(page))

I did not test for iomap, but this patch has fixed the same regression on the
latest mainline at least for ext2, exfat, vfat and nilfs2.  Thanks!

Ryusuke Konishi
