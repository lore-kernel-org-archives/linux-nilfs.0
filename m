From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug in nilfs_mdt_destroy()
Date: Tue, 16 Aug 2022 05:34:12 +0900
Message-ID: <CAKFNMomyjXpsz-=BtG+G3q1J7CFUBMEfP13FfxwhWB==9qb++w@mail.gmail.com>
References: <20220815175114.23576-1-konishi.ryusuke@gmail.com> <YvqP/f2P2YgIIO9U@ZenIV>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=edBKqiVnU84WIOC5Qmj5Rk7CwLqtESwhF2nX0tSKFBo=;
        b=qDe9CTkaYOZ8QfGGEZWgKVaU6v0Be3OJaGRxWiA/Gip12e6+QSOm7BQy8NHS99Vl8J
         kXXaVp08xA725DVH0WEKUkl78emxsl++Z3MJcrsXhCwFqS2RXGm/EtgApd0XVgzPAMoS
         oRI1c9StJ748f73evLhknd1xfoYVYNwDof8RD9eIwRyQLGtbT+aBz7JkFmqzuIF9yMTf
         IXBNbxmV7HGZ/v4REGo8UHR2FSjhqZM69UdtlwAXn3Gs0HEuFUvPZDs40ldPpnGMKard
         fqb4EQtz2g8ELtQt/xXaTs74RDZaMeOiBS88ZkTW3crVT6mod5gWWU7dXKcuK8KV+NSC
         Hghw==
In-Reply-To: <YvqP/f2P2YgIIO9U@ZenIV>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Aug 16, 2022 at 3:27 AM Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>
> On Tue, Aug 16, 2022 at 02:51:14AM +0900, Ryusuke Konishi wrote:
> > In alloc_inode(), inode_init_always() could return -ENOMEM if
> > security_inode_alloc() fails.  If this happens for nilfs2,
> > nilfs_free_inode() is called without initializing inode->i_private and
> > nilfs_free_inode() wrongly calls nilfs_mdt_destroy(), which frees
> > uninitialized inode->i_private and can trigger a crash.
> >
> > Fix this bug by initializing inode->i_private in nilfs_alloc_inode().
> >
> > Link: https://lkml.kernel.org/r/CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> > Link: https://lkml.kernel.org/r/20211011030956.2459172-1-mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> > Reported-by: butt3rflyh4ck <butterflyhuangxx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Reported-by: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Reported-by: Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
> > Reported-by: Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> > ---
> >  fs/nilfs2/super.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index ba108f915391..aca5614f1b44 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -159,6 +159,7 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
> >       ii->i_cno = 0;
> >       ii->i_assoc_inode = NULL;
> >       ii->i_bmap = &ii->i_bmap_data;
> > +     ii->vfs_inode.i_private = NULL;
> >       return &ii->vfs_inode;
> >  }
>
> FWIW, I think it's better to deal with that in inode_init_always(), but
> not just moving ->i_private initialization up - we ought to move
> security_inode_alloc() to the very end.  No sense playing whack-a-mole
> with further possible bugs of that sort...

Yes, I agree it's better if security_inode_alloc() is moved to the end as
possible in the sense of avoiding similar issues.
But, would that vfs change be safe to backport to stable trees?

It looks like the error handling for security_inode_alloc()  is in the
middle of inode_init_always() for a very long time..

If you want to see the impact of the vfs change, I think it's one way
to apply this one in advance.  Or if you want to fix it in one step,
I think it's good too.  How do you feel about this ?

Thanks,
Ryusuke Konishi
