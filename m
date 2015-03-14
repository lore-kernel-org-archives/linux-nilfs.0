From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 7/9] nilfs2: add additional flags for nilfs_vdesc
Date: Sat, 14 Mar 2015 12:21:12 +0900 (JST)
Message-ID: <20150314.122112.881359681872630378.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
	<1424804504-10914-8-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Gm+WNNvyGrPDWTj9oveG4MXT9B5AoTXsJ+wF+ZBo1Os=;
        b=Ig4hl3t5oseOTUpnqh/Tyiv6LF4wWJl1gUNI+/x3idj/s+qV+VIyzuUyNS6SstFRLX
         F5Ne2tVaOH1nC/b6olY0ut3qxBFIjDm4W4YpJ0e5u1oZnndtEoM1Yl4SSEXQyfV8jB/K
         bjLEK+LzKpEwWt6IuQQAzOLLc7/Cb/YMwt6haPNgBI7WGGcZDxwXwa1HijyUj5deTRT/
         tLdfqMYX7fcYRBBd25g+ce8IK+JxIh6ZdMCCHJL988o1TGnU4jWKFUKtE9ymkn33Cctf
         Y00PYwWEwGiQV3EqxDfmuX0sm7f9Ba1xC9nBJSorfj8Cg/P+kjSpWcXrswUB6Ku9Mcsp
         HIGw==
