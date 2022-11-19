From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
Date: Sat, 19 Nov 2022 13:11:05 +0900
Message-ID: <CAKFNMonaKuOrCt0dKxN5t3gPKOq--z=Q+LZ8iczqN30kQEdhkQ@mail.gmail.com>
References: <20221118063304.140187-1-chenzhongjin@huawei.com> <20221118141138.c091445bdda36b78f6277c1f@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uFTErpkyzUkKz4ZMbc5fuZ/BIhGwsKOPVm98ZEN6Gw0=;
        b=dwc1huwFF6jYZdqDS9arWDVXnvg6wO3C13GYEqmpH9hPak4zNhpMGPlUPgcJx7J//u
         HEiPB5L1L5ixQEy6PW5eyc9NbNSBzlsmANoEDd+iARirivsjs4zBBUZciJzwqsdM8ARK
         knqo3wS7+kIPT+U5EYi0PDAld+vb9GyLqcQf75PY9tMk6F035cIj2kNjp8eVUFrHlBY9
         p0Of/4Y9+xd20KvYuMnQeAx/XMnKSspnk19Dgg8T25Kh1X9bfhbparyLGKiuXQiP0XPk
         gnT3fjVzYvqih9oKVVBpOAtNyBw9yxhuX5UbOr7NbtJFtAVNKzBeYIEfMaNIcGYu7Bfy
         3FWA==
In-Reply-To: <20221118141138.c091445bdda36b78f6277c1f-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,

On Sat, Nov 19, 2022 at 7:11 AM Andrew Morton wrote:
>
> On Fri, 18 Nov 2022 14:33:04 +0800 Chen Zhongjin wrote:
>
> > In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> > nilfs_segment_usage is not set dirty, which makes it can be found by
> > nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
> >
> > This will cause the problem reported by syzkaller:
> > https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
> >
> > It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
> > nilfs_sufile_alloc() not called to allocate a new segment.
> >
> > The first time nilfs_segctor_extend_segments() allocated segment
> > segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
> > nextnextnum = 4 segment because its su is not set dirty.
> > So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.
> >
> > sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> > added to both buffer lists of two segbuf.
> > It makes the list head of second list linked to the first one. When
> > iterating the first one, it will access and deref the head of second,
> > which causes NULL pointer dereference.

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This is a simple and side-effect-free nice patch for this problem,
even though the functionality of nilfs_sufile_mark_dirty() has changed
from what it is supposed to do.

Making the segment usage dirty was the responsibility of another
function, nilfs_sufile_alloc().
However, it turns out that the current implementation is insufficient
for corrupted disk images like those created by syzbot. This patch
complements that.

If you don't mind, please add the following tag as well:

Reported-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

He initially tried to fix this issue [1]:

[1] https://lkml.kernel.org/r/20221108022928.497746-1-liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

> >
> > Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
>
> Merged in 2009!

This is not wrong.  Sorry for the long term bug.
Because mkfs.nilfs2 and the nilfs2 module don't create broken metadata
that would require this patch, so we never encountered this bug until
syzbot reported it.

>
> > --- a/fs/nilfs2/sufile.c
> > +++ b/fs/nilfs2/sufile.c
> > @@ -495,12 +495,18 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
> >  int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
> >  {
> >       struct buffer_head *bh;
> > +     void *kaddr;
> > +     struct nilfs_segment_usage *su;
> >       int ret;
> >
> >       ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
> >       if (!ret) {
> >               mark_buffer_dirty(bh);
> >               nilfs_mdt_mark_dirty(sufile);
> > +             kaddr = kmap_atomic(bh->b_page);
> > +             su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
> > +             nilfs_segment_usage_set_dirty(su);
> > +             kunmap_atomic(kaddr);
> >               brelse(bh);
> >       }
> >       return ret;
>
> Do we feel that this fix should be backported into -stable kernels?

Yes, it should be. Please do so.

Thanks,
Ryusuke Konishi
