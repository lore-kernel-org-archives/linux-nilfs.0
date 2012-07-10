From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Wed, 11 Jul 2012 01:40:49 +0900 (JST)
Message-ID: <20120711.014049.157490457.konishi.ryusuke@lab.ntt.co.jp>
References: <1341916735.1973.10.camel@slavad-ubuntu-11>
	<20120710.200937.163315083.konishi.ryusuke@lab.ntt.co.jp>
	<20120710140711.GY1478@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120710140711.GY1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 10 Jul 2012 16:07:11 +0200, Piotr Szymaniak wrote:
> On Tue, Jul 10, 2012 at 08:09:37PM +0900, Ryusuke Konishi wrote:
> > On Tue, 10 Jul 2012 14:38:55 +0400, Vyacheslav Dubeyko wrote:
> > > I think after analysis of strace output that Piotr Szymaniak has the
> > > same problem. But maybe I wrong. 
> > 
> > According to the log, his problem looks different.
> > 
> > cleanerd fails with ENOENT error (No such file or directory)
> > if it couldn't find the given device in /proc/mounts.
> > 
> > His /proc/mounts looks:
> > 
> > rootfs / rootfs rw 0 0
> > /dev/root / nilfs2 rw 0 0
> > ..
> > 
> > And, the strace log shows that /dev/root didn't exist.
> > 
> > I guess the problem would be fixed if a proper symbolic link pointing
> > to the real device is created as /dev/root.
> 
> Yes, it seems so. Just after I wrote my amateur strace analysis I tried
> to fix it by hand. Made a symlink from /dev/root to /dev/sda2 and
> remounted /. nilfs_cleanerd started fine.
> 
> But why is it failing on /dev/root anyway? It's started with
> /dev/disk/by-uuid/uuid pointing to a proper device (sda2). Do we really
> need /dev/root?

I don't know, that is not a matter of NILFS.
NILFS does not replace the root device with /dev/root.

NILFS library just tries to find a mount instance by comparing
canonical path names of the given device node and that in
/proc/mounts.  Symbolic links are followed in this canonicalization.

The difference was simply that /dev/disk/by-uuid/uuid was a proper
symlink to the real device and /dev/root was not in your one machine
for some reason.

> Also, maybe there's a reason to remove /dev/root? I will try later with
> some older udev to see if it is created.

In my nilfs-rooted machine, the root device node appears as /dev/sda?
in /proc/mounts, not /dev/root.  I don't know what makes this
difference.


Regards,
Ryusuke Konishi


> Piotr Szymaniak.
> -- 
> <kow`> "There are 10 types of people in the world... those who
> understand binary and those who don't."
> <SpaceRain> That's only 2 types of people, kow.
> <SpaceRain> STUPID
>   -- bash.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
