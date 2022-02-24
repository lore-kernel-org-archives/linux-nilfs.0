From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] mm/fs: Remove redundant code
Date: Fri, 25 Feb 2022 02:53:47 +0900
Message-ID: <CAKFNMo=jrEwV_U4wkfKvWeMoTJ9Ojbb0xx2cMrhr1KXD2gnxeg@mail.gmail.com>
References: <20220207103738.103661-1-jiapeng.chong@linux.alibaba.com> <CAKFNMokx2Qk4jJx6s0vzseYRbfjejZwoDY3MnPODWhT7-_1K=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eq0rhSJW/1Sw11xhooN6LOA8GL16OGqICWs9SpqOzME=;
        b=ovlMUCBoPHm0Ng7jBHgOGMvsivibBY0eFjYSXrf3lveZO9y7J2WPN15pjxopiEooRf
         jPMf3/Zbrl33kMLio4YHaGFu/g0gHEoxnq6wMuDCigvid5G32wBFY4FwqI6X3TqCQKq5
         s7OhTDCOZJ4i0qXn57rbq8Ygjw6NGONXkOhHCYlCpilq99mqAILegufcLLdORRqVk9TO
         ul4bgzurtbgclnajz6YRvaRZDtc6tgxRenOvk76+cIAjaOihY0FZq8LTCujURAMByF06
         xwZrGcr5kT+BK+kj0pQyLbeubQwxi7aY00qKJ9mawM7Pnf1MmavxrN5t9ESMA4xU+lOL
         Bp1g==
In-Reply-To: <CAKFNMokx2Qk4jJx6s0vzseYRbfjejZwoDY3MnPODWhT7-_1K=g@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Abaci Robot <abaci@linux.alibaba.com>

Hi,

On Fri, Feb 25, 2022 at 2:30 AM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> Hi Jiapeng,
>
> On Mon, Feb 7, 2022 at 7:37 PM Jiapeng Chong
> <jiapeng.chong@linux.alibaba.com> wrote:
> >
> > Clean up the following smatch warning:
> >
> > fs/nilfs2/segbuf.c:358 nilfs_segbuf_submit_bio() warn: ignoring
> > unreachable code.
> >
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > ---
> >  fs/nilfs2/segbuf.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> > index 9e5dd6324ea1..50d7e2e4daed 100644
> > --- a/fs/nilfs2/segbuf.c
> > +++ b/fs/nilfs2/segbuf.c
> > @@ -341,7 +341,6 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
> >                                    int mode_flags)
> >  {
> >         struct bio *bio = wi->bio;
> > -       int err;
> >
> >         bio->bi_end_io = nilfs_end_bio_write;
> >         bio->bi_private = segbuf;
> > @@ -354,9 +353,6 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
> >         wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
> >         wi->start = wi->end;
> >         return 0;
> > -
> > -       wi->bio = NULL;
> > -       return err;
> >  }
>
> Sorry for my late reply.
>
> I will send this to Andrew to report and fix the regression on the -mm
> patch series.
>
> I'd like to change the patch title to something like "nilfs2: Remove
> redundant code"
> since the "mm/fs" prefix does not properly represent what it applies to.
> (this patch may be folded into the patch that is causing the warning)
>
> Regards,
> Ryusuke Konishi

Sorry again.

The reported issue was already corrected in NeilBrown's revised patch set, so I
will suspend this.

Thanks,
Ryusuke Konishi
