From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: atime
Date: Tue, 02 Aug 2011 12:24:52 +0900 (JST)
Message-ID: <20110802.122452.27798375.ryusuke@osrg.net>
References: <BLU152-W567E135957B79607CC415ECE350@phx.gbl>
	<20110728.102536.53123850.ryusuke@osrg.net>
	<4E363F5D.7060302@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E363F5D.7060302-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: davidsa-BMswWb+h+80+JF/nGntIXQ@public.gmane.org, davidsa.openu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 01 Aug 2011 08:53:33 +0300, David Sariel wrote:
> Hi
> What was the purpose of reserving the inode for atime file (nilfs2_fs.h)
> #define NILFS_ATIME_INO        7    /* Atime file (reserved) */

This declaration is reserved for an additional metadata file keeping
atime information on disk.

> Correct me if I'm wrong, but it seems to me that updating atime on the disk
> result in creating more chekpoints. So spesial file in predetermined 
> place can store
> atime of all files in the system and spare the need of checkpointings of 
> many segments.

Yes, if we implement the atime feature and enable it, nilfs will
create checkpoints every time after files are read or directories are
looked up.  It may not be a problem because recent kernels have
``relatime'' which is a nice workaroud of the atime problem.

Anyway, we would turn off this feature by default even if we add it.

> Also can you please share your thoughts about the atime implementation 
> on nilfs?

The atime file would become an array of atime timestamps consisting of
a 64-bit integer number of seconds plus 32 bits of nano-seconds.  The
reason why we reserved a separate metadata file is to minimize the
number of blocks written back by the atime updates.

Or, we may simply add these fields in the extended part of inode; we
have an idea to extend inode size to make other enhancements possible.
Not yet decided, after all.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
