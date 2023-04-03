From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: RFC: Filesystem metadata in HIGHMEM
Date: Mon, 3 Apr 2023 16:22:40 +0200
Message-ID: <20230403142240.ftkywr3vn3r73yva@quack3>
References: <ZBCJ11qT8AWGA9y8@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680531761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R46s3dzmAWjax7iXZKikFYCLr1xSbo6uFhX0zzjg4pU=;
        b=XViU3+ETjmX+Zv1i3Q4VVTn7Ny+KHI+pcGRnoPPT3r61aXIzJBxPYzNkNl9++TJ9aBjV6M
        pj5xzmCEcljzJ3VrWr7zg8WDaJErfGUilAp+755lKhp6uAWpsjuSCcyiyy9snmSveJO8Pa
        dYp4hCNxKq+rm1Sy8iI/zHvhEXqBk/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680531761;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R46s3dzmAWjax7iXZKikFYCLr1xSbo6uFhX0zzjg4pU=;
        b=U1FjLpLfehFJEz9putWhis2w9XqHu0U3h3oaiL98jCSHliu31HtoSv01Qgpvds/nc1S0hp
        frS9z8ZPoJjwAoCw==
Content-Disposition: inline
In-Reply-To: <ZBCJ11qT8AWGA9y8-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, devel-urhm25FSIHzptaDgeN77Px2eb7JE58TQ@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Evgeniy Dushistov <dushistov-JGs/UdohzUI@public.gmane.org>

On Tue 14-03-23 14:51:03, Matthew Wilcox wrote:
> TLDR: I think we should rip out support for fs metadata in highmem
> 
> We want to support filesystems on devices with LBA size > PAGE_SIZE.
> That's subtly different and slightly harder than fsblk size > PAGE_SIZE.
> We can use large folios to read the blocks into, but reading/writing
> the data in those folios is harder if it's in highmem.  The kmap family
> of functions can only map a single page at a time (and changing that
> is hard).  We could vmap, but that's slow and can't be used from atomic
> context.  Working a single page at a time can be tricky (eg consider an
> ext2 directory entry that spans a page boundary).
> 
> Many filesystems do not support having their metadata in highmem.
> ext4 doesn't.  xfs doesn't.  f2fs doesn't.  afs, ceph, ext2, hfs,
> minix, nfs, nilfs2, ntfs, ntfs3, ocfs2, orangefs, qnx6, reiserfs, sysv
> and ufs do.
> 
> Originally, ext2 directories in the page cache were done by Al Viro
> in 2001.  At that time, the important use-case was machines with tens of
> gigabytes of highmem and ~800MB of lowmem.  Since then, the x86 systems
> have gone to 64-bit and the only real uses for highmem are cheap systems
> with ~8GB of memory total and 2-4GB of lowmem.  These systems really
> don't need to keep directories in highmem; using highmem for file &
> anon memory is enough to keep the system in balance.
> 
> So let's just rip out the ability to keep directories (and other fs
> metadata) in highmem.  Many filesystems already don't support this,
> and it makes supporting LBA size > PAGE_SIZE hard.
> 
> I'll turn this into an LSFMM topic if we don't reach resolution on the
> mailing list, but I'm optimistic that everybody will just agree with
> me ;-)

FWIW I won't object for the local filesystems I know about ;). But you
mention some networking filesystems above like NFS, AFS, orangefs - how are
they related to the LBA size problem you mention and what exactly you want
to get rid of there? FWIW I can imagine some 32-bit system (possibly
diskless) that uses NFS and that would benefit in caching stuff in
highmem...

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
