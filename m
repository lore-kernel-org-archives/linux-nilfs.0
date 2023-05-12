From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug of nilfs_root in
 nilfs_evict_inode()
Date: Fri, 12 May 2023 16:46:27 -0700
Message-ID: <20230512164627.0cd2a6f5d6a61bf736715c32@linux-foundation.org>
References: <00000000000099e5ac05fb1c3b85@google.com>
        <20230509152956.8313-1-konishi.ryusuke@gmail.com>
        <20230512164424.865d7929600ed070824764e6@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683935188;
        bh=5ZiYRU6RWKYZUiTi+ixrCoeaVHLHcmBFcrn2mNYPdjc=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=bFXkBwBzLTlPAyCh35B7yXPVZ5CnuzzDdJ1NRfmUkuL0GcRhteQYwcgchaXhSduOq
         AKfHxVDb2EU5nty2WE5n15DCOpJT9Ls9EvlFmLUJgb62FvvqCqG+LMw9p0/4AHOCLD
         8xuN/AhUJI6aOobid4J0af6+L/ug6LFP6y1CqTYI=
In-Reply-To: <20230512164424.865d7929600ed070824764e6-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+78d4495558999f55d1da-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 12 May 2023 16:44:24 -0700 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> On Wed, 10 May 2023 00:29:56 +0900 Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > During unmount process of nilfs2, nothing holds nilfs_root structure after
> > nilfs2 detaches its writer in nilfs_detach_log_writer().  However, since
> > nilfs_evict_inode() uses nilfs_root for some cleanup operations, it may
> > cause use-after-free read if inodes are left in "garbage_list" and
> > released by nilfs_dispose_list() at the end of nilfs_detach_log_writer().
> > 
> > Fix this issue by modifying nilfs_evict_inode() to only clear inode
> > without additional metadata changes that use nilfs_root if the file system
> > is degraded to read-only or the writer is detached.
> > 
> > ...
> >
> > --- a/fs/nilfs2/inode.c
> > +++ b/fs/nilfs2/inode.c
> > @@ -917,6 +917,7 @@ void nilfs_evict_inode(struct inode *inode)
> >  	struct nilfs_transaction_info ti;
> >  	struct super_block *sb = inode->i_sb;
> >  	struct nilfs_inode_info *ii = NILFS_I(inode);
> > +	struct the_nilfs *nilfs;
> >  	int ret;
> 
> `the_nilfs' is unused - I'll zap it.

argh, sorry, brainfart.
