From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Wed, 25 Aug 2010 00:39:33 +0900 (JST)
Message-ID: <20100825.003933.141333647.ryusuke@osrg.net>
References: <20100824074844.GH3948@amd>
	<20100824.211931.233007881.ryusuke@osrg.net>
	<20100824132453.GU31363@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100824132453.GU31363-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Aug 2010 14:24:53 +0100, Al Viro wrote:
> On Tue, Aug 24, 2010 at 09:19:31PM +0900, Ryusuke Konishi wrote:
> > > It just needs some helper function to do the non-sb related init
> > > stuff for you.
> > 
> > I'm seeking the way to make that special type of inodes hold a valid
> > sb.  If it's not feasible, I think nilfs should not borrow inode
> > object and should define just enough structure instead.
> 
> For fsck sake, just grab an active reference to superblock for the
> duration of GC and use _normal_ inodes...

GC is only allowed while a read/write mount exists, and the "remove
own inode hash table" patchset already solved the sb-less inode issue
for GC.

The remaining problem is that nilfs allocates different sb per
snapshot instead of increasing reference count of one super block.
(to be precise, identical snapshots or current mounts share the same
sb like regular mount)

Since snapshots or a current filesystem are mounted or unmounted
independently sharing the three metadata files, these metadata files
can live across the lifetime of a certain sb.

All other inodes are binded to an sb.


And, my thought is, in the first place, allocating different sb for a
device is not sane.

Thanks,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
