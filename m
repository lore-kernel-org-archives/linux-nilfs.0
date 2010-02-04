From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: grub nilfs2 module
Date: Thu, 04 Feb 2010 18:03:43 +0900 (JST)
Message-ID: <20100204.180343.168036764.ryusuke@osrg.net>
References: <20100204.100228.02802641.ryusuke@osrg.net>
	<20100204.165456.217843065.ryusuke@osrg.net>
	<87d40l9zyb.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87d40l9zyb.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 04 Feb 2010 17:18:04 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi, 
> 
> At Thu, 04 Feb 2010 16:54:56 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > Hi,
> > On Thu, 04 Feb 2010 10:02:28 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> > > Hi,
> > > On Wed, 03 Feb 2010 21:43:46 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> > > > Hi,
> > > > 
> > > > I've written nilfs2 module for grub2 boot loader.
> > > > 
> > > > Here is the patch and mail I'v sent to grub-devel ML.
> > > > http://lists.gnu.org/archive/html/grub-devel/2010-02/msg00025.html
> > > 
> > > Great!
> > > 
> > > The patch looks fine to me except some work, for instance,
> > > rollforwarding and checksum based log validation is needed.
> > > 
> > > But meanwhile, this prototype seems enough to load kernels and
> > > initrds.
> > > 
> > > I'd like to try it for my laptop.
> > > 
> > > > It may not be mature yet, but I was able to boot kernel
> > > > from nilfs2 partition and mount it as rootfs.
> > > > So you are able to boot the system that has only nilfs2 partition.
> > 
> > Let me ask you a question.
> > 
> > One thing which is important in NILFS is that every block in the
> > partition can be moved by the garbage collection (except two super
> > blocks).
> > 
> > So, we cannot assume that file blocks stay in a locked position even
> > for unmodified files.
> > 
> > Doesn't this cause problems for the boot sequence of GRUB2 ?
> 
> That's a good question.
> 
> It's basically OK because there usually are room for additional code
> besides MBR in PC disk format.  The room size is 32KiB followed by MBR.
> The room is not required for linux, but historically for DOS compat.
> 
> See the link how modern disk layout is.
> http://www.pixelbeat.org/docs/disk/
> 
> You can check it with the dd by following
> # dd if=/dev/hda of=hda bs=512 count=3 skip=65
> # hexdump -C hda > hda.hex
> # dd if=/dev/hda1 of=hda1 bs=512 count=3
> # hexdump -C hda1 > hda1.hex
> 
> NOTE, the differences between two dumps are, I think, mtime in a super block.
> 
> So if you install grub2 with root directory in nilfs2, 
> grub-install will install nilfs2.mod into that additional 32KiB space
> The space is out of nilfs2 patition, so GC won't move the blocks.
> 
> thanks

Thanks! That cleared up my doubts on GC.
The reference you cited is informative.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
