From: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs: nilfs2: fix memory leak in
 nilfs_sysfs_create_device_group
Date: Thu, 20 Jan 2022 17:07:35 +0300
Message-ID: <0bc923d8-6565-69a3-c234-3789707efeb9@gmail.com>
References: <20220120134415.57147-1-dzm91@hust.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=khQglnbXo1F6ghNCeJbEOjQxnRPP7WedSM2hEo1x1cg=;
        b=VQDTlTdn9a0nWrjEasDAQTrYLleF53p9YhUEw8B2T97sSUp+ixfG+inujDyMEADSnS
         QBAB49YGKsDyaAFS8TZ/FRdn1F3yBm9X9AteH3nKtr3DPB4d8PNHTYKscD14mG3009pQ
         LrLC87NnuDzUp6ieKWkWd7XjPXn/cG+tsBeWNCTloPeAcRVO66ZWaN1ZWdAM8d6zt9qy
         FvCOA2Kcxtq0opx8MAdh7PXVc5OUUn6AaizkD1Qwoc1nmsm85ApoHcdh2J6lHJLP2zIJ
         Z8Zt9njEsekwcrST3HWCIywDdOe9d6IU3KMDwF+SAF99OolUBuT1Ehd25W0mFXqAMZ3a
         wwEA==
Content-Language: en-US
In-Reply-To: <20220120134415.57147-1-dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dongliang,

On 1/20/22 16:44, Dongliang Mu wrote:
> The preivous commit 8fd0c1b0647a ("nilfs2: fix memory leak in
> nilfs_sysfs_delete_device_group") only handles the memory leak in the
> nilfs_sysfs_delete_device_group. However, the similar memory leak still
> occurs in the nilfs_sysfs_create_device_group.
> 
> Fix it by adding kobject_del when
> kobject_init_and_add succeeds, but one of the following calls fails.
> 
> Fixes: 8fd0c1b0647a ("nilfs2: fix memory leak in nilfs_sysfs_delete_device_group")

Why Fixes tag points to my commit? This issue was introduced before my patch

> Signed-off-by: Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
> ---
>   fs/nilfs2/sysfs.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index 379d22e28ed6..0b2db2b499d5 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -995,7 +995,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
>   
>   	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
>   	if (err)
> -		goto cleanup_dev_kobject;
> +		goto delete_dev_kobject;
>   
>   	err = nilfs_sysfs_create_checkpoints_group(nilfs);
>   	if (err)
> @@ -1027,6 +1027,9 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
>   delete_mounted_snapshots_group:
>   	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
>   
> +delete_dev_kobject:
> +	kobject_del(&nilfs->ns_dev_kobj);
> +
>   cleanup_dev_kobject:
>   	kobject_put(&nilfs->ns_dev_kobj);
>   	kfree(nilfs->ns_dev_subgroups);
With regards,
Pavel Skripkin
