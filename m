From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv3 2/2] nilfs2: sync super blocks in turns
Date: Wed, 23 Jun 2010 17:56:52 +0900 (JST)
Message-ID: <20100623.175652.212679034.ryusuke@osrg.net>
References: <20100621.025310.57455600.ryusuke@osrg.net>
	<20100623.123856.258021353.ryusuke@osrg.net>
	<87ocf2civ3.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ocf2civ3.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Wed, 23 Jun 2010 16:23:44 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> At Wed, 23 Jun 2010 12:38:56 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > On Mon, 21 Jun 2010 02:53:10 +0900 (JST), Ryusuke Konishi wrote:
> > > On Mon, 21 Jun 2010 01:36:55 +0900, Jiro SEKIBA wrote:
> > > > This will sync super blocks in turns instead of syncing duplicate
> > > > super blocks at the time.  This will help searching valid super root when
> > > > super block is written into disk before log is written, which is happen when
> > > > barrier-less block devices are unmounted uncleanly.
> > > > In the situation, old super block likely points to valid log.
> > > > 
> > > > This patch introduces ns_sbwcount member, which counts how many times super
> > > > blocks write back to the disk.  Super blocks are asymmetrically synced
> > > > based on the counter.
> > > > 
> > > > The patch also introduces new function nilfs_set_log_cursor to advance
> > > > log cursor for specified super block.  To update both of super block
> > > > information, caller of nilfs_commit_super must set the information on both
> > > > super blocks.
> > > > 
> > > > Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> > > 
> > > Thank you!  Both patches look good to me.
> > > 
> > > Will queue them up for the next merge window.
> > > 
> > > Thanks,
> > > Ryusuke Konishi
> > 
> > Umm, I noticed that nilfs_commit_super is called twice when the
> > filesystem is unmounted.  This is because nilfs_sync_fs() is called
> > just before nilfs_put_super() will do unmount jobs.
> 
> Ahhh, I see the problem.  That's right.  It would have be the same
> checkpoints in case that filesystem is dirty when sync_fs is called.
> To slove the problem, I think, it may require controlling swap of
> superblocks explicitly.
> 
> How about swaping BEFORE writing the super block instead of AFTER?
> 
> nilfs_prepare_super will take another argument that controls swapping
> of super blocks.  So caller can decide swap or not.  With this feature,
> you can prepare super block without swapping in a nilfs_put_super.
> Therefore, old super block written before sync_fs called will be preserved
> by overwriting the same super block sync_fs wrote back.

Sounds reasonable, and more clear to me.

Note that sync_fs itself can be called multiple times.  The current
nilfs_sync_fs implementation is half-baked; it does not handle the
syncwait flag argument properly.  nilfs_construct_segment() and
nilfs_commit_super() should be essentially divided into "commit" and
"wait" functions.

I also think nilfs_sync_fs does not have to call nilfs_commit_super
because the log will be recovered by roll-forwarding even if not
updating the log cursor.

Anyway, I agree to move the flip operation into nilfs_prepare_super()
and to make it selectable with a "flip" flag.  It would make things
more flexible.

> Updating protection period should be took care carefully.
> Nhh, then, it can compare the actual checkpoint nubmer of each super blocks
> instead of setting sbp[1]'s checkpoint each time.

Yes, it is replaceable with the comparison of checkpoint numbers.
So, you can move the flip operation into nilfs_prepare_super().

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
