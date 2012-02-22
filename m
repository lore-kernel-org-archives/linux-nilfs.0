From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] FS: nilfs2: clamps ns_r_segments_percentage to [1, 99]
Date: Thu, 23 Feb 2012 00:46:50 +0900 (JST)
Message-ID: <20120223.004650.160012804.ryusuke@osrg.net>
References: <1329774930-17162-1-git-send-email-haogangchen@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329774930-17162-1-git-send-email-haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, Chen

On Mon, 20 Feb 2012 16:55:30 -0500, Haogang Chen wrote:
> ns_r_segments_percentage is read from the disk. Bogus or malicious
> value could cause integer overflow and potential security holes.
> This patch reports error when mounting such bogus volumes.
> 
> Signed-off-by: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Ok, I will pick this up as a fix.

But this seems not to cause security issues; it just makes some disk
usage calculations meaningless and causes malfunction for such
out-of-range values.  Right?

May I amend the change log in terms of the impact ?


Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/the_nilfs.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index d327140..e12b47b 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -409,6 +409,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
>  	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
>  	nilfs->ns_r_segments_percentage =
>  		le32_to_cpu(sbp->s_r_segments_percentage);
> +	if (nilfs->ns_r_segments_percentage < 1 ||
> +		nilfs->ns_r_segments_percentage > 99) {
> +		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
> +		return -EINVAL;
> +	}
> +
>  	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
>  	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
>  	return 0;
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
