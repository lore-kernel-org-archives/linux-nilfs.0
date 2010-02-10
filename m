From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel BUG in btree.c:514 when mounting
Date: Thu, 11 Feb 2010 03:36:00 +0900 (JST)
Message-ID: <20100211.033600.160118962.ryusuke@osrg.net>
References: <loom.20100210T143343-933@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20100210T143343-933-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: SebastianR-Mmb7MZpHnFY@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 10 Feb 2010 14:06:18 +0000 (UTC), Sebastian Reichelt wrote:
> Hello!
> 
> After using nilfs2 for about 3 months (the version in Linux 2.6.31,
> not sure about the exact nilfs2 version number), I can no longer
> mount my root partition, as I immediately get a kernel BUG in
> btree.c:514. The process causing it is nilfs_cleanerd, though I
> suspect that might just be the first process to be executed.

The BUG tells that nilfs met a corrupted block during lookup of a
btree. 

Can you confirm which version of 2.6.31 kernel you were using?

I recommend you to use stable versions (I mean 2.6.31.12 or 2.6.32.8)
or well-maintained distro kernels because some serious bugs are not
yet fixed in the early 2.6.31 release.

> (Unfortunately, it is executed even if I use the "ro" option on the
> Linux command line -- why?!) It happens during a sys_open call. If
> the entire stack trace helps, I could post that, too.

Sounds weird.. 

> In any case, it would be nice if, upon encountering a file system
> corruption of some sort, the nilfs implementation didn't BUG, but
> had an "errors=remount-ro" option like other file systems.

That's a good point.  The BUG_ON call was replaced in 2.6.33-rc1 to
handle it as a filesystem error.

Although the "errors=remount-ro" option is not default in nilfs, I
think it should be changed at some time.

> Would it be possible to send the partition image to someone? The
> partition size is about 10 GB.

Unfortunately, the disk image is rarely-helpful from my experiences
since it's hard to track the cause from a corrupted state.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
