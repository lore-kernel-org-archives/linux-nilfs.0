From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 4/4] nilfs2: implementation of NILFS_IOCTL_SET_SUINFO
 ioctl
Date: Mon, 3 Feb 2014 13:41:01 -0800
Message-ID: <20140203134101.c56b916544e2475f63227339@linux-foundation.org>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1391446244-1435-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391446244-1435-5-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

On Tue,  4 Feb 2014 01:50:44 +0900 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:

> With this ioctl the segment usage entries in the SUFILE can be
> updated from userspace.
> 
> This is useful, because it allows the userspace GC to modify and update
> segment usage entries for specific segments, which enables it to avoid
> unnecessary write operations.
> 
> If a segment needs to be cleaned, but there is no or very little
> reclaimable space in it, the cleaning operation basically degrades to
> a useless moving operation. In the end the only thing that changes is
> the location of the data and a timestamp in the segment usage
> information. With this ioctl the GC can skip the cleaning and update
> the segment usage entries directly instead.
> 
> This is basically a shortcut to cleaning the segment. It is still
> necessary to read the segment summary information, but the writing of
> the live blocks can be skipped if it's not worth it.

Documentation/filesystems/nilfs2.txt should be updated to document the
new ioctl.

Which we're in there, please check that the ioctl documentation is
otherwise complete and up-to-date.  These things have a tendency to
bitrot.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
