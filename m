From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] Remove bdi_congested() and wb_congested() and
 related functions
Date: Mon, 13 Dec 2021 16:07:36 +1100
Message-ID: <20211213050736.GS449541@dread.disaster.area>
References: <163936868317.23860.5037433897004720387.stgit@noble.brown>
 <163936886727.23860.5245364396572576756.stgit@noble.brown>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <163936886727.23860.5245364396572576756.stgit@noble.brown>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Jan Kara <jack@suse.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 13, 2021 at 03:14:27PM +1100, NeilBrown wrote:
> These functions are no longer useful as the only bdis that report
> congestion are in ceph, fuse, and nfs.  None of those bdis can be the
> target of the calls in drbd, ext2, nilfs2, or xfs.
> 
> Removing the test on bdi_write_contested() in current_may_throttle()
> could cause a small change in behaviour, but only when PF_LOCAL_THROTTLE
> is set.
> 
> So replace the calls by 'false' and simplify the code - and remove the
> functions.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
....
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 631c5a61d89b..22f73b3e888e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -843,9 +843,6 @@ xfs_buf_readahead_map(
>  {
>  	struct xfs_buf		*bp;
>  
> -	if (bdi_read_congested(target->bt_bdev->bd_disk->bdi))
> -		return;

Ok, but this isn't a "throttle writeback" test here - it's trying to
avoid having speculative readahead blocking on a full request queue
instead of just skipping the readahead IO. i.e. prevent readahead
thrashing and/or adding unnecessary read load when we already have a
full read queue...

So what is the replacement for that? We want to skip the entire
buffer lookup/setup/read overhead if we're likely to block on IO
submission - is there anything we can use to do this these days?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
