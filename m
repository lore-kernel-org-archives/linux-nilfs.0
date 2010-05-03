From: Jay Carlson <nop-Nqdcz63CPQY@public.gmane.org>
Subject: Re: [CFD] disk format fixing
Date: Mon, 3 May 2010 15:35:03 -0400
Message-ID: <7E6B7E93-FCB4-4E4C-AF4F-BEA8D8FE1F20@nop.com>
References: <87aash3rrm.wl%jir@sekiba.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87aash3rrm.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On May 3, 2010, at 11:54 AM, Jiro SEKIBA wrote:

> By fixing disk format, we might go forward to contribute more useful
> disk utilities like GNU pared.  Some of those user land utilities require
> just reading super block (or blocks) to identify what the filesystem is
> in the specified partition.  Therefore it would be good starting point to
> declare superblock format which ensure that upper/lower compatibilities.

Low-end consumer flash (like USB thumb drives or MMC) often uses a simple zone-based FTL with bad block replacement.  I am told really cheap ones allocate zones with 1000 flash blocks with 24 held as replacements for failing blocks and wear leveling.

If I understand nilfs, its superblock is both fixed location and "hot": it is written fairly frequently (on every fsync?)  On cheap flash, it will wear out the flash block it lives on in 25 write lifetimes or less.  

I don't know if this is a serious danger, or worth much effort to fix.  The best we could do is extend the filesystem lifetime to 1024 write lifetimes (if we perfectly spread writes across the zone.)  

Some approaches to this would require modification of the superblock; for instance, having the main superblock point to a per-mount "session" superblock (placed randomly somewhere before s_first_data_block).

ext2 supports the sb=n option at mount to specify the superblock's offset from start of device.  If nilfs supported this, userspace mount tools could choose their own policy for moving the superblock around.

(For example, they could write the offset into a non-standard block 0, or stash it in s_volume_name; they could also scan a region looking for the most recent mount time, and so on.  These are cheap hacks.)

Again, I don't know if this is even a problem or worth addressing, but it's the only possible nilfs write pattern incompatible with cheap flash memory that I could think of.

Jay


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
