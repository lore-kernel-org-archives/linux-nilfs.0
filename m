From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v3 2/3] nilfs2: add nilfs_sufile_set_suinfo to update
 segment usage
Date: Tue, 28 Jan 2014 04:07:35 +0900 (JST)
Message-ID: <20140128.040735.413842146.konishi.ryusuke@lab.ntt.co.jp>
References: <bb721a6255f199eb4a3fdfe2b34e0bdaa5f870a7.1390816620.git.andreas.rohner@gmx.net>
	<bb721a6255f199eb4a3fdfe2b34e0bdaa5f870a7.1390816620.git.andreas.rohner@gmx.net>
	<93a209490951530b1b9eb03be4e3b309d36740f4.1390816620.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <93a209490951530b1b9eb03be4e3b309d36740f4.1390816620.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 27 Jan 2014 10:59:27 +0100, Andreas Rohner wrote:
> This patch introduces the nilfs_sufile_set_suinfo function, which
> expects an array of nilfs_suinfo_update structures and updates the
> segment usage information accordingly.
> 
> This is basically a helper function for the newly introduced
> NILFS_IOCTL_SET_SUINFO ioctl.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/sufile.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/sufile.h |   1 +
>  2 files changed, 130 insertions(+)
> 
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 3127e9f..8922523 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -870,6 +870,135 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
>  }
>  
>  /**
> + * nilfs_sufile_set_suinfo - sets segment usage info
> + * @sufile: inode of segment usage file
> + * @buf: array of suinfo_update
> + * @supsz: byte size of suinfo_update
> + * @nsup: size of suinfo_update array
> + *
> + * Description: Takes an array of nilfs_suinfo_update structs and updates
> + * segment usage accordingly. Only the fields indicated by the sup_flags
> + * are updated.
> + *
> + * Return Value: On success, 0 is returned. On error, one of the
> + * following negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
> + */
> +ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
> +				unsigned supsz, size_t nsup)
> +{
> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
> +	struct buffer_head *header_bh, *bh;
> +	struct nilfs_suinfo_update *sup, *supend = buf + supsz * nsup;
> +	struct nilfs_segment_usage *su;
> +	void *kaddr;
> +	unsigned long blkoff, prev_blkoff;
> +	int ret = 0, ncleansegs, ndirtysegs, cleansi,
> +			cleansu, dirtysi, dirtysu;

This indentation looks peculiar. Why not separate them into two or
more lines?  At least, ncleansegs and ndirtysegs differ from cleansi,
cleansu, dirtysi, dirtysu and ret.  ncleansegs and ndirtysegs sounds
confusing since these local variables do not give a total number.
ncleaned and ndirtied would be better.

	int cleansi, cleansu, dirtysi, dirtysu;
	int ncleaned, ndirtied;
	int ret = 0;

> +
> +	if (unlikely(nsup == 0))
> +		return ret;
> +
> +	for (sup = buf; sup < supend; sup = (void *)sup + supsz) {
> +		if (sup->sup_segnum >= nilfs->ns_nsegments
> +			|| (sup->sup_flags &
> +				(~0UL << (NILFS_SUINFO_UPDATE_FLAGS + 1)))

This looks confusing. It should be clarified as follows:

enum {
        NILFS_SUINFO_UPDATE_LASTMOD,
        NILFS_SUINFO_UPDATE_NBLOCKS,
        NILFS_SUINFO_UPDATE_FLAGS,
	__NR_NILFS_SUINFO_FIELDS
};

		if (sup->sup_segnum >= nilfs->ns_nsegments ||
		    (sup->sup_flags & (~0UL << __NR_NILFS_SUINFO_FIELDS)) ||

> +			|| (nilfs_suinfo_update_nblocks(sup) &&
> +				sup->sup_sui.sui_nblocks >
> +				nilfs->ns_blocks_per_segment)
> +			|| (nilfs_suinfo_update_flags(sup) &&
> +				(sup->sup_sui.sui_flags &
> +				(~0UL << (NILFS_SEGMENT_USAGE_ERROR + 1)))))

Ditto. We need to add a definition to nilfs2_fs.h.

enum {
        NILFS_SEGMENT_USAGE_ACTIVE,
        NILFS_SEGMENT_USAGE_DIRTY,
        NILFS_SEGMENT_USAGE_ERROR,
	__NR_NILFS_SEGMENT_USAGE_FLAGS
};

		    (nilfs_suinfo_update_flags(sup) &&
		     (sup->sup_sui.sui_flags &
		      (~0UL << __NR_NILFS_SEGMENT_USAGE_FLAGS))))

By the way, this will dismiss the capability that userland cleaner
programs uses the rest of su_flags for their own purpose such as GC
optimization.  I think this (rejecting or utilizing it) should be
carefully determined.

Any comments on this?

> +	}
> +
> +	down_write(&NILFS_MDT(sufile)->mi_sem);
> +
> +	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
> +	if (ret < 0)
> +		goto out_sem;
> +
> +	sup = buf;
> +	blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
> +	ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
> +	if (ret < 0)
> +		goto out_header;
> +
> +	for (;;) {
> +		kaddr = kmap_atomic(bh->b_page);
> +		su = nilfs_sufile_block_get_segment_usage(
> +			sufile, sup->sup_segnum, bh, kaddr);
> +
> +		if (nilfs_suinfo_update_lastmod(sup))
> +			su->su_lastmod = cpu_to_le64(sup->sup_sui.sui_lastmod);
> +
> +		if (nilfs_suinfo_update_nblocks(sup))
> +			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
> +
> +		if (nilfs_suinfo_update_flags(sup)) {
> +			sup->sup_sui.sui_flags &=
> +					~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);

Your would be better off adding a comment to explain what's this.

  			/*
			 * Active flag is a virtual flag projected by running
			 * nilfs kernel code - drop it not to write it to
			 * disk.
			 */
> +
> +			ncleansegs = 0;
> +			ndirtysegs = 0;
> +			cleansi = nilfs_suinfo_clean(&sup->sup_sui);
> +			cleansu = nilfs_segment_usage_clean(su);
> +			dirtysi = nilfs_suinfo_dirty(&sup->sup_sui);
> +			dirtysu = nilfs_segment_usage_dirty(su);
> +
> +			if (cleansi && !cleansu)
> +				++ncleansegs;
> +			else if (!cleansi && cleansu)
> +				--ncleansegs;
> +
> +			if (dirtysi && !dirtysu)
> +				++ndirtysegs;
> +			else if (!dirtysi && dirtysu)
> +				--ndirtysegs;
> +
> +			su->su_flags = cpu_to_le32(sup->sup_sui.sui_flags);
> +
> +			nilfs_sufile_mod_counter(header_bh, ncleansegs,
> +					ndirtysegs);

Does it work for a negative value without cast of (u64) ?
Please confirm that these counters are updated as you expected.

> +			NILFS_SUI(sufile)->ncleansegs += ncleansegs;

Ditto.  


Regards,
Ryusuke Konishi

> +		}
> +
> +		kunmap_atomic(kaddr);
> +
> +		sup = (void *)sup + supsz;
> +		if (sup >= supend)
> +			break;
> +
> +		prev_blkoff = blkoff;
> +		blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
> +		if (blkoff == prev_blkoff)
> +			continue;
> +
> +		/* get different block */
> +		mark_buffer_dirty(bh);
> +		brelse(bh);
> +		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
> +		if (unlikely(ret < 0))
> +			goto out_mark;
> +	}
> +	mark_buffer_dirty(bh);
> +	brelse(bh);
> +
> + out_mark:
> +	nilfs_mdt_mark_dirty(sufile);
> + out_header:
> +	brelse(header_bh);
> + out_sem:
> +	up_write(&NILFS_MDT(sufile)->mi_sem);
> +	return ret;
> +}
> +
> +/**
>   * nilfs_sufile_read - read or get sufile inode
>   * @sb: super block instance
>   * @susize: size of a segment usage entry
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index e84bc5b..366003c 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -44,6 +44,7 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
>  int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
>  ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
>  				size_t);
> +ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned , size_t);
>  
>  int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
>  			 void (*dofunc)(struct inode *, __u64,
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
