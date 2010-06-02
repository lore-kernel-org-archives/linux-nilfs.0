From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: sync super blokcs in turns
Date: Thu, 03 Jun 2010 03:26:34 +0900 (JST)
Message-ID: <20100603.032634.52340789.ryusuke@osrg.net>
References: <87r5kx6bz9.wl%jir@sekiba.com>
	<20100528.015959.179492440.ryusuke@osrg.net>
	<87zkzkpxn3.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zkzkpxn3.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Fri, 28 May 2010 11:29:04 +0900, Jiro SEKIBA wrote:
> At Fri, 28 May 2010 01:59:59 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > Hi,
> > On Thu, 27 May 2010 16:27:22 +0900, Jiro SEKIBA wrote:
> > > Hi,
> > > 
> > > This is a proposed patch to sync super blocks by turn.
> > > It still require recovery action when super root is not found,
> > 
> > Arh, right.  We need some extension to retry the search with the older
> > super block.  It looks a bit complicate.
> > 
> > Ok, I'll take a moment to solve this issue.
> > 
> > > but it works at least to mount with valid fs with the patch:
> > > 
> > >  nilfs2: use checkpoint number instead of timestamp to select super block
> > >  9f6c75b4c354939f0a8aefc19eb6a9334ef58a89
> > > 
> > > This will sync super blocks by turn instead of syncing duplicate
> > > super blocks at the time.  This will help searching valid super root when
> > > super block is written into disk before log is written, which is happen when
> > > barrier-less block devices are unmounted uncleanly.
> > > In the stiation, old super block likely points valid log.
> > > 
> > > Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> > 
> > Well, the basic idea looks OK.
> > 
> > But, this patch has an issue.
> > 
> > When the filesystem is mounted, nilfs updates super blocks to drop
> > their VALID_FS flags, and this state continues until the partition
> > will be unmounted.
> > 
> > The point is that the checkpoint number does not change when the
> > VALID_FS flags are set or unset.
> > 
> > If the system goes down while the VALID_FS flag on the secondary super
> > block is still on, it may prevent roll-forward recovery because the
> > VALID_FS flag forces to skip the recovery.
> > 
> > So, we still have to drop the VALID_FS flag together from both super
> > blocks.
> 
> I see the issue.  Actually, VALID_FS flag is never unset for the
> older super block on mount time.  Because ns_sbp[0]->s_state is never
> propagated to the ns_sbp[1]->s_sate.
> 
> There are two way to unset VALID_FS flag on mount time, I came up with:
> 
> 1. use dupsb flag only in load_nilfs
> 2. swap super block and commit those separately in load_nilfs
> 
> 1st case, dupsb flag is examined each time in nilfs_sync_super.
> 2nd case is a little hacky, for it requires to check checkpoint number
> if checkpoint number is the number to swap super blocks to make sure
> not to swap twice (in load_nilfs and nilfs_sync_super).

Sorry for my late reply.

We can classify these update functions for super blocks into two:

 1. A function to update pointer to the latest log.
    s_last_seq, s_last_pseg, s_last_cno, s_free_blocks_count members
    belong to this category.

 2. A function to update information other than (1).
    The VALID_FS flag and other layout information are included in this
    class.

The class (1) update can be written to the disk alternately.  This
always changes the checkpoint number.

OTOH, the class (2) update should be written to both super blocks.

It would be nice if nilfs_commit_super() is exntended to handle both
classes of updates with a few optional flags.  At present, the above
fields for the class (1) update is set in nilfs_commit_super(), but
this should be moved out to the callers..  We may as well add a new
wrapper function for the periodic writeback of the super blocks.

> > Or, we may as well stop using the VALID_FS flag.  Nilfs can know
> > whether the recovery is needed or not by scanning logs without the
> > VALID_FS flag.
> 
> Actually, what I've done so far for grub module does not check that flag,
> but just try to find the latest log from where super block pointed.
> It, as far as I understand, is harmless to try roll forward action
> on the clean unmount fs.
> 
> I think it may take more time when it's valid but, searching log
> instantly fails.  Therefore that differences might be slight.
> 
> It would be good to have a "valid" flag for peace of mind, though.

Agreed.  Please keep the "valid" flag for now.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
