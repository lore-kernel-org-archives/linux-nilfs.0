From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: delete unnecessary checks before brelse()
Date: Sat, 20 Aug 2022 08:50:59 +0900
Message-ID: <CAKFNMo=LedaGL9R194rirwccCBuGyawqZfKbWiNj9JuP9A3hdg@mail.gmail.com>
References: <20220819081700.96279-1-chi.minghao@zte.com.cn> <0d78d24dd26441818dbaedffde611485@AcuMS.aculab.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/uLcjZVVgo/FEofAm05ee8H0GETlBKkDk8r6DlEbea4=;
        b=p0EvQnukj7b3xGTof7ILq3GiAPKvohBEtP4JxgTxxx10+KcXYMu1KlTC/uaRKVuQCT
         Cc873H13LzkCqz0ZHbrjVqW5U8LUpQOPFElehjLaG0eDkNHnz/1YL3s/M8mwg1nanYv2
         Es14QnARsmfkAE7B9hz8389lRlfzHWy9C6/dYYoUj+O9cgwvm29Mw2GSxUgKyuFGerWR
         qwVxBCpiwsJPimFCEY19gCsJbIOZ0jaAcLlZcxWpaXn5LkL56hSju8W2B8jhBOl1yQ/x
         peEdTGYg1x5pglTK1dfZlbYEANSYnx9Oda50MYfAZqvFuxFq2ICKNXwvhMc8wSrz0ZO5
         KlCw==
In-Reply-To: <0d78d24dd26441818dbaedffde611485-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: "cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Hi David,

On Sat, Aug 20, 2022 at 6:31 AM David Laight wrote:
>
> From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> > Sent: 19 August 2022 09:17
> >
> > The brelse() function tests whether its argument is NULL
> > and then returns immediately.
> > Thus remove the tests which are not needed around the shown calls.
>

> The test is the caller makes sense if it is a 'hot' path
> and bh is normally NULL.
>
>         David

Should the commit message say "inline function" instead of "function"?

or do you have other intentions?

These tests indeed seem meaningless, since brelse() is an inline
function that tests whether bh is NULL or not, like this

 static inline void brelse(struct buffer_head *bh)
 {
        if (bh)
                __brelse(bh);
 }

and the corresponding parts are equivalent to:

  if (bh != NULL)
          if (bh)
                  __brelse(bh);


Regards,
Ryusuke Konishi

>
> >
> > Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> > Signed-off-by: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> > ---
> >  fs/nilfs2/btree.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> > index f544c22fff78..b3b5a46488c2 100644
> > --- a/fs/nilfs2/btree.c
> > +++ b/fs/nilfs2/btree.c
> > @@ -1668,8 +1668,7 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
> >       maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
> >       nextmaxkey = (nchildren > 1) ?
> >               nilfs_btree_node_get_key(node, nchildren - 2) : 0;
> > -     if (bh != NULL)
> > -             brelse(bh);
> > +     brelse(bh);
> >
> >       return (maxkey == key) && (nextmaxkey < NILFS_BMAP_LARGE_LOW);
> >  }
> > @@ -1717,8 +1716,7 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
> >               ptrs[i] = le64_to_cpu(dptrs[i]);
> >       }
> >
> > -     if (bh != NULL)
> > -             brelse(bh);
> > +     brelse(bh);
> >
> >       return nitems;
> >  }
> > --
> > 2.25.1
