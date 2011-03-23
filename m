From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Wed, 23 Mar 2011 08:51:16 +0100
Message-ID: <20110323075116.GA530@heethoofdje.13thmonkey.org>
References: <20110319220157.GA681@heethoofdje.13thmonkey.org> <201103192312.38046.dexen.devries@gmail.com> <20110320125040.GA735@heethoofdje.13thmonkey.org> <20110321.200706.260176646.ryusuke@osrg.net> <20110321130151.GA29111@heethoofdje.13thmonkey.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110321130151.GA29111-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 21, 2011 at 02:01:51PM +0100, Reinoud Zandijk wrote:
> On Mon, Mar 21, 2011 at 08:07:06PM +0900, Ryusuke Konishi wrote:
> In NetBSD this is normally resolved by looking up the device the directory is
> residing and then opening/locking the device file etc. I think this is a
> better way of operating!

I looked it up for certainty and no, i was wrong; the ones i see are using
system calls or ioctl's on the directory as you have done Ryusuke... so not
that different :)

Cheers,
Reinoud

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
