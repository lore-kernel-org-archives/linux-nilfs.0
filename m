From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 3/7] Remove kern_compat.h
Date: Fri, 23 Dec 2011 14:25:12 +0900 (JST)
Message-ID: <20111223.142512.212712228.ryusuke@osrg.net>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
	<1324503249-17432-4-git-send-email-dan@archlinux.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324503249-17432-4-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 21 Dec 2011 15:34:05 -0600, Dan McGee wrote:
> All necessary macros are already definied in include/nilfs.h, which we
> can use instead. This also removes the duplicate definitions of
> NILFS_CNO_MIN and NILFS_CNO_MAX.
> 
> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
> ---
> 
> I would appreciate other people compile testing this one as some other
> platforms or kernel headers might yield different results.

This is working in several different environments so far.

The separation of kern_compat.h was intentional.  But, I have decided
to accept this change because nilfs.h needs the same definitions
anyway.

These difinitions should be cleaned out from nilfs.h, but it's the
only realistic way that I know at present to support wide variety of
platforms.

Thanks,
Ryusuke Konishi


>  include/Makefile.am   |    2 +-
>  include/kern_compat.h |   47 -----------------------------------------------
>  lib/feature.c         |    2 +-
>  sbin/mkfs/mkfs.c      |    3 ++-
>  sbin/mkfs/mkfs.h      |    4 ----
>  5 files changed, 4 insertions(+), 54 deletions(-)
>  delete mode 100644 include/kern_compat.h
> 
> diff --git a/include/Makefile.am b/include/Makefile.am
> index 221c481..c99da99 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -1,5 +1,5 @@
>  ## Makefile.am
>  
>  include_HEADERS = nilfs.h nilfs2_fs.h nilfs_cleaner.h
> -noinst_HEADERS = realpath.h nls.h cno.h kern_compat.h nilfs_feature.h \
> +noinst_HEADERS = realpath.h nls.h cno.h nilfs_feature.h \
>  	vector.h nilfs_gc.h cnoconv.h cleaner_msg.h cleaner_exec.h
> diff --git a/include/kern_compat.h b/include/kern_compat.h
> deleted file mode 100644
> index a2cffdc..0000000
> --- a/include/kern_compat.h
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -/*
> - * kern_compat.h - kernel compat declarations
> - *
> - * Copyright (C) 2005-2011 Nippon Telegraph and Telephone Corporation.
> - *
> - * This program can be redistributed under the terms of the GNU Lesser
> - * General Public License.
> - */
> -
> -#ifndef NILFS_KERN_COMPAT_H
> -#define NILFS_KERN_COMPAT_H
> -
> -#include <linux/types.h>
> -#include <endian.h>
> -#include <byteswap.h>
> -
> -#ifndef __bitwise  /* Tricky workaround; should be replaced */
> -typedef __u64 __le64;
> -typedef __u32 __le32;
> -typedef __u16 __le16;
> -#endif
> -
> -#ifndef le32_to_cpu
> -#if __BYTE_ORDER == __LITTLE_ENDIAN
> -#define cpu_to_le16(x) (x)
> -#define cpu_to_le32(x) (x)
> -#define cpu_to_le64(x) (x)
> -#define le16_to_cpu(x) (x)
> -#define le32_to_cpu(x) (x)
> -#define le64_to_cpu(x) (x)
> -#elif __BYTE_ORDER == __BIG_ENDIAN
> -#define le16_to_cpu(x) bswap_16(x)
> -#define le32_to_cpu(x) bswap_32(x)
> -#define le64_to_cpu(x) bswap_64(x)
> -#define cpu_to_le16(x) bswap_16(x)
> -#define cpu_to_le32(x) bswap_32(x)
> -#define cpu_to_le64(x) bswap_64(x)
> -#else
> -#error "unsupported endian"
> -#endif /* __BYTE_ORDER */
> -#endif /* le32_to_cpu */
> -
> -#ifndef BUG
> -#define BUG()	abort()
> -#endif
> -
> -#endif	/* NILFS_KERN_COMPAT_H */
> diff --git a/lib/feature.c b/lib/feature.c
> index b346cea..b5752f2 100644
> --- a/lib/feature.c
> +++ b/lib/feature.c
> @@ -43,7 +43,7 @@
>  
>  #include <errno.h>
>  #include <assert.h>
> -#include "kern_compat.h"
> +#include "nilfs.h"
>  #include "nilfs2_fs.h"
>  #include "nilfs_feature.h"
>  
> diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
> index 43a9657..870c682 100644
> --- a/sbin/mkfs/mkfs.c
> +++ b/sbin/mkfs/mkfs.c
> @@ -72,8 +72,9 @@
>  
>  #include <errno.h>
>  
> -#include "mkfs.h"
> +#include "nilfs.h"
>  #include "nilfs_feature.h"
> +#include "mkfs.h"
>  
>  
>  typedef __u64  blocknr_t;
> diff --git a/sbin/mkfs/mkfs.h b/sbin/mkfs/mkfs.h
> index 643060c..ce065a0 100644
> --- a/sbin/mkfs/mkfs.h
> +++ b/sbin/mkfs/mkfs.h
> @@ -24,7 +24,6 @@
>   * Revised by Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>.
>   */
>  
> -#include "kern_compat.h"
>  #include "nilfs2_fs.h"
>  
>  #define NILFS_DISKHDR_SIZE 		4096 /* HDD header (MBR+superblock) */
> @@ -41,9 +40,6 @@
>  #define NILFS_DEF_RESERVED_SEGMENTS     5    /* default percentage of reserved
>  						segments: 5% */
>  
> -#define NILFS_CNO_MIN   1
> -#define NILFS_CNO_MAX   (~(__u64)0)
> -
>  #define NILFS_MAX_BMAP_ROOT_PTRS	(NILFS_INODE_BMAP_SIZE - 1)
>  #define NILFS_MIN_BLOCKSIZE		1024
>  #define NILFS_MIN_NUSERSEGS		8    /* Minimum number of user
> -- 
> 1.7.8
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
