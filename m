From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/9] Remove inode_congested()
Date: Fri, 28 Jan 2022 10:37:56 +0100
Message-ID: <CAJfpegt-igF8HqsDUcMzfU0jYv8WpofLy0Uv0YnXLzsfx=tkGg@mail.gmail.com>
References: <164325106958.29787.4865219843242892726.stgit@noble.brown> <164325158954.29787.7856652136298668100.stgit@noble.brown>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E/VIyc5JpK2Sy5loT9a2HcHWg2TrorJJxRaogeKP25w=;
        b=EibPllimp8WZIwxJdUGUIFAlIuZdyznPvrXJ7caP5EDkiBNUVM4ihiUoIfNxC6TVSx
         YE207qfvpl7N/VHWz1SefuMcAFD5mqGieRSegzXNyYGWfyIdkPkwWByrIvqWimbKQ8Un
         /lbUGxvPlDX06Jf/32nPUu5Q90vZSrQ0/ovfo=
In-Reply-To: <164325158954.29787.7856652136298668100.stgit@noble.brown>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, linux-mm <linux-mm@kvack.org>, linux-nilfs@vger.kernel.org, Linux NFS list <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Ext4 <linux-ext4@vger.kernel.org>, ceph-devel@vger.kernel.org, drbd-dev

On Thu, 27 Jan 2022 at 03:47, NeilBrown <neilb@suse.de> wrote:
>
> inode_congested() reports if the backing-device for the inode is
> congested.  Few bdi report congestion any more, only ceph, fuse, and
> nfs.  Having support just for those is unlikely to be useful.
>
> The places which test inode_congested() or it variants like
> inode_write_congested(), avoid initiating IO if congestion is present.
> We now have to rely on other places in the stack to back off, or abort
> requests - we already do for everything except these 3 filesystems.
>
> So remove inode_congested() and related functions, and remove the call
> sites, assuming that inode_congested() always returns 'false'.

Looks to me this is going to "break" fuse; e.g. readahead path will go
ahead and try to submit more requests, even if the queue is getting
congested.   In this case the readahead submission will eventually
block, which is counterproductive.

I think we should *first* make sure all call sites are substituted
with appropriate mechanisms in the affected filesystems and as a last
step remove the superfluous bdi congestion mechanism.

You are saying that all fs except these three already have such
mechanisms in place, right?  Can you elaborate on that?

Thanks,
Miklos
