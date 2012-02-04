From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] nilfs2: avoid overflowing segment numbers in
 nilfs_ioctl_clean_segments()
Date: Fri, 3 Feb 2012 20:36:05 -0800
Message-ID: <20120203203605.da735392.akpm@linux-foundation.org>
References: <1328282767-13158-1-git-send-email-xi.wang@gmail.com>
	<20120204.121302.227986518.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120204.121302.227986518.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sat, 04 Feb 2012 12:13:02 +0900 (JST) Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:

> On Fri,  3 Feb 2012 10:26:07 -0500, Xi Wang wrote:
> > nsegs is read from userspace.  Limit its value and avoid overflowing
> > nsegs * sizeof(__u64) in the subsequent call to memdup_user().
> > 
> > This patch complements 481fe17e973fb97aa3edf17c69557afe88d8334f.
> > 
> > Signed-off-by: Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > ---
> >  fs/nilfs2/ioctl.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Acked-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> 
> 
> Thank you for posting this fix.
> 
> Andrew, could you send this uptream in this cycle ?

I sure can.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
