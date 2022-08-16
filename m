From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug in nilfs_mdt_destroy()
Date: Tue, 16 Aug 2022 18:18:18 +0900
Message-ID: <CAKFNMonVb6s3Cey5riXFwd+C3wy87fHbMUtnq3SXooXgsSD5yA@mail.gmail.com>
References: <20220815175114.23576-1-konishi.ryusuke@gmail.com>
 <YvqP/f2P2YgIIO9U@ZenIV> <CAKFNMomyjXpsz-=BtG+G3q1J7CFUBMEfP13FfxwhWB==9qb++w@mail.gmail.com>
 <YvrQ8xO9Lx7rdKq8@ZenIV> <CAKFNMoniwM5x0w03cezGTFDWt=apNmGWpur83+vjghg3zcawpQ@mail.gmail.com>
 <CAD-N9QW5-kVR85t1canTqrF9RMkOjC1Z2q8BSQKxLwaay97Mgg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Kk2g2IEl/Ua+BBCBiaozArRy7OGG11VduF5q3BhTDG0=;
        b=KcBiWrctfetchJMsY/eFWVoCsx3SblR9qr6NI6BPQ60NgilShdjZlJUj4AiV5t0Yz1
         QLi+cwFAww1Sh0xZjHgdFm2wXeNc1qu+yYPcoCpbHeauU5+BHlq8vB3ETrA+3wNlMNAq
         YfbF3VYWZjWcHbXYEqnmKbHbidsO/eQQGJjM3gLluTqbtBegGjkkFls9VZZOLZYpzsB/
         kt2bO+DyeinL1VidVfznhy9aVsAasdL03No67OrGbIRpxJ9O733KT4e2UUBk18Sg6RIE
         BvRr9ja784eIHZZDWo5KueuM0LZCwwgjFh7PRZkYjhHV500L74V1q7n0lwlIANYOoPvV
         fvBQ==
In-Reply-To: <CAD-N9QW5-kVR85t1canTqrF9RMkOjC1Z2q8BSQKxLwaay97Mgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>

On Tue, Aug 16, 2022 at 12:25 PM Dongliang Mu wrote:
> > Dongliang (or Jiacheng?), would it be possible for you to post a revised patch
> > against inode_init_always() that moves the call of security_inode_alloc()
> > instead of i_private initialization (as Al Viro said in a nearby thread [1]) ?
> > If you have time, I would like to leave it to you since you wrote the
> > original patch for inode_init_always().
>
> Sure, I will post a v2 patch that moves security_inode_alloc to the
> location just prior to
>         this_cpu_inc(nr_inodes);
> with proper commit message.
>

I saw you already sent the v2 patch on linux-fsdevel, etc.
Just thank you for your quick follow.

Regards,
Ryusuke Konishi

> >
> > [1] https://lkml.kernel.org/r/CAO4S-mficMz1mQW06EuCF+o11+mRDiCpufqVfoHkcRbQbs8kVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> >
> > Thanks,
> > Ryusuke Konishi
