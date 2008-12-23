From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Some nilfs comments
Date: Wed, 24 Dec 2008 00:57:22 +0900 (JST)
Message-ID: <20081224.005722.41484092.ryusuke@osrg.net>
References: <1229568775.27170.134.camel@think.oraclecorp.com>
	<20081222.180719.88488712.ryusuke@osrg.net>
	<1229996820.4812.7.camel@think.oraclecorp.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1229996820.4812.7.camel-cGoWVVl3WGUrkklhUoBCrlaTQe2KTcn/@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

On Mon, 22 Dec 2008 20:47:00 -0500, Chris Mason wrote:
> > - struct the_nilfs:
> >   NILFS allows users to mount snapshots without making additional
> >   devices or volumes.  This is achieved by sharing a block device
> >   among multiple mount instances (i.e. super_block structs).
> >   the_nilfs struct is used for this sharing.
> > 
> >   This approach seems to be peculiar to nilfs, and I feel it needs
> >   attention.
> 
> Btrfs also shares super blocks between snapshot mounts, and each
> snapshot becomes a private inode number space.
> 
> So, it sounds like we have some things in common there.  I'm looking at
> using more explicit mounts than I am now (with some hints from
> Christoph). I'll take a look at the nilfs code in this area and see how
> similar we really are.

Yeah, it sounds nice.
So, I may not have to care this so much.
Comprehending common points between the two may be indeed meaningful
when we rethink mount/umount vfs interface.

> > 
> > - ioctl:
> >   Ioctl interface (routines and structures) were implemented in an
> >   own way.  These seems to be checked whether to comply with the rules
> >   of ioctl design.
> 
> Ok, I'll take a look here as well.  The same goes for btrfs ;)

All right ;)

> > > It looks like nilfs_writepage ignores WB_SYNC_NONE, which is used by
> > > do_sync_mapping_range().
> > 
> > Thanks!  I didn't notice that this function was added.
> > Uum, it seems to require reconsidering the way to initiate writing of
> > data pages.
> 
> Nick Piggin has been making noise to change do_sync_mapping_range to
> pass WB_SYNC_ALL instead.  You can trick it a bit while things get
> worked out and use current_is_pdflush() to only treat WB_SYNC_NONE as
> WB_SYNC_NONE when pdflush is the one calling (sorry, its an ugly
> suggestion).

Thanks. I've found the Nick's patch in mmotm.

In either case, nilfs_writepages (or nilfs_writepage) needs some more
changes to ensure data integrity writeout against
sys_sync_file_range() because writeback flag on data pages is not set
in nilfs_writepages() and wait_on_page_writeback_range() will ignore
the pages.

For other write operations, the write sync is ensured in a file level
operation like the journal data mode of ext3/ext4.
But I think nilfs_writepages() should be revised to initiate writeback
in the function if possible.

Regards,
Ryusuke
