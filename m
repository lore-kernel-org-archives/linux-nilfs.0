From: Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] FS: nilfs2: clamps ns_r_segments_percentage to [1, 99]
Date: Wed, 22 Feb 2012 10:59:25 -0500
Message-ID: <EC48BE45-EA3E-400B-A90D-FF05CE3426D8@gmail.com>
References: <1329774930-17162-1-git-send-email-haogangchen@gmail.com> <20120223.004650.160012804.ryusuke@osrg.net>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        bh=zRJftlwgd1/kKiRu+rJO9MRKwt2Ak6mp4vopxw2tlbc=;
        b=IddxFRZpzhJcRiUrrpaZCVVTQfbywTn4VfkEv4AUcoLzy+xLpZ1XDHGmcKuasQxBhe
         B3mf/ZTQOMliQ7P5UXsF1OPdSDtJyN5VKhjAZxVbyorvn3AeebKoJGzNZL00CSdBw4Lx
         0FMNaQvJzMdg9ozuAyurhcqIfTDuID0GlTwyE=
In-Reply-To: <20120223.004650.160012804.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Feb 22, 2012, at 10:46 AM, Ryusuke Konishi wrote:
> But this seems not to cause security issues; it just makes some disk
> usage calculations meaningless and causes malfunction for such
> out-of-range values.  Right?

Seems true to me.

There may be another issue a few lines above: ns_blocks_per_segment
doesn't seem to have an upper bound (though it has a lower bound
NILFS_SEG_MIN_BLOCKS).  ns_blocks_per_segment is used in several
multiplications, such as in nilfs_ioctl_clean_segments:

if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment
        goto out_free;

Will this cause any problem?  Or is there any reasonable upper bound
for ns_blocks_per_segment?

- xi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
