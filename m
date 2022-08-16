From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug in nilfs_mdt_destroy()
Date: Tue, 16 Aug 2022 12:11:35 +0900
Message-ID: <CAKFNMoniwM5x0w03cezGTFDWt=apNmGWpur83+vjghg3zcawpQ@mail.gmail.com>
References: <20220815175114.23576-1-konishi.ryusuke@gmail.com>
 <YvqP/f2P2YgIIO9U@ZenIV> <CAKFNMomyjXpsz-=BtG+G3q1J7CFUBMEfP13FfxwhWB==9qb++w@mail.gmail.com>
 <YvrQ8xO9Lx7rdKq8@ZenIV>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Zh9L3GMyN0bAgm1VZ5joh7GoecxvY4X4P34K9smg9ao=;
        b=DCJaZHlRDaLYCQnt5L/NE3PWbEAGjyuvd10TuFktBd16TZV17FdCS9hgDC0ppYunaP
         q9E5NpecMnY4E4AFkxNe/0Fg5Rpb0+9bBEr/d/CBE7bGj2b9z9Pn1ehRMS2UkLwThYTg
         p0lh1UNazF8H2Kjpui8hPnrP6QPIPbwE03vMS4l8Rwi9ShypZKI5ROv6WBckPQQrSZhR
         maWp0FjTDz61asqVWcvIDUXlWmZOLTQwSbeJVZNDaSR3V3nC/6imXUiNaemBXyYUV+Xo
         TpKZnIQgdPV+bx3JAuU5MZ3brQ40b6mDdnyBbCSpGVb8oMAbtD8Uta1aQ6cBRtlM5Okf
         /YbA==
In-Reply-To: <YvrQ8xO9Lx7rdKq8@ZenIV>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>

On Tue, Aug 16, 2022 at 8:04 AM Al Viro wrote:
>
> On Tue, Aug 16, 2022 at 05:34:12AM +0900, Ryusuke Konishi wrote:
>
> > Yes, I agree it's better if security_inode_alloc() is moved to the end as
> > possible in the sense of avoiding similar issues.
> > But, would that vfs change be safe to backport to stable trees?
>
> Yes.
>
> > It looks like the error handling for security_inode_alloc()  is in the
> > middle of inode_init_always() for a very long time..
>
> Look at the initializations done after it.  The only thing with effects
> outside of inode itself is (since 2010) an increment of nr_inodes.
>
> > If you want to see the impact of the vfs change, I think it's one way
> > to apply this one in advance.  Or if you want to fix it in one step,
> > I think it's good too.  How do you feel about this ?
>
> IMO that should go into inode_init_always(), with Cc:stable.  If you
> (or Dongliang Mu, or anybody else) would post such variant with
> reasonable commit message, I'll pick it into vfs.git and feed to Linus
> in the next window.  E.g. into #work.inode, with that branch being
> made never-rebased, so that you could pull it into your development
> branch as soon as it's there...

I agree with your thoughts on the course of action.
Andrew, I withdraw this patch.

Dongliang (or Jiacheng?), would it be possible for you to post a revised patch
against inode_init_always() that moves the call of security_inode_alloc()
instead of i_private initialization (as Al Viro said in a nearby thread [1]) ?
If you have time, I would like to leave it to you since you wrote the
original patch for inode_init_always().

[1] https://lkml.kernel.org/r/CAO4S-mficMz1mQW06EuCF+o11+mRDiCpufqVfoHkcRbQbs8kVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org

Thanks,
Ryusuke Konishi
