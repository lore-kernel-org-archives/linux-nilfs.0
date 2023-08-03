From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 05/12] ext4: make the IS_EXT2_SB/IS_EXT3_SB checks more
 robust
Date: Thu, 3 Aug 2023 13:21:10 +0200
Message-ID: <20230803112110.7qybhrgn2rwaguu2@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-6-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1691061671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/oqdnU2hVSvQjG7zr7ybcm4vgtUzeJvEjdOgZyr5MDo=;
        b=SshCa3at/QVqc2HIIpLg9LhDhKTreRaL2cZGX45vYwIeK3cx7PttlNBGYy6OudlZNlY9ra
        MOv4rt6y4ZaVGS2gQBky7dhvCX5sAuEwxT7t0AG/xr4WPg3HrvCw3+qX5Fp1tt3Cecc/DQ
        xnTqKiRxO3ni8MzYtqEIGMQIwjC94ag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1691061671;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/oqdnU2hVSvQjG7zr7ybcm4vgtUzeJvEjdOgZyr5MDo=;
        b=H+MFCeAyi3R3yXuvvMJFuzNpnCx698yyaUcPgHxx1B/25fIvZ6HmN/YfD5MBWOxvwIKJn3
        LdjGjluOtzdqOXCQ==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-6-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 02-08-23 17:41:24, Christoph Hellwig wrote:
> Check for sb->s_type which is the right place to look at the file system
> type, not the holder, which is just an implementation detail in the VFS
> helpers.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/ext4/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c94ebf704616e5..193d665813b611 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -140,7 +140,7 @@ static struct file_system_type ext2_fs_type = {
>  };
>  MODULE_ALIAS_FS("ext2");
>  MODULE_ALIAS("ext2");
> -#define IS_EXT2_SB(sb) ((sb)->s_bdev->bd_holder == &ext2_fs_type)
> +#define IS_EXT2_SB(sb) ((sb)->s_type == &ext2_fs_type)
>  #else
>  #define IS_EXT2_SB(sb) (0)
>  #endif
> @@ -156,7 +156,7 @@ static struct file_system_type ext3_fs_type = {
>  };
>  MODULE_ALIAS_FS("ext3");
>  MODULE_ALIAS("ext3");
> -#define IS_EXT3_SB(sb) ((sb)->s_bdev->bd_holder == &ext3_fs_type)
> +#define IS_EXT3_SB(sb) ((sb)->s_type == &ext3_fs_type)
>  
>  
>  static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
