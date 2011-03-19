From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Sat, 19 Mar 2011 23:01:57 +0100
Message-ID: <20110319220157.GA681@heethoofdje.13thmonkey.org>
References: <201103191738.00187.dexen.devries@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201103191738.00187.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Mar 19, 2011 at 05:37:59PM +0100, dexen deVries wrote:
> It seems on a completely filled filesystem nilfs_cleanerd cannot be started
> (nor other utilities that rely on the same libnilfs nilfs_open() function).
> 
> This is seriously troubling because removing some files does not free up the space
> (per NILFS2 design), so it looks like there is no way to use this filesystem ever again,
> at least without manual intervetion into on-disk metadata.
> 
> strace shows the following:
> 
> blitz!root!/tmp# strace -f /sbin/nilfs_cleanerd /dev/sda1 /mnt/x -p 2
> (...lotsa normal output...)
> open("/mnt/x/.nilfs", O_RDWR|O_CREAT, 0666) = -1 ENOSPC (No space left on device)
> close(4)                                = 0

I presume that /mnt/x/.nilfs is a node on the mounted FS? Shouldn't that node
be present allways and thus doesn't need to be created? or is it deleted first
and then recreated resulting in an error since the FS is full? ;)

BSD traditionally save some inodes/blocks for the superuser. Maybe some blocks
could be reserved for the nilfs_cleanerd to work with? even if only a few?
Depending on the uid/guid of the program?

just some thougts,
Reinoud

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
