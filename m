From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [CFD] disk format fixing
Date: Tue, 04 May 2010 23:01:35 +0900 (JST)
Message-ID: <20100504.230135.205087691.ryusuke@osrg.net>
References: <87aash3rrm.wl%jir@sekiba.com>
	<7E6B7E93-FCB4-4E4C-AF4F-BEA8D8FE1F20@nop.com>
	<20100504120222.GA1132@heethoofdje.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100504120222.GA1132-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org
Cc: nop-Nqdcz63CPQY@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 4 May 2010 14:02:22 +0200, Reinoud Zandijk wrote:
> On Mon, May 03, 2010 at 03:35:03PM -0400, Jay Carlson wrote:
> > On May 3, 2010, at 11:54 AM, Jiro SEKIBA wrote:
> > Low-end consumer flash (like USB thumb drives or MMC) often uses a simple
> > zone-based FTL with bad block replacement.  I am told really cheap ones
> > allocate zones with 1000 flash blocks with 24 held as replacements for
> > failing blocks and wear leveling.
> > 
> > If I understand nilfs, its superblock is both fixed location and "hot": it
> > is written fairly frequently (on every fsync?)  On cheap flash, it will wear
> > out the flash block it lives on in 25 write lifetimes or less.  
> 
> I'd opt for NOT writing out the super block but on unmount or when the
> roll-forward chain is disturbed by the garbage collector.i
> 
> Another option is to never update it; it should at most take a few secs to
> locate the latest segsum by just scanning trough the segement summaries;
> especially now the segment summaries have the checkpoint number incorporated.
>
> If on mount all first segment summaries are read (say 4000 to 8000 sectors)
> its clear wich is the newest and then follow that chain until you reach the
> end... and you can mount. I agree its not optimal but i dont see a reason as
> to why it shouldn't work :)

I was just thinking the same thing.

The reason nilfs frequently updates super blocks is for maintaining a
pointer to recent logs.  And, the new checkpoint number field allows
it to find them by scanning through summary headers of each segments.

This may be expensive for hard drives, but may be acceptable for flash
devices.  I think it's worth adding a new mount option (or a flag) for
this.

The super blocks also maintain free blocks count, but it's computable.

> It is also backwards compatible since older
> implementations can will search for the last super root; they only will need
> to read more.

You mean forward compatibility?

I think older implementations have potential to select wrong super
root due to the garbage collector.  This issue seems a key of this
approach.

Even though we can make super blocks written out on unmount as before,
an unclean shutdown and subsequent boot with an old implementation may
lead to a fatal result.

Without this issue, it looks pretty good.

With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
