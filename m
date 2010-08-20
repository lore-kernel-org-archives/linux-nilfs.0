From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: FYI: User land tools status
Date: Sat, 21 Aug 2010 02:51:19 +0900 (JST)
Message-ID: <20100821.025119.118979096.ryusuke@osrg.net>
References: <87zkwhx55n.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zkwhx55n.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 20 Aug 2010 13:46:28 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> I'm pleased to share the status of the user land tools I've been working on.
> Recently a few patches are incorporated into util-linux-ng and udisks
> to support NILFS.  With those changes, you can play with NILFS more
> convenient manner now.
> 
> New blkid in util-linux-ng let you mount NILFS partition with volume label
> or UUID instead of device file, just like other filesystem does.
> 
> Furthermore you can use palimpsest to create, mount, umount the NILFS
> partition by new udisks(aka DeviceKit-disks).
> 
> palimpsest is a graphical tool to manage drives and media of
> gnome-disk-utility project used in ubuntu.
> 
> I don't see any Distro updates to support those yet, but at least
> you can try those by retrieving source code repository of those projects.
> 
> util-linux-ng:
>  git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
> udisks:
>  git://git.freedesktop.org/git/DeviceKit/DeviceKit-disks.git
> 
> You need recent util-linux-ng and nilfs2-utils to try the new udisks.
> 
> I also working on GNU parted to support NILFS.  The patch is already
> in public, but need some more "paper work" for code assignment.
> http://lists.alioth.debian.org/pipermail/parted-devel/2010-July/003715.html
> 
> Any feedbacks, comments, requests for those utilities/patches are welcome!
> 
> Thanks,
> 
> Regards,
> -- 
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Thank you very much for your hard work!

I've updated current status page of nilfs.org.

I hope these work will be incorporated in distro packages without
incident.  These are really useful.

Especially, I appreciate this sort of help on userland because my
hands are now full with kernel issues.  I hope you continue to work
with to move things forward.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
