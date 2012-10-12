From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Fri, 12 Oct 2012 12:49:15 +0100
Message-ID: <20121012114915.GE7823@csmith-bm.vm.bytemark.co.uk>
References: <20121008222557.GU28032@wloczykij> <1349767793.3427.7.camel@slavad-ubuntu> <20121009105239.GV28032@wloczykij>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009105239.GV28032@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Oct 09, 2012 at 12:52:39PM +0200, Piotr Szymaniak wrote:
> On Tue, Oct 09, 2012 at 11:29:53AM +0400, Vyacheslav Dubeyko wrote:
> > Hi,
> > 
> > On Tue, 2012-10-09 at 00:25 +0200, Piotr Szymaniak wrote:
> > > Hi list.
> > > 
> > > I'm using nilfs2 on my Raspberry Pi rootfs. I've played around with
> > > Raspberry Pi Turbo Mode and today it refused to boot. It's a headless
> > > setup so I moved the SD Card to my other machine and tried to mount
> > > rootfs partition:
> > > 
> > 
> > As I can understand Raspberry Pi Turbo Mode is a hardware overclocking.
> > So, I worry about proper working of SD-card controller. It is possible
> > that the reason of the issue can be not proper controller functioning or
> > concrete SD-card issue.
> 
> It's an ???allowed??? overcloking. I have another SD Card with Raspbian (and
> without nilfs2) that works fine with Turbo Mode. At least it seems to
> work fine. The second card was in Turbo Mode (@900MHz) for a few days
> and was working. Yesterday i made it @1000MHz and it didn't boot.


It's allowed in that it no longer invalidates your warranty, but I don't think
there is any guarantee it will work.

Overclocking also puts more load on the PSU, so there is potentially less
power available for the SD Card to work with. Perhaps a write failed due
to power issues in Turbo mode? What is your PSU rating? 0.7A is the
recommended amount the PSU should be able to supply.


As an aside, I have also been thinking of using NILFS root, but struggled to
get the default kernel up and running with an initrd (to load the nilfs2
module). Did you use a built in nilfs2 driver?

A raspbian image with NILFS root would be awesome, given the performance
benefits of NILFS on lowe end FLASH media.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
