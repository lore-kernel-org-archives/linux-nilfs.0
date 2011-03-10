From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: move NILFS_SUPER_MAGIC to linux/magic.h
Date: Thu, 10 Mar 2011 17:22:23 +0900 (JST)
Message-ID: <20110310.172223.267498745.ryusuke@osrg.net>
References: <87aah3bec8.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87aah3bec8.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 10 Mar 2011 16:54:15 +0900, Jiro SEKIBA wrote:
> move NILFS_SUPER_MAGIC macro to linux/magic.h from linux/nilfs2_fs.h
> in the same manner as other filessytem magic number defined in the file.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

All right, I'll take this through the nilfs tree.

Thanks,
Ryusuke Konishi

> ---
>  include/linux/magic.h     |    1 +
>  include/linux/nilfs2_fs.h |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/magic.h b/include/linux/magic.h
> index 62730ea..248930e 100644
> --- a/include/linux/magic.h
> +++ b/include/linux/magic.h
> @@ -23,6 +23,7 @@
>  #define XENFS_SUPER_MAGIC	0xabba1974
>  #define EXT4_SUPER_MAGIC	0xEF53
>  #define BTRFS_SUPER_MAGIC	0x9123683E
> +#define NILFS_SUPER_MAGIC	0x3434
>  #define HPFS_SUPER_MAGIC	0xf995e849
>  #define ISOFS_SUPER_MAGIC	0x9660
>  #define JFFS2_SUPER_MAGIC	0x72b6
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index ae33ac2..8768c46 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -40,6 +40,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> +#include <linux/magic.h>
>  
>  
>  #define NILFS_INODE_BMAP_SIZE	7
> @@ -242,7 +243,6 @@ struct nilfs_super_block {
>  #define NILFS_USER_INO		11	/* Fisrt user's file inode number */
>  
>  #define NILFS_SB_OFFSET_BYTES	1024	/* byte offset of nilfs superblock */
> -#define NILFS_SUPER_MAGIC	0x3434	/* NILFS filesystem  magic number */
>  
>  #define NILFS_SEG_MIN_BLOCKS	16	/* Minimum number of blocks in
>  					   a full segment */
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
