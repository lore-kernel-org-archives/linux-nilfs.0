From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/1] mkfs.nilfs2: initialize block info array for DAT
 file by nilfs_binfo_dat structure
Date: Mon, 07 May 2012 03:29:29 +0900 (JST)
Message-ID: <20120507.032929.212703538.konishi.ryusuke@lab.ntt.co.jp>
References: <9530D129-EDB3-48FA-BC77-29F75681F551@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9530D129-EDB3-48FA-BC77-29F75681F551-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 6 May 2012 16:06:41 +0400, Vyacheslav Dubeyko wrote:
> Hello,
> 
> I think that I have found obsolete code in mkfs.nilfs2. And I prepare a patch which fixes the bug with block info initialization in segment summary for the case of DAT file.
> 
> With the best regards,
> Vyacheslav Dubeyko.
> --
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH 1/1] mkfs.nilfs2: initialize block info array for DAT file by nilfs_binfo_dat structure
> 
> Segment summary block begins from segment summary header (nilfs_segment_summary structure). It follows array of file information items (nilfs_finfo structure) after it. And after each file information item follows array of block information items (nilfs_binfo union). The block information item can be nilfs_binfo_v structure (information for the block to which a virtual block number is assigned) or nilfs_binfo_dat structure (information for the block which belongs to the DAT file).
> 
> Current state of mkfs.nilfs2 code initializes block information items as sizeof(__le64) for the DAT file case. But driver code expects greater structure in size because it operates by bi_level field for the case of DAT file. The patch uses nilfs_binfo_dat structure instead of __le64 during creation of block information items for DAT file case.
> 
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

Thanks for the patch.  But, No, the current mkfs implementation is
correct.

nilfs_binfo_dat is the structure storing summary information only
applied to btree intermediate blocks of the DAT meta-data file.

For data blocks of the DAT file, a 64-bit block offset number (__le64)
is allocated per block.

Since mkfs.nilfs2 only allocates data blocks in the initial format and
never allocates btree node blocks, nilfs_binfo_dat structure will not
appear in the tool.

The current kernel module is using the same binfo format.  If this
patch is applied, compatibility of the disk format will be broken.


Regards,
Ryusuke Konishi

> ---
> diff -up nilfs-utils/sbin/mkfs/mkfs.c{.orig,} 
> --- nilfs-utils/sbin/mkfs/mkfs.c.orig	2012-05-04 12:30:58.308461058 +0400
> +++ nilfs-utils/sbin/mkfs/mkfs.c	2012-05-04 12:32:39.593861721 +0400
> @@ -444,7 +444,7 @@ static void increment_segsum_size(struct
>  				  unsigned nblocks_in_file, int dat_flag)
>  {
>  	unsigned binfo_size = dat_flag ? 
> -		sizeof(__le64) /* offset */ : sizeof(struct nilfs_binfo_v);
> +		sizeof(struct nilfs_binfo_dat) : sizeof(struct nilfs_binfo_v);
>  
>  	si->sumbytes = __increment_segsum_size(si->sumbytes,
>  					       sizeof(struct nilfs_finfo), 1);
> @@ -1240,13 +1240,13 @@ static void update_blocknr(struct nilfs_
>  	finfo->fi_cno = cpu_to_le64(1);
>  
>  	if (fi->ino == NILFS_DAT_INO) {
> -		__le64 *pblkoff;
> +		struct nilfs_binfo_dat *pbinfo_dat;
>  
>  		fi->raw_inode->i_bmap[0] = 0;
>  		for (i = 0; i < fi->nblocks; i++) {
> -			pblkoff = map_segsum_info(start, sum_offset,
> -						  sizeof(*pblkoff));
> -			*pblkoff = cpu_to_le64(i);
> +			pbinfo_dat = map_segsum_info(start, sum_offset,
> +						  sizeof(*pbinfo_dat));
> +			pbinfo_dat->bi_blkoff = cpu_to_le64(i);
>  			fi->raw_inode->i_bmap[i + 1] =
>  				cpu_to_le64(fi->start + i);
>  		}
> --
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
