From: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug in nilfs_mdt_destroy()
Date: Tue, 16 Aug 2022 11:24:10 +0800
Message-ID: <CAD-N9QW5-kVR85t1canTqrF9RMkOjC1Z2q8BSQKxLwaay97Mgg@mail.gmail.com>
References: <20220815175114.23576-1-konishi.ryusuke@gmail.com>
 <YvqP/f2P2YgIIO9U@ZenIV> <CAKFNMomyjXpsz-=BtG+G3q1J7CFUBMEfP13FfxwhWB==9qb++w@mail.gmail.com>
 <YvrQ8xO9Lx7rdKq8@ZenIV> <CAKFNMoniwM5x0w03cezGTFDWt=apNmGWpur83+vjghg3zcawpQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0+fOHte+oOjdt0ZcS9IxeZxJv4FE7v9fXbd9M9vTVIU=;
        b=KpnzdQRG3/WPprMvYVg5B3iZfpc5bUgwIiRuujqtM8qqYLp5nR8x01nJ5ZS1xvL4uy
         871+vwwCOc0PkvDt0siufAeAvqFMyj3JcLqAgmA53l/CKS9Sw87+XeRs4L/vdhGF9Qb8
         vQr4ksYMFRpJxhkifOawB1CCYt5Ez29v4PeyZxtvNg0lZ3xl2hVyclINQ/AJCgyoVP4k
         FW+03YnPcO8gPujo9nCTQ1LI5qEQE3B+Vqy2lUbFwhYO6XFmo0rckz82YVudlT0BQiF6
         2MeZ2KAdjj3yRRykrleJ7rIpNyIWorxYK8y73Jk4M/yBXD8vWI9M2Wd0M6Lx6tvYlOOJ
         M4HA==
In-Reply-To: <CAKFNMoniwM5x0w03cezGTFDWt=apNmGWpur83+vjghg3zcawpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>

On Tue, Aug 16, 2022 at 11:11 AM Ryusuke Konishi
<konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Tue, Aug 16, 2022 at 8:04 AM Al Viro wrote:
> >
> > On Tue, Aug 16, 2022 at 05:34:12AM +0900, Ryusuke Konishi wrote:
> >
> > > Yes, I agree it's better if security_inode_alloc() is moved to the end as
> > > possible in the sense of avoiding similar issues.
> > > But, would that vfs change be safe to backport to stable trees?
> >
> > Yes.
> >
> > > It looks like the error handling for security_inode_alloc()  is in the
> > > middle of inode_init_always() for a very long time..
> >
> > Look at the initializations done after it.  The only thing with effects
> > outside of inode itself is (since 2010) an increment of nr_inodes.
> >
> > > If you want to see the impact of the vfs change, I think it's one way
> > > to apply this one in advance.  Or if you want to fix it in one step,
> > > I think it's good too.  How do you feel about this ?
> >
> > IMO that should go into inode_init_always(), with Cc:stable.  If you
> > (or Dongliang Mu, or anybody else) would post such variant with
> > reasonable commit message, I'll pick it into vfs.git and feed to Linus
> > in the next window.  E.g. into #work.inode, with that branch being
> > made never-rebased, so that you could pull it into your development
> > branch as soon as it's there...
>
> I agree with your thoughts on the course of action.
> Andrew, I withdraw this patch.
>
> Dongliang (or Jiacheng?), would it be possible for you to post a revised patch
> against inode_init_always() that moves the call of security_inode_alloc()
> instead of i_private initialization (as Al Viro said in a nearby thread [1]) ?
> If you have time, I would like to leave it to you since you wrote the
> original patch for inode_init_always().

Sure, I will post a v2 patch that moves security_inode_alloc to the
location just prior to
        this_cpu_inc(nr_inodes);
with proper commit message.

>
> [1] https://lkml.kernel.org/r/CAO4S-mficMz1mQW06EuCF+o11+mRDiCpufqVfoHkcRbQbs8kVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
>
> Thanks,
> Ryusuke Konishi
