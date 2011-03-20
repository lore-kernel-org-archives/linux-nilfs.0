From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Sun, 20 Mar 2011 13:50:40 +0100
Message-ID: <20110320125040.GA735@heethoofdje.13thmonkey.org>
References: <201103191738.00187.dexen.devries@gmail.com> <20110319220157.GA681@heethoofdje.13thmonkey.org> <201103192312.38046.dexen.devries@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201103192312.38046.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Mar 19, 2011 at 11:12:37PM +0100, dexen deVries wrote:
> Hi,
> 
> On Saturday 19 of March 2011 23:01:57 you wrote:
> > BSD traditionally save some inodes/blocks for the superuser. Maybe some
> > blocks could be reserved for the nilfs_cleanerd to work with? even if only
> > a few? Depending on the uid/guid of the program?
> 
> As for reserved blocks, that's an ugly solution IMHO.

It is, but its also a service to `root'. It gives a rooted user the
possibility to use > 100% of reported disc space thus enabling him to clean up
stuff, move stuff around and making more free space. It may not be the best
solution but at least `root' is able to fix problems on a full disc!

> And so is delete-proofing the on-disk `.nilfs' file. But perhaps the
> `.nilfs' could be made a virtual file, maintained by the NILFS2 driver
> rather than a plain on-disk object?  You are right about the `.nilfs'.

The problem with looking up /mnt/ is that it (might) return the node /mnt on
the root FS and not the NiLFS root `/mnt/.' . I don't know how linux handles
such cases but if `/mnt/.' does return the NiLFS root node then why not let
NiLFS use that node instead of the /mnt/.nilfs node?

So IMHO the .nilfs file is a hack in itself :-D

With regards,
Reinoud

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
