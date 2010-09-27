From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: resizing file system
Date: Tue, 28 Sep 2010 01:01:38 +0900 (JST)
Message-ID: <20100928.010138.179946334.ryusuke@osrg.net>
References: <87tylo7msw.wl%jir@sekiba.com>
	<20100918.012000.159151572.ryusuke@osrg.net>
	<87fwwvo3it.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87fwwvo3it.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: athena-/JWCw35jmeM@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 27 Sep 2010 19:59:54 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> At Sat, 18 Sep 2010 01:20:00 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > Hi,
> > On Fri, 17 Sep 2010 18:15:59 +0900, Jiro SEKIBA wrote:
> > > Hi,
> > > 
> > > I think it would be good to have a generic libraries for other user land tools,
> > > like parted, for the purpose to modify/tweek file system off line.
> > > At least, resize/fsck/mkfs are the generic functionalities that parted
> > > can handle.  So it's good if there is a library that can perform
> > > those things to avoid implementing same thing all over the place.
> > > 
> > > One big problem for parted is that parted is GPL3 and libnilfs2 is GPL2 X).
> > > Still, contributers of libnilfs2 are countable, so maybe we can get agreements
> > > from all contributers to change licence to LGPL2, isn't it?
> > 
> > Definitely yes.  I think we should migrate the licence of the library
> > to LGPL2.
> > 
> > One practical problem is that some of the source files derive the
> > kernel code, and they are licensed under GPLv2.
> > 
> > For example, nilfs2_fs.h and crc32.c are just such ones.
> > 
> > Do you think we need replacement for these?
> 
> We could choose to change the licence as LGPL like mqueue.h (*1).
> However, we may be able to think that license of nilfs2_fs.h won't affect
> license of user land tools.

> At least, Linus stated that "There's a
> clarification that user-space programs that use the standard system call
> interfaces aren't considered derived works, ..." (*2). 
>
> *1) http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=include/linux/mqueue.h;hb=HEAD
> *2) http://kerneltrap.org/node/1735

"unistd.h" is distributed under LGPL.  So, the above Linus' statement
sounds like saying just fundamental charateristics of LGPL.

The point of "nilfs2_fs.h" issue differs from that.  A copy of
nilfs2_fs.h is actually included in nilfs-utils, and the nilfs library
is depending on the copy.

The "mqueue.h" solution seems to be an approved manner (sigh).

Another solution is extracting requisites from "nilfs2_fs.h" and
rewriting them under LGPL for the library and userland programs.

Or, do you know any examples of GPL header file whose library is
licensed under LGPL?

> While, crc32.c must be replaced other implementation :(.
> I'll search lgpled implementation.

OK, let's replace it with a compatible one if we change the library
license to LGPL.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
