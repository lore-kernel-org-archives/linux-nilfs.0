From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel BUG in btree.c:514 when mounting
Date: Thu, 11 Feb 2010 17:11:45 +0900 (JST)
Message-ID: <20100211.171145.261971816.ryusuke@osrg.net>
References: <loom.20100210T143343-933@post.gmane.org>
	<20100211.033600.160118962.ryusuke@osrg.net>
	<20100211004631.1b0c8141.SebastianR@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100211004631.1b0c8141.SebastianR-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: SebastianR-Mmb7MZpHnFY@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 11 Feb 2010 00:46:31 +0100, Sebastian Reichelt wrote:
> Hi,
> 
> thanks for your really quick reply.
> 
> > The BUG tells that nilfs met a corrupted block during lookup of a
> > btree. 
> > 
> > Can you confirm which version of 2.6.31 kernel you were using?
> 
> The problem was, I had compiled the kernel on the same partition
> that is corrupted now. Anyway, by modifying the line in btree.c, I
> was able to recover most files, including the kernel
> tarball. (Though something like 1000 files are inaccessible.) I
> still cannot figure out the exact release number, though, because I
> can't find any place in the kernel source where it is written
> down. It was a kernel from the Debian testing distribution,
> downloaded on October 24. All files in the tarball are dated
> September 10. Does that help?

September 10 is the release date of 2.6.31 mainline kernel.

Hmm.. I guess your corruption is related to the missing bug-fixes.
Could you try the latest debian kernel (i.e. 2.6.32-trunk) or the
latest stable kernels ?

> I had actually seen the post on www.nilfs.org about a file system
> corruption fix in nilfs 2.0.17, but when I downloaded the Linux
> source from Debian 3 weeks later, I thought for sure they would
> include the fix. I didn't know Debian testing was this far behind on
> critical bugfixes.

Linus merged the fixes soon and they were also sent to the stable
kernel team at the same time.  I heard that gentoo took the fixes
relatively quickly.  I don't know the Debian case, but it might take
longer time.

> > > (Unfortunately, it is executed even if I use the "ro" option on the
> > > Linux command line -- why?!) It happens during a sys_open call. If
> > > the entire stack trace helps, I could post that, too.
> > 
> > Sounds weird.. 
> 
> I still don't understand why nilfs_cleanerd was started even if the
> root fs was mounted read-only, but with the patched nilfs, it became
> clear that a library required by nilfs_cleanerd was among the files
> that were inaccessible, and that's why crashed right away. If I
> mount the file system later instead (as a non-root FS), the mount
> operation actually completes; the kernel just crashes when I try to
> access some files (with an unpatched/older nilfs such as the one in
> the current Ubuntu release).

Thanks for telling me the details.  For the first issue, is there a
possibility that the partition was remounted read/write?

Rw-remount also invokes cleanerd.  Though mount.nilfs2 only runs it
after the remount operation succeeded..
 
> > Unfortunately, the disk image is rarely-helpful from my experiences
> > since it's hard to track the cause from a corrupted state.
> 
> OK, I sort of expected that it wouldn't help. Then again, since
> there is no practical way of reproducing the bug, I thought the end
> result might be the only thing one can analyze to find the
> bug. Well, I'm glad I'm not a file system developer. :-)

Since nilfs GC moves disk blocks, this makes such analysis harder
than regular filesystems.

Fortunately, the recent nilfs builds are pretty stable, and this makes
things easier than before ;)
 
> Best regards,
> Sebastian Reichelt

With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
