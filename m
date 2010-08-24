From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 21:19:31 +0900 (JST)
Message-ID: <20100824.211931.233007881.ryusuke@osrg.net>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20100824074844.GH3948@amd>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100824074844.GH3948@amd>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Aug 2010 17:48:44 +1000, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> On Sun, Aug 22, 2010 at 07:05:00PM +0900, Ryusuke Konishi wrote:
> > This is a patchset to remove own inode hash table from nilfs.
> > 
> > The current version of nilfs uses inode not only to manage regular
> > files, directories, symlinks but also for some types of metadata and
> > for caching file blocks relocated by GC.
> > 
> > The last type of inodes is called gc-inodes, and nilfs keeps them with
> > an own hash table.
> > 
> > With this patchset, the gc-inodes will be stored in vfs inode cache
> > like regular inodes, and the own inode hash is deleted.
> > 
> > I hope this would be helpful for the vfs scalability work.
> 
> This looks like a reasonable direction to me, and you would get
> more of the benefits of the inode cache scalability work, but this
> wasn't the biggest prolem for my series, because I'm not going digging
> into the filesystems themselves.
> 
> The reason I broke nilfs2 is because it duplicates a lot of the
> generic inode initialisation code. This really should go in core
> code because nilfs2 does not own the generic inode fields.

Yes, that is what I want to do next.
I really want to eliminate the duplication.

> It just needs some helper function to do the non-sb related init
> stuff for you.

I'm seeking the way to make that special type of inodes hold a valid
sb.  If it's not feasible, I think nilfs should not borrow inode
object and should define just enough structure instead.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
