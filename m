From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue of nilfs_set_page_dirty for page at
 EOF boundary
Date: Tue, 7 May 2013 13:38:35 -0700
Message-ID: <20130507133835.625d694a3eca7f5b6c83c0ba@linux-foundation.org>
References: <20130501.163930.56348973.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130501.163930.56348973.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>

On Wed, 01 May 2013 16:39:30 +0900 (JST) Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:

> DESCRIPTION:
> There are use-cases when NILFS2 file system (formatted with block size
> lesser than 4 KB) can be remounted in RO mode because of encountering
> of "broken bmap" issue.
> 
> ...
>
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -219,13 +219,25 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>  
>  static int nilfs_set_page_dirty(struct page *page)
>  {
> -	int ret = __set_page_dirty_buffers(page);
> +	int ret = __set_page_dirty_nobuffers(page);
>  
> -	if (ret) {
> +	if (page_has_buffers(page)) {
>  		struct inode *inode = page->mapping->host;
> -		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
> +		unsigned nr_dirty = 0;
> +		struct buffer_head *bh, *head;
>  
> -		nilfs_set_file_dirty(inode, nr_dirty);
> +		bh = head = page_buffers(page);
> +		do {
> +			/* Do not mark hole blocks dirty */
> +			if (!buffer_dirty(bh) || !buffer_mapped(bh))
> +				continue;
> +
> +			set_buffer_dirty(bh);

This doesn't seem right.  The only time we will run set_buffer_dirty()
is if the buffer was dirty and mapped.  What's the point in running
set_buffer_dirty() against an already dirty buffer?

I suspect you intended (buffer_dirty || !buffer_mapped)


> +			nr_dirty++;
> +		} while (bh = bh->b_this_page, bh != head);
> +
> +		if (nr_dirty)
> +			nilfs_set_file_dirty(inode, nr_dirty);

Rather secondarily: the above code appears to assume that no other
thread can come in and mark a buffer dirty while the loop is executing.
 This *should* be OK - the page is locked (or it should be).  Can you
confirm that this is the case?  There are no other places where a
buffer can be concurrently dirtied against an unlocked page?

>  	}
>  	return ret;
>  }

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
