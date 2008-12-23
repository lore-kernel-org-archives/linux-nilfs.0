From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Some nilfs comments
Date: Mon, 22 Dec 2008 20:47:00 -0500
Message-ID: <1229996820.4812.7.camel@think.oraclecorp.com>
References: <1229568775.27170.134.camel@think.oraclecorp.com>
	<20081222.180719.88488712.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081222.180719.88488712.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Mon, 2008-12-22 at 18:07 +0900, Ryusuke Konishi wrote:
> Hi Chris,
> 
> On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> > Hello,
> > 
> > I've been meaning to read through nilfs for a while, and I grabbed the
> > code today to take a look.  The code is very clean and it ran well out
> > of the box here.
> 
> Thank you very much for helpful comments!
> 

;) I'll be slow to answer since I'm traveling a bit.

> > One problem I hit early on was that nilfs doesn't seem to zero out the
> > block device during mkfs.  So after mkfs.nilfs2, mount still found my
> > old btrfs filesystem.  It would be a good idea to zero out the first and
> > last 1MB on the device (except for the first sector which might have the
> > partition table).
> 
> Okay, I'll take this idea in mkfs.nilfs2.
> 
> > I haven't dug too deeply in yet, but if there are parts you're most
> > interested in comments on, please let me know.
> 
> Well, I feel that the following two matters are particularlly
> questionable and need to be checked:
> 
> - struct the_nilfs:
>   NILFS allows users to mount snapshots without making additional
>   devices or volumes.  This is achieved by sharing a block device
>   among multiple mount instances (i.e. super_block structs).
>   the_nilfs struct is used for this sharing.
> 
>   This approach seems to be peculiar to nilfs, and I feel it needs
>   attention.

Btrfs also shares super blocks between snapshot mounts, and each
snapshot becomes a private inode number space.

So, it sounds like we have some things in common there.  I'm looking at
using more explicit mounts than I am now (with some hints from
Christoph). I'll take a look at the nilfs code in this area and see how
similar we really are.

> 
> - ioctl:
>   Ioctl interface (routines and structures) were implemented in an
>   own way.  These seems to be checked whether to comply with the rules
>   of ioctl design.

Ok, I'll take a look here as well.  The same goes for btrfs ;)
> 
> 
> > It looks like nilfs_writepage ignores WB_SYNC_NONE, which is used by
> > do_sync_mapping_range().
> 
> Thanks!  I didn't notice that this function was added.
> Uum, it seems to require reconsidering the way to initiate writing of
> data pages.

Nick Piggin has been making noise to change do_sync_mapping_range to
pass WB_SYNC_ALL instead.  You can trick it a bit while things get
worked out and use current_is_pdflush() to only treat WB_SYNC_NONE as
WB_SYNC_NONE when pdflush is the one calling (sorry, its an ugly
suggestion).

-chris
