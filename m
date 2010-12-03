From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs on bare NAND flash
Date: Sat, 04 Dec 2010 00:23:44 +0900 (JST)
Message-ID: <20101204.002344.133215853.ryusuke@osrg.net>
References: <20101203124151.GC662@e-circ.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101203124151.GC662-MxZ6Iy/zr/UdbCeoMzGj59i2O/JbrIOy@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: kurt.van.dijck-/BeEPy95v10@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 3 Dec 2010 13:41:51 +0100, Kurt Van Dijck wrote:
> Hello,
> 
> I may not be the first to ask this type of question, but I was unable
> to find the answer yet.
> 
> I'm looking for a solution to provide a filesystem
> in bare NAND flash (no compact flash or SSD).
> Is NILFS2 capable of running in bare NAND flash?
> I see these 2 issues:
> 1) how are bad blocks handled

Well, NILFS2 neither is optimized to bare flash devices nor supports
MTDs.

It tries to avoid bad blocks in units of segment, and uses a partition
as a circular buffer, but doesn't have wear leveling in the
filesystem.  In addition, two super blocks of NILFS2 are written back
to absolute locations of the device more times than other blocks.

Some flash filesystems such as ubifs, jffs2, and logfs have the wear
leveling and are available for MTDs.  These seem better if you don't
need snapshots.

> 2) Do I need the caching block device, or the char device?

Maybe.  I don't know whether NILFS2 works on the caching block device.
I haven't tried it yet.


Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
