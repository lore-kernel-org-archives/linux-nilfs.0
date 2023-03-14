From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: RFC: Filesystem metadata in HIGHMEM
Date: Tue, 14 Mar 2023 14:51:03 +0000
Message-ID: <ZBCJ11qT8AWGA9y8@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=H1QGXFGueBuHBkdVnY1gVNgWxdg/uqRKaISs/k4X5k8=; b=S7EeSUpGaZlBdHu4WUHAIdr25V
        ixFY7YsdAbe5O4aABq5JSzhjm6AQQEt3eXVPOFTCWjSNtDCgQFZErMmKupnpF9Y/4skbRxraN6HkX
        TqmDE1TcO5R6zBSPSKRc5doATbZgmLE4SGmmnROLttR98UmmdtbKjQjHzeTUwv1E1p/bjEoFFy+iH
        nyqmOOJUi5ry9SunSrF7pQBYspmk5uLVQJF6SmWk5LWJAeaLgy3Zr7wr5xxwd+hQMMwpvWD+yVxuy
        /CaVhXopsc+90LrYwApR0yOX/0l4LaCriYpzBh1LHFmzupT2UryDjtJai0v3ndjSU6zPsYceoZ+bh
        bp/MSRHg==;
Content-Disposition: inline
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, devel-urhm25FSIHzptaDgeN77Px2eb7JE58TQ@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Evgeniy Dushistov <dushistov-JGs/UdohzUI@public.gmane.org>

TLDR: I think we should rip out support for fs metadata in highmem

We want to support filesystems on devices with LBA size > PAGE_SIZE.
That's subtly different and slightly harder than fsblk size > PAGE_SIZE.
We can use large folios to read the blocks into, but reading/writing
the data in those folios is harder if it's in highmem.  The kmap family
of functions can only map a single page at a time (and changing that
is hard).  We could vmap, but that's slow and can't be used from atomic
context.  Working a single page at a time can be tricky (eg consider an
ext2 directory entry that spans a page boundary).

Many filesystems do not support having their metadata in highmem.
ext4 doesn't.  xfs doesn't.  f2fs doesn't.  afs, ceph, ext2, hfs,
minix, nfs, nilfs2, ntfs, ntfs3, ocfs2, orangefs, qnx6, reiserfs, sysv
and ufs do.

Originally, ext2 directories in the page cache were done by Al Viro
in 2001.  At that time, the important use-case was machines with tens of
gigabytes of highmem and ~800MB of lowmem.  Since then, the x86 systems
have gone to 64-bit and the only real uses for highmem are cheap systems
with ~8GB of memory total and 2-4GB of lowmem.  These systems really
don't need to keep directories in highmem; using highmem for file &
anon memory is enough to keep the system in balance.

So let's just rip out the ability to keep directories (and other fs
metadata) in highmem.  Many filesystems already don't support this,
and it makes supporting LBA size > PAGE_SIZE hard.

I'll turn this into an LSFMM topic if we don't reach resolution on the
mailing list, but I'm optimistic that everybody will just agree with
me ;-)
