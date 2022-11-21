From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
Date: Mon, 21 Nov 2022 15:48:05 +0900
Message-ID: <CAKFNMo=SsnbZxrAU-ho_37J4ZBqG+VY0kDJxDa3widrb2Gkj1g@mail.gmail.com>
References: <20221119093424.193145-1-chenzhongjin@huawei.com>
 <CAKFNMokEHD4FfPRcuRB4GrVquiT_RkWkNGKgb+ZPLPSGwfbDHQ@mail.gmail.com> <db11fe6a-356b-a522-f275-9b8ce8ab3b4a@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OKwZYjUpgcMpjUPaMufxFd6lTmMS5OdhYd7iJvzeHqo=;
        b=ou4XNZbV8BAIFC9D5DIJAnNRKqiiQAfMwc79hpIFIQ1lAqnuTq6I7AypZJsNKK3m+Q
         E9IjrHdcnOYzMSs46EIgjid2K/qu/UMdz03T83kLtzOpFB6hZGy66Ta/zz7bASNSQxby
         I6fsyWjt6+HLB3t8Trsm8kH82MCe27JH8/vE3IfQw+XexbA/INk3ADulFY5G/u+viZvx
         CYPhzcRyLSI5lyb2KzvrANz+q9ZQIdVJ/QfZFj+TCC2BtmNmV4U/PjFusZ/ePdfwmywc
         RXfSAlYZQFQXYRce+U2/wwb21ZiozicmNuns2G+SRsPeolkXThOr4cGe8CwZTSI5xV4y
         HkDQ==
In-Reply-To: <db11fe6a-356b-a522-f275-9b8ce8ab3b4a-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon, Nov 21, 2022 at 11:16 AM Chen Zhongjin wrote:
>
> Hi,
>
> On 2022/11/19 22:09, Ryusuke Konishi wrote:
> > On Sat, Nov 19, 2022 at 6:37 PM Chen Zhongjin wrote:
> >> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> >> nilfs_segment_usage is not set dirty, which makes it can be found by
> >> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
> > The body of the patch looks OK, but this part of the commit log is a
> > bit misleading.
> > Could you please modify the expression so that we can understand this
> > patch fixes the issue when the disk image is corrupted and the leak
> > wasn't always there ?
>
> Makes sense. I'm going to fix the message as this:

Thank you for responding to my comment.

>
> When extending segment, the current segment is allocated and set dirty
> by previous nilfs_sufile_alloc().
> But for some special cases such as corrupted image it can be unreliable,
> so nilfs_sufile_mark_dirty()
> is called to promise that current segment is dirty.

This sentence is a little different because nilfs_sufile_mark_dirty()
is originally called to dirty the buffer to include it as a part of
the log of nilfs ahead, where the completed usage data will be stored
later.

And, unlike the dirty state of buffers and inodes, the dirty state of
segments is persistent and resides on disk until it's freed by
nilfs_sufile_free() unless it's destroyed on disk.

>
> However, nilfs_sufile_mark_dirty() only sets buffer and inode dirty
> while nilfs_segment_usage can
> still be clean an used by following nilfs_sufile_alloc() because it
> checks nilfs_segment_usage_clean(su).
>
> This will cause the problem reported...

So, how about a description like this:

When extending segments, nilfs_sufile_alloc() is called to get an
unassigned segment.
nilfs_sufile_alloc() then marks it as dirty to avoid accidentally
allocating the same segment in the future.
But for some special cases such as a corrupted image it can be unreliable.

If such corruption of the dirty state of the segment occurs, nilfs2
may reallocate a segment that is in use and pick the same segment for
writing twice at the same time.
...
This will cause the reported problem.
...
Fix the problem by setting usage as dirty every time in
nilfs_sufile_mark_dirty() which is called for the current segment
before allocating additional segments during constructing segments to
be written out.

Regards,
Ryusuke Konishi

>
> Could you please have a check? Thanks!
>
> Best,
> Chen
> > Originally, the assumption was that the current and next segments
> > pointed to by log headers had been made dirty, and in fact mkfs.nilfs2
> > and nilfs2 itself had created metadata that way, so it wasn't really a
> > problem.  Usually the segment usage that this patch tries to dirty is
> > already marked dirty and usually results in duplicate processing.
> > nilfs_sufile_mark_dirty() is really only supposed to dirty that buffer
> > and inode, and this patch changes the role.
> >
> > However, that assumption was incomplete in the sense that it does not
> > assume broken metadata (whether intentionally or as a result of
> > device/media failure), and lacked checks or protection from it.  In
> > the meantime, you showed the simple and safe workaround even though it
> > duplicates in almost all cases and even changes the semantics of the
> > function.
> > In terms of the stability and safety, your patch is good that we can
> > ignore the inefficiency, so I am pushing for this change.
> >
> > Thanks,
> > Ryusuke Konishi
> >
> >> This will cause the problem reported by syzkaller:
> >> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
> >>
> >> It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
> >> nilfs_sufile_alloc() not called to allocate a new segment.
> >>
> >> The first time nilfs_segctor_extend_segments() allocated segment
> >> segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
> >> nextnextnum = 4 segment because its su is not set dirty.
> >> So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.
> >>
> >> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> >> added to both buffer lists of two segbuf.
> >> It makes the list head of second list linked to the first one. When
> >> iterating the first one, it will access and deref the head of second,
> >> which causes NULL pointer dereference.
> >>
> >> Fix this by setting usage as dirty in nilfs_sufile_mark_dirty(),
> >> and add lock in it to protect the usage modification.
> >>
> >> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> >> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Reported-by: syzbot+77e4f005cb899d4268d1-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> >> Reported-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> v1 -> v2:
> >> 1) Add lock protection as Ryusuke suggested and slightly fix commit
> >> message.
> >> 2) Fix and add tags.
> >> ---
> >>   fs/nilfs2/sufile.c | 8 ++++++++
> >>   1 file changed, 8 insertions(+)
> >>
> >> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> >> index 77ff8e95421f..dc359b56fdfa 100644
> >> --- a/fs/nilfs2/sufile.c
> >> +++ b/fs/nilfs2/sufile.c
> >> @@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
> >>   int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
> >>   {
> >>          struct buffer_head *bh;
> >> +       void *kaddr;
> >> +       struct nilfs_segment_usage *su;
> >>          int ret;
> >>
> >> +       down_write(&NILFS_MDT(sufile)->mi_sem);
> >>          ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
> >>          if (!ret) {
> >>                  mark_buffer_dirty(bh);
> >>                  nilfs_mdt_mark_dirty(sufile);
> >> +               kaddr = kmap_atomic(bh->b_page);
> >> +               su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
> >> +               nilfs_segment_usage_set_dirty(su);
> >> +               kunmap_atomic(kaddr);
> >>                  brelse(bh);
> >>          }
> >> +       up_write(&NILFS_MDT(sufile)->mi_sem);
> >>          return ret;
> >>   }
> >>
> >> --
> >> 2.17.1
> >>
