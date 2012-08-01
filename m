From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd won't start for root filesystem
Date: Wed, 01 Aug 2012 20:34:17 +0900 (JST)
Message-ID: <20120801.203417.104482564.konishi.ryusuke@lab.ntt.co.jp>
References: <20120801090028.GT1478@wloczykij>
	<1544142.eijMQvyoNB@coil>
	<20120801111921.GU1478@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120801111921.GU1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 1 Aug 2012 13:19:21 +0200, Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org> wrote:
> On Wed, Aug 01, 2012 at 11:32:58AM +0200, dexen deVries wrote:
> > Hi Piotr,
> > 
> > 
> > On Wednesday 01 of August 2012 11:00:28 you wrote:
> > > Got similar issue [1] few days ago.
> > > 
> > > [1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01186.html
> > 
> > quick recap, have you gotten any solution better than creating /dev/root 
> > symlink by hand? ;-)
> 
> udev downgrade... Looks like there are also other things broken by
> missing /dev/root [1] [2] [3] (a least in Gentoo Linux).
> 
> [1] https://bugs.gentoo.org/381761
> [2] https://bugs.gentoo.org/427818
> [3] https://bugs.gentoo.org/390519
> 
> 
> Piotr Szymaniak.

How about the following workaround?

# ln -s /dev/<your-root-partition> /lib/udev/devices/root
# reboot


Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
