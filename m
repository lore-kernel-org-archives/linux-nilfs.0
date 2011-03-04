From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 1/8] lscp: support opening mounted filesystem by
 directory pathname
Date: Fri, 04 Mar 2011 19:26:09 +0900 (JST)
Message-ID: <20110304.192609.247659638.ryusuke@osrg.net>
References: <201103031723.22583.dexen.devries@gmail.com>
	<20110304.021603.234305303.ryusuke@osrg.net>
	<201103031931.32310.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103031931.32310.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 3 Mar 2011 19:31:32 +0100, dexen deVries wrote:
> On Thursday 03 of March 2011 18:16:03 you wrote:
> > By the way, can you enhance the series so that the directory argument
> > works for any directories in the filesystem rather than just a mount
> > point?
> 
> 
> That actually was aim at some point -- to let indicate filesystem by any object 
> on it. However, I can't find a reliable way. If you can hint one, I'll gladly 
> implement.
> 
> First idea was to use stat's (struct stat).st_dev, but it seems there is no 
> standard way of translating (minor, major) into filesystem from userspace. 
> There's a kernel function for that, but not exposed through syscall. There is 
> a custom library function by HP, but it doesn't feel very reasonable to rely 
> on it.
> 
> Second idea was to process pathname by combination of realpath() and stripping 
> segments -- but it turns out dot-dot semantics are broken in POSIX OSes [1] 
> making that way unreliable.
> 
> One caveat is that a device would not indicate the filesystem it belongs to, 
> but a filesystem on a partition/device it addresses.
> 
> Another caveat is that processing a NILFS2 stored in a file (say, a HDD image) 
> would require some specialized syntax.
> 
> While those may not sound very serious for interactive use, I believe that our 
> tools would become too unreliable for scripts in some edge cases.
> 
> Thus I gave up ;-)
> 
> A minimalistic version -- only lstat() [sic] with S_ISDIR() -- would work, but 
> that's not very much of a progress to me.
> 
> 
> [1] http://doc.cat-v.org/plan_9/4th_edition/papers/lexnames

I understood your point.

IMO, you don't worry about the ".." semantics breakage so serious.
The current nilfs tools are comparing pathnames using canonicalized
paths.  If we really attend to the issue, all tools and libraries in
nilfs-utils should be rethought together.

So, let's go ahead.

> One caveat is that a device would not indicate the filesystem it belongs to, 
> but a filesystem on a partition/device it addresses.

In the new directory semantics, we needs to decide if a given
directory argument belongs to a mount point in the mtab entries.

This matching check needs to know whether the given directory crosses
over a filesystem boundary starting from each mount point.  And, this
needs testing if each intermediate directory is a mount point or not.

"mountpoint" command judges this by comparing device ids and inode
numbers for each directory with its parent.

Since tools doesn't know existing mount points unless they parse
/proc/mounts individually, I think it's better to extend
nilfs_find_fs() and nilfs_open() to allow the new semantics.

You may as well add an extra open flag to nilfs_open (for instance,
NILFS_OPEN_ALLOW_SUBDIRS) which changes the meaning of the directory
argument slightly so that the mount point to which the given directory
belongs is selected.

Any thoughts?

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