In-Reply-To: <1424804504-10914-8-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Feb 2015 20:01:42 +0100, Andreas Rohner wrote:
> This patch adds support for additional bit-flags to the
> nilfs_vdesc structure used by the GC to communicate block
> information from userspace. The field vd_flags cannot be used for
> this purpose, because it does not support bit-flags, and changing
> that would break backwards compatibility. Therefore the padding
> field is renamed to vd_blk_flags to contain more flags.
> 
> Unfortunately older versions of the userspace tools do not
> initialize the padding field to zero. So it is necessary to signal
> to the kernel if the new vd_blk_flags field contains usable flags
> or just random data. Since the vd_period field is only used in
> userspace, and is guaranteed to contain a value that is > 0
> (NILFS_CNO_MIN == 1), it can be used to give the kernel a hint. So
> if the userspace tools set vd_period.p_start to 0, the
> vd_blk_flags field will be interpreted.
> 
> To make the flags available for later stages of the GC process,
> they are mapped to corresponding buffer_head flags.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c         | 23 ++++++++++++++++---
>  fs/nilfs2/page.h          |  6 ++++-
>  include/linux/nilfs2_fs.h | 58 +++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 81 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index f6ee54e..63b1c77 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -578,7 +578,7 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
>  	struct buffer_head *bh;
>  	int ret;
>  
> -	if (vdesc->vd_flags == 0)
> +	if (nilfs_vdesc_data(vdesc))
>  		ret = nilfs_gccache_submit_read_data(
>  			inode, vdesc->vd_offset, vdesc->vd_blocknr,
>  			vdesc->vd_vblocknr, &bh);
> @@ -592,7 +592,8 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
>  			       "%s: invalid virtual block address (%s): "
>  			       "ino=%llu, cno=%llu, offset=%llu, "
>  			       "blocknr=%llu, vblocknr=%llu\n",
> -			       __func__, vdesc->vd_flags ? "node" : "data",
> +			       __func__,
> +			       nilfs_vdesc_node(vdesc) ? "node" : "data",
>  			       (unsigned long long)vdesc->vd_ino,
>  			       (unsigned long long)vdesc->vd_cno,
>  			       (unsigned long long)vdesc->vd_offset,
> @@ -603,7 +604,8 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
>  	if (unlikely(!list_empty(&bh->b_assoc_buffers))) {
>  		printk(KERN_CRIT "%s: conflicting %s buffer: ino=%llu, "
>  		       "cno=%llu, offset=%llu, blocknr=%llu, vblocknr=%llu\n",
> -		       __func__, vdesc->vd_flags ? "node" : "data",
> +		       __func__,
> +		       nilfs_vdesc_node(vdesc) ? "node" : "data",
>  		       (unsigned long long)vdesc->vd_ino,
>  		       (unsigned long long)vdesc->vd_cno,
>  		       (unsigned long long)vdesc->vd_offset,
> @@ -612,6 +614,12 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
>  		brelse(bh);
>  		return -EEXIST;
>  	}
> +
> +	if (nilfs_vdesc_snapshot(vdesc))
> +		set_buffer_nilfs_snapshot(bh);
> +	if (nilfs_vdesc_protection_period(vdesc))
> +		set_buffer_nilfs_protection_period(bh);
> +
>  	list_add_tail(&bh->b_assoc_buffers, buffers);
>  	return 0;
>  }
> @@ -662,6 +670,15 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
>  		}
>  
>  		do {
> +			/*
> +			 * old user space tools to not initialize vd_blk_flags
> +			 * if vd_period.p_start > 0 then vd_blk_flags was
> +			 * not initialized properly and may contain invalid
> +			 * flags
> +			 */
> +			if (vdesc->vd_period.p_start > 0)
> +				vdesc->vd_blk_flags = 0;
> +
>  			ret = nilfs_ioctl_move_inode_block(inode, vdesc,
>  							   &buffers);
>  			if (unlikely(ret < 0)) {
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index a43b828..b9117e6 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -36,13 +36,17 @@ enum {
>  	BH_NILFS_Volatile,
>  	BH_NILFS_Checked,
>  	BH_NILFS_Redirected,
> +	BH_NILFS_Snapshot,
> +	BH_NILFS_Protection_Period,
>  };
>  
>  BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
>  BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
>  BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
>  BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
> -

> +BUFFER_FNS(NILFS_Snapshot, nilfs_snapshot)	/* belongs to a snapshot */
> +BUFFER_FNS(NILFS_Protection_Period, nilfs_protection_period) /* protected by
> +							protection period */
>  

I propose alternative names: "snapshot_protected", and
"period_protected" (or "time_protected") respectively to clarify
meaning of the flags.

>  int __nilfs_clear_page_dirty(struct page *);
>  
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 6ccb2ad..6ffdc09 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -900,7 +900,7 @@ struct nilfs_vinfo {
>   * @vd_blocknr: disk block number
>   * @vd_offset: logical block offset inside a file
>   * @vd_flags: flags (data or node block)
> - * @vd_pad: padding
> + * @vd_blk_flags: additional flags
>   */
>  struct nilfs_vdesc {
>  	__u64 vd_ino;
> @@ -910,9 +910,63 @@ struct nilfs_vdesc {
>  	__u64 vd_blocknr;
>  	__u64 vd_offset;
>  	__u32 vd_flags;
> -	__u32 vd_pad;
> +	/*
> +	 * vd_blk_flags needed because vd_flags doesn't support
> +	 * bit-flags because of backwards compatibility
> +	 */
> +	__u32 vd_blk_flags;
>  };
>  

> +/* vdesc flags */
> +enum {
> +	NILFS_VDESC_DATA,
> +	NILFS_VDESC_NODE,
> +
> +	/* ... */
> +};
> +enum {
> +	NILFS_VDESC_SNAPSHOT,
> +	NILFS_VDESC_PROTECTION_PERIOD,
> +
> +	/* ... */
> +
> +	__NR_NILFS_VDESC_FIELDS,
> +};
> +
> +#define NILFS_VDESC_FNS(flag, name)					\
> +static inline void							\
> +nilfs_vdesc_set_##name(struct nilfs_vdesc *vdesc)			\
> +{									\
> +	vdesc->vd_flags = NILFS_VDESC_##flag;				\
> +}									\
> +static inline int							\
> +nilfs_vdesc_##name(const struct nilfs_vdesc *vdesc)			\
> +{									\
> +	return vdesc->vd_flags == NILFS_VDESC_##flag;			\
> +}
> +

Do not add definitions for vd_flags, leave them, and
simplify your patch.

Regards,
Ryusuke Konishi

> +#define NILFS_VDESC_FNS2(flag, name)					\
> +static inline void							\
> +nilfs_vdesc_set_##name(struct nilfs_vdesc *vdesc)			\
> +{									\
> +	vdesc->vd_blk_flags |= (1UL << NILFS_VDESC_##flag);		\
> +}									\
> +static inline void							\
> +nilfs_vdesc_clear_##name(struct nilfs_vdesc *vdesc)			\
> +{									\
> +	vdesc->vd_blk_flags &= ~(1UL << NILFS_VDESC_##flag);		\
> +}									\
> +static inline int							\
> +nilfs_vdesc_##name(const struct nilfs_vdesc *vdesc)			\
> +{									\
> +	return !!(vdesc->vd_blk_flags & (1UL << NILFS_VDESC_##flag));	\
> +}
> +
> +NILFS_VDESC_FNS(DATA, data)
> +NILFS_VDESC_FNS(NODE, node)
> +NILFS_VDESC_FNS2(SNAPSHOT, snapshot)
> +NILFS_VDESC_FNS2(PROTECTION_PERIOD, protection_period)
> +
>  /**
>   * struct nilfs_bdesc - descriptor of disk block number
>   * @bd_ino: inode number
> -- 
> 2.3.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
