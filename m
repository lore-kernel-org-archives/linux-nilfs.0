From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
Date: Mon, 21 Nov 2022 18:06:17 +0900
Message-ID: <CAKFNMo=ccYHUq5J10QR7-_JD9T634FV23QgMzeJ1m6NWRC4b9Q@mail.gmail.com>
References: <20221119093424.193145-1-chenzhongjin@huawei.com>
 <CAKFNMokEHD4FfPRcuRB4GrVquiT_RkWkNGKgb+ZPLPSGwfbDHQ@mail.gmail.com>
 <db11fe6a-356b-a522-f275-9b8ce8ab3b4a@huawei.com> <CAKFNMo=SsnbZxrAU-ho_37J4ZBqG+VY0kDJxDa3widrb2Gkj1g@mail.gmail.com>
 <35670b32-1337-04be-0269-f7f0f845833c@huawei.com> <CAKFNMokLfPLGZQetnXzf2Q4MWVtYOcdujdyYPBMsJgWoW2AMKA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/g7tdUKpMLQr11oIOFeI44OcDD56VSJn5Rj01iy3iwY=;
        b=kaxrmS+jV349NXio1VBR/t2aJ33uIid0NxZP6rvhA60YD50a6uGWxBuhKE7XunwhgF
         5rGXDzQlwSbyb+HOuyPDF6K0/U6BcpBpXbJrSwy+jqognXWlf4yDS+TLiMSMbX7d5h+U
         N6QyfeNkyTG9g92YX15QSX7hSKO9WvapaTu753yQN6cbCNGAr9Pycu6kfIlKANPEjyNt
         IOToqpAdeaB5wftQRMcY9m9pAwbOWt+lLVbpcYkbvzyPOXlQ0Bl3b5JlNwLBpZ2OQYnj
         XvasldYzHx3rQGkIztnAMOObeYoncFLeNFTcPtLvB2+FxuMGO5D0Ab94RPTDC944sZxR
         2G0w==
In-Reply-To: <CAKFNMokLfPLGZQetnXzf2Q4MWVtYOcdujdyYPBMsJgWoW2AMKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon, Nov 21, 2022 at 5:48 PM Ryusuke Konishi wrote:
>
> Hi,
>
> On Mon, Nov 21, 2022 at 4:45 PM Chen Zhongjin wrote:
> > On 2022/11/21 14:48, Ryusuke Konishi wrote:
> > > On Mon, Nov 21, 2022 at 11:16 AM Chen Zhongjin wrote:
> > >> Hi,
> > >>
> > >> On 2022/11/19 22:09, Ryusuke Konishi wrote:
> > >>> On Sat, Nov 19, 2022 at 6:37 PM Chen Zhongjin wrote:
> > >>>> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> > >>>> nilfs_segment_usage is not set dirty, which makes it can be found by
> > >>>> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
> > >>> The body of the patch looks OK, but this part of the commit log is a
> > >>> bit misleading.
> > >>> Could you please modify the expression so that we can understand this
> > >>> patch fixes the issue when the disk image is corrupted and the leak
> > >>> wasn't always there ?
> > >> Makes sense. I'm going to fix the message as this:
> > > Thank you for responding to my comment.
> > >
> > >> When extending segment, the current segment is allocated and set dirty
> > >> by previous nilfs_sufile_alloc().
> > >> But for some special cases such as corrupted image it can be unreliable,
> > >> so nilfs_sufile_mark_dirty()
> > >> is called to promise that current segment is dirty.
> > > This sentence is a little different because nilfs_sufile_mark_dirty()
> > > is originally called to dirty the buffer to include it as a part of
> > > the log of nilfs ahead, where the completed usage data will be stored
> > > later.
> > >
> > > And, unlike the dirty state of buffers and inodes, the dirty state of
> > > segments is persistent and resides on disk until it's freed by
> > > nilfs_sufile_free() unless it's destroyed on disk.
> > >
> > >> However, nilfs_sufile_mark_dirty() only sets buffer and inode dirty
> > >> while nilfs_segment_usage can
> > >> still be clean an used by following nilfs_sufile_alloc() because it
> > >> checks nilfs_segment_usage_clean(su).
> > >>
> > >> This will cause the problem reported...
> > > So, how about a description like this:
> > >
> > > When extending segments, nilfs_sufile_alloc() is called to get an
> > > unassigned segment.
> > > nilfs_sufile_alloc() then marks it as dirty to avoid accidentally
> > > allocating the same segment in the future.
> > > But for some special cases such as a corrupted image it can be unreliable.
> > >
> > > If such corruption of the dirty state of the segment occurs, nilfs2
> > > may reallocate a segment that is in use and pick the same segment for
> > > writing twice at the same time.
> > > ...
> > > This will cause the reported problem.
> > > ...
> > > Fix the problem by setting usage as dirty every time in
> > > nilfs_sufile_mark_dirty() which is called for the current segment
> > > before allocating additional segments during constructing segments to
> > > be written out.
> >
> > Thanks for your explanation!
> >
> > I made some simplification, so everything looks like:
> >
> >
> > When extending segments, nilfs_sufile_alloc() is called to get an
> > unassigned segment, then mark it as dirty to avoid accidentally
> > allocating the same segment in the future.
> >
> > But for some special cases such as a corrupted image it can be
> > unreliable.
> > If such corruption of the dirty state of the segment occurs, nilfs2 may
> > reallocate a segment that is in use and pick the same segment for
> > writing twice at the same time.
> >
> > This will cause the problem reported by syzkaller:
> > https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
> >
> > This case started with segbuf1.segnum = 3, nextnum = 4 when constructed.
> > It supposed segment 4 has already been allocated and marked as dirty.
> >
> > However the dirty state was corrupted and segment 4 usage was not dirty.
> > For the first time nilfs_segctor_extend_segments() segment 4 was
> > allocated again, which made segbuf2 and next segbuf3 had same segment 4.
> >
> > sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> > added to both buffer lists of two segbuf. It makes the lists broken
> > which causes NULL pointer dereference.
> >
> > Fix the problem by setting usage as dirty every time in
> > nilfs_sufile_mark_dirty(), which is called during constructing current
> > segment to be written out and before allocating next segment.
> >
>
> > Also add lock in it to protect the usage modification.
>
> You don't have to say this because this lock is needed to complete
> your modification and not the original.
> If you want to mention it, how about saying like this:
>
> Along with this change, this also adds a lock in it to protect the
> usage modification.

Come to think of it, this was also a misleading expression because the
patch doesn't add a new lock, but adds a use of an existing lock.
Either way, I'll leave it up to you.

Thanks,
Ryusuke Konishi

>
> > If it looks good, I'll sent the v3 patch for it.
> >
> > Best,
> > Chen
>
> I think the rest is OK as an overall description.
>
> Thanks,
> Ryusuke Konishi
