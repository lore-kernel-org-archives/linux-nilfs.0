From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: grub nilfs2 module
Date: Thu, 04 Feb 2010 18:21:39 +0900 (JST)
Message-ID: <20100204.182139.37565943.ryusuke@osrg.net>
References: <87vdeea3r1.wl%jir@sekiba.com>
	<20100204.100228.02802641.ryusuke@osrg.net>
	<87bpg59xug.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87bpg59xug.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 04 Feb 2010 18:03:35 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> > It would be nice if you could tell us belief usage of the patch.

s/belief/brief/

;) 

> OK, sure.  It's against bazaar repository, so you have to build
> it from repository source instead of latest stable release tarball.
> 
> To build with stable release(1.97.2), you need to modify fs/nilfs2.c
> not to use grub_xasprintf, but use grub_malloc and grub_sprintf.
> 
> You may get reject for makefile, but I think it'll be OK.
> 
> 
> Here are the instruction to retrieve grub repository and build the softoware.
> 
> $ bzr branch http://bzr.savannah.gnu.org/r/grub/trunk/grub
> $ cd grub
> $ patch -p0 < /path/to/the/patch
> $ sh autogen.sh
> $ ./configure
> $ make
> 
> you need "make install" as usual.  It will install under /usr/local
> without giving any parameters for ./configure.
> 
> The "make install" won't install grub to MBR.
> To install grub into MBR, you have to "grub-install" to target disk.
> 
> For example, assume that you have nilfs2 filesystem on hdb1,
> mounted on /mnt and want to enable hdb as bootable.  You'll do
> 
> # grub-install --root-directory=/mnt /dev/hdb
> 
> This will install grub into hdb's MBR and other required files into
> following 32KiB blocks.  Fuhtermore, it'll install files under
> /mnt/boot/grub.  Those files are not required to boot grub to read
> the filesystem.
> 
> hdb is now self bootable disk.  You'll just connect it as hdb and
> grub will boot up.
> 
> Note, during grub-install, /boog/grub/grub.cfg will be copied int to
> /mnt/boo/grub, which is not the one for hdb.  So you have edit menu
> at first time you boot with hdb.  After boot the system, you can reproduce
> the menu by grub-mkcofnig > /boot/grub/grub.cfg
> 
> Enjoy!

Thank you once again.

I'll catch up the above steps and then comment later.

Ryusuke
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
