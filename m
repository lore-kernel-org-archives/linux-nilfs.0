From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/9] Remove remaining parts of congestions tracking
 code.
Date: Thu, 27 Jan 2022 14:42:29 -0800
Message-ID: <20220127144229.a7109a508521db5e8ddda09c@linux-foundation.org>
References: <164325106958.29787.4865219843242892726.stgit@noble.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323352;
        bh=ybh+vNa1e2zVCBIHmgIav4rSBCIa4tEXBrjj/Zvd9DM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lD8DNYdSP5VgdUVvLTzLs87NT6X2RUv/tVO0wVWZV57Mo8tiF+Cy9CVqnSr4Mr28N
         /4z/vln9zP3ZnibjoeX42f/bT+EANd4Y6/PvlZ8IiaLj4IayJe8a69r3sno42DD5jQ
         fiofeE7oSvVhmRsxcbaFoTER4oAWLDgl8zvqXutM=
In-Reply-To: <164325106958.29787.4865219843242892726.stgit@noble.brown>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: NeilBrown <neilb@suse.de>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, l

On Thu, 27 Jan 2022 13:46:29 +1100 NeilBrown <neilb@suse.de> wrote:

> Congestion hasn't been reliably tracked for quite some time.
> Most MM uses of it for guiding writeback decisions were removed in 5.16.
> Some other uses were removed in 17-rc1.
> 
> This series removes the remaining places that test for congestion, and
> the few places which still set it.
> 
> The second patch touches a few filesystems.  I didn't think there was
> much value in splitting this out by filesystems, but if maintainers
> would rather I did that, I will.
> 
> The f2fs, cephfs, fuse, NFS, and block patches can go through the
> respective trees proving the final patch doesn't land until after they
> all do - so maybe it should be held for 5.18-rc2 if all the rest lands
> by 5.18-rc1.

Plan B: I'll just take everything.  While collecting tested-bys and
acked-bys from filesystem maintainers (please).

