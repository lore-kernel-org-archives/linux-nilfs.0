From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/12] xfs: drop s_umount over opening the log and RT
 devices
Date: Sat, 5 Aug 2023 10:32:39 +0200
Message-ID: <20230805083239.GA29780@lst.de>
References: <20230802154131.2221419-1-hch@lst.de> <20230802154131.2221419-12-hch@lst.de> <20230802163219.GW11352@frogsfrogsfrogs>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230802163219.GW11352@frogsfrogsfrogs>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 02, 2023 at 09:32:19AM -0700, Darrick J. Wong wrote:
> > +	/* see get_tree_bdev why this is needed and safe */
> 
> Which part of get_tree_bdev?  Is it this?
> 
> 		/*
> 		 * s_umount nests inside open_mutex during
> 		 * __invalidate_device().  blkdev_put() acquires
> 		 * open_mutex and can't be called under s_umount.  Drop
> 		 * s_umount temporarily.  This is safe as we're
> 		 * holding an active reference.
> 		 */
> 		up_write(&s->s_umount);
> 		blkdev_put(bdev, fc->fs_type);
> 		down_write(&s->s_umount);

Yes.  With the refactoring earlier in the series get_tree_bdev should
be trivial enough to not need a more specific reference.  If you
think there's a better way to refer to it I can update the comment,
though.

> >  		mp->m_logdev_targp = mp->m_ddev_targp;
> >  	}
> >  
> > -	return 0;
> > +	error = 0;
> > +out_unlock:
> > +	down_write(&sb->s_umount);
> 
> Isn't down_write taking s_umount?  I think the label should be
> out_relock or something less misleading.

Agreed.  Christian, can you just change this in your branch, or should
I send an incremental patch?

