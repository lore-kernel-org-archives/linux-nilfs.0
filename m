From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [CFD] disk format fixing
Date: Tue, 04 May 2010 23:38:36 +0900 (JST)
Message-ID: <20100504.233836.131490856.ryusuke@osrg.net>
References: <87aash3rrm.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87aash3rrm.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 04 May 2010 00:54:21 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> It's been almost a year that nilfs2 has been merged into mainline kernel
> since 2.6.30, which is released in Jun 2009.  Yet, it still shows warnings
> that "The NILFS on-disk format may change at any time".
> 
> It still remains controversial argument, like directory indexing
> or atime support, xattr support and so on.  However, I'd like to
> make the target clear that when the above message can be taken away.
> 
> By fixing disk format, we might go forward to contribute more useful
> disk utilities like GNU pared.  Some of those user land utilities require
> just reading super block (or blocks) to identify what the filesystem is
> in the specified partition.  Therefore it would be good starting point to
> declare superblock format which ensure that upper/lower compatibilities.
> 
> In addition to superblock format, over all disk format must be fixed
> somehow everybody thinks "it's ok".

Thank you for this proposal.

I think the warning should be removed much earlier, but at least, it's
preferable that the decision is based on some consensus.

Sekiba-san, could you become the facilitator of this discussion?

I think we should take a step-by-step approach.

I agree freezing superblock format is a good milestone for it.

Preferably, it should be included for 2.6.35.

With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
