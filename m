From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: resizing file system
Date: Sat, 18 Sep 2010 01:20:00 +0900 (JST)
Message-ID: <20100918.012000.159151572.ryusuke@osrg.net>
References: <87zkvnoo1l.fsf@fftw.org>
	<20100912.112650.179928857.ryusuke@osrg.net>
	<87tylo7msw.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87tylo7msw.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: athena-/JWCw35jmeM@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 17 Sep 2010 18:15:59 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> I think it would be good to have a generic libraries for other user land tools,
> like parted, for the purpose to modify/tweek file system off line.
> At least, resize/fsck/mkfs are the generic functionalities that parted
> can handle.  So it's good if there is a library that can perform
> those things to avoid implementing same thing all over the place.
> 
> One big problem for parted is that parted is GPL3 and libnilfs2 is GPL2 X).
> Still, contributers of libnilfs2 are countable, so maybe we can get agreements
> from all contributers to change licence to LGPL2, isn't it?

Definitely yes.  I think we should migrate the licence of the library
to LGPL2.

One practical problem is that some of the source files derive the
kernel code, and they are licensed under GPLv2.

For example, nilfs2_fs.h and crc32.c are just such ones.

Do you think we need replacement for these?

> Other utilities we can apply the libnilfs2, I can think of, are gvfs
> modules to handle snapshot from nautilus.  I don't know much about
> gvfs so it doesn't make sense..
> 
> Or maybe to create fuse driver for nilfs2 to mount snapshot without
> super user privilege, which is always obstacles to handle snapshot
> from end user's point of view.

nilfs-utils v1 had an automount support.  Unfortunately, it is not
included in nilfs-utils-v2, but I think rewriting the script for the
v2 utils would help to ease this problem.

> In any cases, having generic library is key to propagate nilfs2 user land
> implementations and which library is good to be LGPLed, I think.

Reasonable.  At least, I agree with the licence migration.  Let's
consider how to avoid the minor license issue above.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
