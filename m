From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: grub nilfs2 module
Date: Thu, 04 Feb 2010 16:54:56 +0900 (JST)
Message-ID: <20100204.165456.217843065.ryusuke@osrg.net>
References: <87vdeea3r1.wl%jir@sekiba.com>
	<20100204.100228.02802641.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100204.100228.02802641.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 04 Feb 2010 10:02:28 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Hi,
> On Wed, 03 Feb 2010 21:43:46 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> > Hi,
> > 
> > I've written nilfs2 module for grub2 boot loader.
> > 
> > Here is the patch and mail I'v sent to grub-devel ML.
> > http://lists.gnu.org/archive/html/grub-devel/2010-02/msg00025.html
> 
> Great!
> 
> The patch looks fine to me except some work, for instance,
> rollforwarding and checksum based log validation is needed.
> 
> But meanwhile, this prototype seems enough to load kernels and
> initrds.
> 
> I'd like to try it for my laptop.
> 
> > It may not be mature yet, but I was able to boot kernel
> > from nilfs2 partition and mount it as rootfs.
> > So you are able to boot the system that has only nilfs2 partition.

Let me ask you a question.

One thing which is important in NILFS is that every block in the
partition can be moved by the garbage collection (except two super
blocks).

So, we cannot assume that file blocks stay in a locked position even
for unmodified files.

Doesn't this cause problems for the boot sequence of GRUB2 ?


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
