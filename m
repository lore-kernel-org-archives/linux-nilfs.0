From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] FS: nilfs2: clamps ns_r_segments_percentage to [1, 99]
Date: Thu, 23 Feb 2012 11:31:01 +0900 (JST)
Message-ID: <20120223.113101.148425154.ryusuke@osrg.net>
References: <1329774930-17162-1-git-send-email-haogangchen@gmail.com>
	<20120223.004650.160012804.ryusuke@osrg.net>
	<EC48BE45-EA3E-400B-A90D-FF05CE3426D8@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EC48BE45-EA3E-400B-A90D-FF05CE3426D8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 22 Feb 2012 10:59:25 -0500, Xi Wang wrote:
> On Feb 22, 2012, at 10:46 AM, Ryusuke Konishi wrote:
> > But this seems not to cause security issues; it just makes some disk
> > usage calculations meaningless and causes malfunction for such
> > out-of-range values.  Right?
> 
> Seems true to me.
> 
> There may be another issue a few lines above: ns_blocks_per_segment
> doesn't seem to have an upper bound (though it has a lower bound
> NILFS_SEG_MIN_BLOCKS).  ns_blocks_per_segment is used in several
> multiplications, such as in nilfs_ioctl_clean_segments:
> 
> if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment
>         goto out_free;
> 
> Will this cause any problem?

Looks similar.  This may cause malfunction, but it seems not to cause
security issues.

However, this range check seems no longer make sense.. it looks
eliminable because the potential overflow issue was corrected by the
following fix:

                 if (argv[n].v_nmembs >= UINT_MAX / argv[n].v_size)
                        goto out_free;

Moreover, the upper bound "nsegs * nilfs->ns_blocks_per_segment" looks
improper for argv[1].v_nmembs.  The argument argv[1] is used to pass
an array of nilfs_period struct (ranges of deleting checkpoints).  But
the number of nilfs_period is not relate to the number of GCing
blocks.
 
> Or is there any reasonable upper bound
> for ns_blocks_per_segment?

Unclear.
It is not efficient to check overflow in each place.  So, if we can
define a minimum upper bound which can logically prevent overflow of
every related multiplication, we should add a pre range check with it.


Thanks,
Ryusuke Konishi
 
> - xi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
