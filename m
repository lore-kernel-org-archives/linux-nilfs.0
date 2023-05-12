From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug of nilfs_root in
 nilfs_evict_inode()
Date: Fri, 12 May 2023 16:44:24 -0700
Message-ID: <20230512164424.865d7929600ed070824764e6@linux-foundation.org>
References: <00000000000099e5ac05fb1c3b85@google.com>
        <20230509152956.8313-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683935065;
        bh=2czeN+szhGqQEbAPsO/hg6SMlJY1aN6WI4RZJU274vE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iPst+k+uujlSeJkrSXsSTphDq6H5xvOLn92+AZSylYg1tFmc8sD1lDcsWn3ITIZtb
         uoj8k7qzz9w1lQM6NprAT2J1b3nXLwA+icPHqALEYHt9/DhiKQalBxraub7cGa4V2R
         C+BigRBTJfy57+DusM5+UuO4Gk+PHojdnJUY8Rns=
In-Reply-To: <20230509152956.8313-1-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+78d4495558999f55d1da-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 10 May 2023 00:29:56 +0900 Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> During unmount process of nilfs2, nothing holds nilfs_root structure after
> nilfs2 detaches its writer in nilfs_detach_log_writer().  However, since
> nilfs_evict_inode() uses nilfs_root for some cleanup operations, it may
> cause use-after-free read if inodes are left in "garbage_list" and
> released by nilfs_dispose_list() at the end of nilfs_detach_log_writer().
> 
> Fix this issue by modifying nilfs_evict_inode() to only clear inode
> without additional metadata changes that use nilfs_root if the file system
> is degraded to read-only or the writer is detached.
> 
> ...
>
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -917,6 +917,7 @@ void nilfs_evict_inode(struct inode *inode)
>  	struct nilfs_transaction_info ti;
>  	struct super_block *sb = inode->i_sb;
>  	struct nilfs_inode_info *ii = NILFS_I(inode);
> +	struct the_nilfs *nilfs;
>  	int ret;

`the_nilfs' is unused - I'll zap it.


