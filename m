From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
Date: Fri, 18 Nov 2022 14:11:38 -0800
Message-ID: <20221118141138.c091445bdda36b78f6277c1f@linux-foundation.org>
References: <20221118063304.140187-1-chenzhongjin@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668809499;
        bh=+7RUpCopDWImHx4kpniYvLBKqUGp3uhYcB86V79wOq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EZ7+sTS7ME+VOF+J/iDcMwXeLNFmhd8HaBTNKMqfdJkqrtUnhUme/VUqiwmbXvMN8
         ZcI4DwDYHr91Q86B4xAC92PwVRdbDaZZMceC0PHTDYx3N7dw7zB8NnvoU1djVryuie
         iM4Ktss2tX/23xa47RJ/jnhF1e/Tt4r/YCuRQPhU=
In-Reply-To: <20221118063304.140187-1-chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, 18 Nov 2022 14:33:04 +0800 Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:

> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> nilfs_segment_usage is not set dirty, which makes it can be found by
> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
> 
> This will cause the problem reported by syzkaller:
> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
> 
> It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
> nilfs_sufile_alloc() not called to allocate a new segment.
> 
> The first time nilfs_segctor_extend_segments() allocated segment
> segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
> nextnextnum = 4 segment because its su is not set dirty.
> So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.
> 
> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> added to both buffer lists of two segbuf.
> It makes the list head of second list linked to the first one. When
> iterating the first one, it will access and deref the head of second,
> which causes NULL pointer dereference.
> 
> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")

Merged in 2009!

> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -495,12 +495,18 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
>  int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
>  {
>  	struct buffer_head *bh;
> +	void *kaddr;
> +	struct nilfs_segment_usage *su;
>  	int ret;
>  
>  	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
>  	if (!ret) {
>  		mark_buffer_dirty(bh);
>  		nilfs_mdt_mark_dirty(sufile);
> +		kaddr = kmap_atomic(bh->b_page);
> +		su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
> +		nilfs_segment_usage_set_dirty(su);
> +		kunmap_atomic(kaddr);
>  		brelse(bh);
>  	}
>  	return ret;

Do we feel that this fix should be backported into -stable kernels?

