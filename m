From: Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] nilfs2: move initialization of nr_dirty to decl
Date: Thu, 17 Mar 2022 11:12:14 -0700
Message-ID: <YjN5/h+0fR6Ph/5H@dev-arch.thelio-3990X>
References: <20220317175043.1972081-1-trix@redhat.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647540741;
        bh=ptsC5nm9G0+/HpO2r1JMC/u3+Be4YpkP+sY3ZGfaKX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=taDGPQeN1d7NfJA3qzPxO6Y7dfOE1qEoYvpRJv/gS/c/qiwWVW5ZEsLeIfMcIoOW/
         laACJSlK3GfYaHQsI5R74RHg+FHV2pI2cH1yETuXuFFx8k4n/fiS+z58gzzO9+vMto
         Sywx002tz5Cep4ec75DZ7erbXcp6afH2glZc1f88xjNJr9xlLHXINvL7RI+UD3LyTT
         wPNqUavD77VDBF1kyMWvqaf3xaLhfIY+5Czf+ImbD/v+WELkdI1Kb3TfRzuznfModa
         gQk63+GRKrxiQjjPux56AB0ZhEIIpEZMBBSOHBlzvCZiJdIxVt+z60dKKamVcXF3sL
         t9TdlTKKNdy9Q==
Content-Disposition: inline
In-Reply-To: <20220317175043.1972081-1-trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org

Hi Tom,

On Thu, Mar 17, 2022 at 10:50:43AM -0700, trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> From: Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> On clang build there is this error
> inode.c:227:13: error: variable 'nr_dirty' is
>   used uninitialized whenever 'if' condition is false
>         } else if (ret) {
>                    ^~~
> 
> In nilfs_dirty_folio(), if the call to
> filemap_dirty_folio() fails and there
> are no buffers, nr_dirty will be uninitialized.
> Move the initialization out of the buffer
> block and to the decl.
> 
> Signed-off-by: Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This has been fixed in next-20220317:

https://git.kernel.org/next/linux-next/c/af7afdc7bbbe60cb6ce51a86b022d647e1a72717

Cheers,
Nathan

> ---
>  fs/nilfs2/inode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index c1219c0678a57..01e58b65c9384 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -204,7 +204,7 @@ static bool nilfs_dirty_folio(struct address_space *mapping,
>  {
>  	struct inode *inode = mapping->host;
>  	struct buffer_head *head;
> -	unsigned int nr_dirty;
> +	unsigned int nr_dirty = 0;
>  	bool ret = filemap_dirty_folio(mapping, folio);
>  
>  	/*
> @@ -214,8 +214,6 @@ static bool nilfs_dirty_folio(struct address_space *mapping,
>  	head = folio_buffers(folio);
>  	if (head) {
>  		struct buffer_head *bh = head;
> -
> -		nr_dirty = 0;
>  		do {
>  			/* Do not mark hole blocks dirty */
>  			if (buffer_dirty(bh) || !buffer_mapped(bh))
> -- 
> 2.26.3
> 
