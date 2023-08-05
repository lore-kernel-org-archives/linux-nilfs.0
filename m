From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 11/12] xfs: drop s_umount over opening the log and RT
 devices
Date: Sat, 5 Aug 2023 12:39:12 +0200
Message-ID: <20230805-galaabend-diskreditieren-27943ea3c10e@brauner>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-12-hch@lst.de>
 <20230802163219.GW11352@frogsfrogsfrogs>
 <20230805083239.GA29780@lst.de>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691231964;
        bh=uXGWtXBnq0nfa/jBhSY841c7zuCmhgyQEv0tqvbShRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gcYazOn/niIWgO8RAq86Wd0rf6mY5HFyG8HgKYgI+uBhiJcOa1iN7eHEwWVbAcqFb
         5XIJBVbVVoMXgQkQiYsI582grCtIP5eESCBkMFP2HJtSXo84sAac2RzSv75h991bTw
         DlhvR7swkECQCUNJ0aVzgU1Y6/CLhGJcMtH+agnVqKKciIHJRKsst4uRWzNWqfcH/S
         4Z5gPIEd6TmqOwMkNTU2g/kveG9q6Rla8oYlgbxLN/F6Ht72xR0/n8EjkY0FHeNts+
         T/IgH7Tx7FR6m1gG2NYvDi0EBc0UAhmoFZi7m3tQ+5R3RXve3Uu+iNx/GDcEcrNUGm
         nFhvs+f54VGWQ==
Content-Disposition: inline
In-Reply-To: <20230805083239.GA29780@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Sat, Aug 05, 2023 at 10:32:39AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 02, 2023 at 09:32:19AM -0700, Darrick J. Wong wrote:
> > > +	/* see get_tree_bdev why this is needed and safe */
> > 
> > Which part of get_tree_bdev?  Is it this?
> > 
> > 		/*
> > 		 * s_umount nests inside open_mutex during
> > 		 * __invalidate_device().  blkdev_put() acquires
> > 		 * open_mutex and can't be called under s_umount.  Drop
> > 		 * s_umount temporarily.  This is safe as we're
> > 		 * holding an active reference.
> > 		 */
> > 		up_write(&s->s_umount);
> > 		blkdev_put(bdev, fc->fs_type);
> > 		down_write(&s->s_umount);
> 
> Yes.  With the refactoring earlier in the series get_tree_bdev should
> be trivial enough to not need a more specific reference.  If you
> think there's a better way to refer to it I can update the comment,
> though.
> 
> > >  		mp->m_logdev_targp = mp->m_ddev_targp;
> > >  	}
> > >  
> > > -	return 0;
> > > +	error = 0;
> > > +out_unlock:
> > > +	down_write(&sb->s_umount);
> > 
> > Isn't down_write taking s_umount?  I think the label should be
> > out_relock or something less misleading.
> 
> Agreed.  Christian, can you just change this in your branch, or should
> I send an incremental patch?

No need to send an incremental patch. I just s/out_unlock/out_relock/g
in-tree. Thanks!
