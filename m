From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH v3] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
Date: Mon, 21 Nov 2022 18:48:49 +0900
Message-ID: <CAKFNMonEeNWnz0OKdSRR-bzg-qPg0eL+OvWrUDfy1vP4QySquw@mail.gmail.com>
References: <20221121091141.214703-1-chenzhongjin@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8piPUM5WN2xpiSAnlWb0/AyQG+BjbMUQ6ZWp4ZebqD0=;
        b=m8SQiOiG+7UPt6foKqJrx/JsgsNxCVBOmrQ+Klry/h0UcylvakbCfoX5RzeX+1AP9B
         cmiClRsydt13WffIT6NmxsC4D9w7L7U89zR7B17EkEmsK2NbeTtJ3tEpF+hXJ52TC7AQ
         YvZS/BFPpjXB+w2S//MKp1J9/S9ycQQp8qii8zeoGDsnqRCSgizLnjGkn+I3COUiwba6
         /5mLg6lm3Pvz3NZyo07wqx9reqLazWpKOBzBiWBqZjLv49lhgz+6Fpyv8fuStxrefc6F
         ZyKMIChb3+HhAO1SAyk/bWllL+qcSGM6S1sECj/+y1eoioIUrDjBjXj+Q5QIZCBERSEu
         whiw==
In-Reply-To: <20221121091141.214703-1-chenzhongjin@huawei.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Zhongjin <chenzhongjin@huawei.com>, akpm@linux-foundation.org
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

On Mon, Nov 21, 2022 at 6:14 PM Chen Zhongjin wrote:
>
> When extending segments, nilfs_sufile_alloc() is called to get an
> unassigned segment, then mark it as dirty to avoid accidentally
> allocating the same segment in the future.
>
> But for some special cases such as a corrupted image it can be
> unreliable.
> If such corruption of the dirty state of the segment occurs, nilfs2 may
> reallocate a segment that is in use and pick the same segment for
> writing twice at the same time.
>
> This will cause the problem reported by syzkaller:
> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
>
> This case started with segbuf1.segnum = 3, nextnum = 4 when constructed.
> It supposed segment 4 has already been allocated and marked as dirty.
>
> However the dirty state was corrupted and segment 4 usage was not dirty.
> For the first time nilfs_segctor_extend_segments() segment 4 was
> allocated again, which made segbuf2 and next segbuf3 had same segment 4.
>
> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> added to both buffer lists of two segbuf. It makes the lists broken
> which causes NULL pointer dereference.
>
> Fix the problem by setting usage as dirty every time in
> nilfs_sufile_mark_dirty(), which is called during constructing current
> segment to be written out and before allocating next segment.
>
> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+77e4f005cb899d4268d1@syzkaller.appspotmail.com
> Reported-by: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> v1 -> v2:
> 1) Add lock protection as Ryusuke suggested and slightly fix commit
> message.
> 2) Fix and add tags.
>
> v2 -> v3:
> Fix commit message to make it clear.

Looks good to me.

Andrew, could you please apply this patch instead of the currently queued patch?

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/sufile.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 77ff8e95421f..dc359b56fdfa 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
>  int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
>  {
>         struct buffer_head *bh;
> +       void *kaddr;
> +       struct nilfs_segment_usage *su;
>         int ret;
>
> +       down_write(&NILFS_MDT(sufile)->mi_sem);
>         ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
>         if (!ret) {
>                 mark_buffer_dirty(bh);
>                 nilfs_mdt_mark_dirty(sufile);
> +               kaddr = kmap_atomic(bh->b_page);
> +               su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
> +               nilfs_segment_usage_set_dirty(su);
> +               kunmap_atomic(kaddr);
>                 brelse(bh);
>         }
> +       up_write(&NILFS_MDT(sufile)->mi_sem);
>         return ret;
>  }
>
> --
> 2.17.1
>
