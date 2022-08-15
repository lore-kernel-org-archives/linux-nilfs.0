From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug in nilfs_mdt_destroy()
Date: Tue, 16 Aug 2022 00:04:19 +0100
Message-ID: <YvrQ8xO9Lx7rdKq8@ZenIV>
References: <20220815175114.23576-1-konishi.ryusuke@gmail.com>
 <YvqP/f2P2YgIIO9U@ZenIV>
 <CAKFNMomyjXpsz-=BtG+G3q1J7CFUBMEfP13FfxwhWB==9qb++w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jYgL/K8hz07GJiAK21af3KOIMQ0hiyPepA8O+pLBNvg=; b=Cr2ibY2f3ipwPYhnorMIGpCzis
        OkyypRYHxZMcLaS1TmKCt0FoLJZKlhHWBHy9ZtXS1cJEHIlhJmT4M6ai9v/Njvp3DngRrGIxCW3+P
        FpXaHY0gwqKGjnWCBiFml40myGDSCistV8dpo5ukSQJzLn3N1RrSGokCvmER6dw/gYyCIdsr4y9aR
        TMAuLkutQZPVxj1nUb2iDbIuJ5sx5cXn4OGmDkYh/iTJx96KndAaDqEdRZtIbBnzrcboPDCWlWC/u
        w4RX9AHXnnBBtdhl2Z5pR07qJLWR82WDfVosJflru3V2IEu1E6m7k2HulPNLFfiG4f8QROUfQPmKp
        6R5egiiQ==;
Content-Disposition: inline
In-Reply-To: <CAKFNMomyjXpsz-=BtG+G3q1J7CFUBMEfP13FfxwhWB==9qb++w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Aug 16, 2022 at 05:34:12AM +0900, Ryusuke Konishi wrote:

> Yes, I agree it's better if security_inode_alloc() is moved to the end as
> possible in the sense of avoiding similar issues.
> But, would that vfs change be safe to backport to stable trees?

Yes.

> It looks like the error handling for security_inode_alloc()  is in the
> middle of inode_init_always() for a very long time..

Look at the initializations done after it.  The only thing with effects
outside of inode itself is (since 2010) an increment of nr_inodes.

> If you want to see the impact of the vfs change, I think it's one way
> to apply this one in advance.  Or if you want to fix it in one step,
> I think it's good too.  How do you feel about this ?

IMO that should go into inode_init_always(), with Cc:stable.  If you
(or Dongliang Mu, or anybody else) would post such variant with
reasonable commit message, I'll pick it into vfs.git and feed to Linus
in the next window.  E.g. into #work.inode, with that branch being
made never-rebased, so that you could pull it into your development
branch as soon as it's there...
