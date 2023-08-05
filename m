From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 11/12] xfs: drop s_umount over opening the log and RT
 devices
Date: Sat, 5 Aug 2023 19:13:13 +0200
Message-ID: <20230805-langzeitfolgen-notation-dfd8a0175060@brauner>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-12-hch@lst.de>
 <20230802163219.GW11352@frogsfrogsfrogs>
 <20230805083239.GA29780@lst.de>
 <20230805161904.GM11377@frogsfrogsfrogs>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691255600;
        bh=ZfbjUjtwjQ3RdoKZ4m9be+A3vKSXVdCSc1xlaCOCYaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GPg8Jk0hmq/xHabhON9f9Wy4e6exu8iJEYNopK5zDw8GmrFoQGT2DAXxd87LbWap8
         4/d+lARj/a+CAYc0aXP8vt0XyFD50NbrypchRRdrvRVesi8hQ5+cEJMlEIBNxUxc+d
         ju3eCdqdVSpgSL9LURl8ByQA2GFWm47ugH4yf4iithQ0PhmracdrwHb7oSvfUhq7Ai
         nCDi4+LRW1PkLg70nBcnYsgykVajnsxEbLJ7zF6Rc6eY3wzAXbqT8zx3H+lqrTWMP6
         IHpiobC/SI7B85Kpm8M7ejKRDRklWb6ijfPX4OnHfxRBF3MQG4f0ma58crs+q7UJ0a
         TmEspZ09z2ylw==
Content-Disposition: inline
In-Reply-To: <20230805161904.GM11377@frogsfrogsfrogs>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Sat, Aug 05, 2023 at 09:19:04AM -0700, Darrick J. Wong wrote:
> On Sat, Aug 05, 2023 at 10:32:39AM +0200, Christoph Hellwig wrote:
> > On Wed, Aug 02, 2023 at 09:32:19AM -0700, Darrick J. Wong wrote:
> > > > +	/* see get_tree_bdev why this is needed and safe */
> > > 
> > > Which part of get_tree_bdev?  Is it this?
> > > 
> > > 		/*
> > > 		 * s_umount nests inside open_mutex during
> > > 		 * __invalidate_device().  blkdev_put() acquires
> > > 		 * open_mutex and can't be called under s_umount.  Drop
> > > 		 * s_umount temporarily.  This is safe as we're
> > > 		 * holding an active reference.
> > > 		 */
> > > 		up_write(&s->s_umount);
> > > 		blkdev_put(bdev, fc->fs_type);
> > > 		down_write(&s->s_umount);
> > 
> > Yes.  With the refactoring earlier in the series get_tree_bdev should
> > be trivial enough to not need a more specific reference.  If you
> > think there's a better way to refer to it I can update the comment,
> > though.
> 
> How about:
> 
> 	/*
> 	 * blkdev_put can't be called under s_umount, see the comment in
> 	 * get_tree_bdev for more details
> 	 */
> 
> with that and the label name change,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Added that comment and you rvb in-tree.
