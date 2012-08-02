From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd won't start for root filesystem
Date: Thu, 02 Aug 2012 18:51:06 +0900 (JST)
Message-ID: <20120802.185106.94469924.konishi.ryusuke@lab.ntt.co.jp>
References: <20120801111921.GU1478@wloczykij>
	<20120801.203417.104482564.konishi.ryusuke@lab.ntt.co.jp>
	<20120802092306.GV1478@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120802092306.GV1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 2 Aug 2012 11:23:06 +0200, Piotr Szymaniak wrote:
> On Wed, Aug 01, 2012 at 08:34:17PM +0900, Ryusuke Konishi wrote:
> > *snip*
> > 
> > How about the following workaround?
> > 
> > # ln -s /dev/<your-root-partition> /lib/udev/devices/root
> > # reboot
> 
> My udev installation is missing /lib/udev/devices dir. Maybe that's also
> distribution specific?

Ah, udev-182 and earlier provided this feature, but now it seems to be
obsolete, so support of the feature seems to depend on effort of each
distro.
 
> As a workaround I just modified my cleanerd starter script [1] to check
> if /dev/root exists and, if it is missing, create proper /dev/root symlink
> to ${TARGETDISK} before nilfs_cleanerd is started.
> 
> PS Is there some "proper" way to start nilfs_cleanerd on rootfs? Or
> every way is good as far as it works fine? (my solution is missing the
> gcpid=foo)

You can refect the gcpid attribute just by doing remount instead of
invoking cleanerd manually.

 # mount -t nilfs2 -o remount <device> <mountpoint>
 
> [1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01195.html
> 
> Piotr Szymaniak.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
