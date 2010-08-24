From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 17:42:16 +0100
Message-ID: <20100824164216.GV31363@ZenIV.linux.org.uk>
References: <20100824083027.GA27594@infradead.org>
 <20100824.215823.121933465.ryusuke@osrg.net>
 <20100824153214.GA25897@infradead.org>
 <20100825.012012.179486471.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100825.012012.179486471.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 25, 2010 at 01:20:12AM +0900, Ryusuke Konishi wrote:
> On Tue, 24 Aug 2010 11:32:14 -0400, Christoph Hellwig wrote:
> > On Tue, Aug 24, 2010 at 09:58:23PM +0900, Ryusuke Konishi wrote:
> > > Actually, I recently wrote a patchset to unify all super block
> > > instances on one device into one sb, which makes the inodes outlive
> > > superblock eliminable.
> > 
> > Yes, that's how we handle things everywhere, including btrfs with
> > it's subvolumes and snapshots.
> > 
> > > But the patchset has a problem that it cannot shrink a number of
> > > versions of namespace when unmounting all snapshots and a current time
> > > instance.
> > 
> > Can you explain the issue in more detail?
> 
> Ok, I'll try.
> 
> The current nilfs attaches each snapshot on a mountpoint, instead of
> making a sub directory like ".snap/xxx/" in a namespace.
> 
> In the patchset, I binded
> 
>  a) The root directory of the current filesystem onto sb->s_root and
>     mnt->mnt_root.
> 
>  b) The root directory of each snapshot onto its mnt->mnt_root.
> 
> Then,
> 
> When I unmounted all snapshots and current filesystem,
> nilfs_put_super() was called, but
> 
> generic_shutdown_super() only shrunk the dentry tree of sb->s_root and
> didn't shrink dentry trees of snapshots.
> 
> Thus their inodes and dentries were left in memory despite my
> intention.
> 
> So, my implementation issue here is how to free dentries and inodes of
> snapshots like shrink_dcache_for_umount(sb) does for a single
> namespace.

Use d_obtain_alias() to allocate roots of unattached subtrees.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
