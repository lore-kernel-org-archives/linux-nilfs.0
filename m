From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 21:58:23 +0900 (JST)
Message-ID: <20100824.215823.121933465.ryusuke@osrg.net>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20100824074844.GH3948@amd>
	<20100824083027.GA27594@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100824083027.GA27594-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Aug 2010 04:30:28 -0400, Christoph Hellwig wrote:
> On Tue, Aug 24, 2010 at 05:48:44PM +1000, Nick Piggin wrote:
> > The reason I broke nilfs2 is because it duplicates a lot of the
> > generic inode initialisation code. This really should go in core
> > code because nilfs2 does not own the generic inode fields.
> > 
> > It just needs some helper function to do the non-sb related init
> > stuff for you.
> 
> No, the problem is much deeper than that.  Having inodes outlive
> superblock is fundamentally broken.  All that crap simply needs
> to go away.

I agree..  I will try to resolve this problem, or will separate three
metadata files outlive superblock if I cannot find a proper way.

Actually, I recently wrote a patchset to unify all super block
instances on one device into one sb, which makes the inodes outlive
superblock eliminable.

But the patchset has a problem that it cannot shrink a number of
versions of namespace when unmounting all snapshots and a current time
instance.

If this implementation issue is avoidable, unifying per-snapshot sb
instances seems an ideal way.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
