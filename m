From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v4] nilfs2: implement calculation of free inodes count
Date: Thu, 23 May 2013 00:04:58 +0900 (JST)
Message-ID: <20130523.000458.172540032.konishi.ryusuke@lab.ntt.co.jp>
References: <1369203827.2245.19.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369203827.2245.19.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, 22 May 2013 10:23:47 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> This is fourth version of the patch. I reworked representation of
> mi_desc_blocks_count because I think that using this field is good
> solution for calculation of max entries count.

Nack.

Please stop switching atomic_t and atomic64_t in nilfs with heavy use
of ifdef macros and inline functions.  It is seriously hurting the
readability and simplicity of source code.

Consider using "atomic_long_t", and please try to keep the patch
simple.

In my opinion, mi_desc_blocks_count is no longer needed because
nilfs_bmap_last_key is not so heavy.  But, I don't deny adding this
counter.
 

> By the way, I see that it is used atomic_t type for representation
> of inodes_count and blocks_count fields in nilfs_root structure.
> Maybe it makes sense to rework representation of these fields too.
> What do you think?

Yes, looks like they should be replaced with atomic_long_t type
counters (with a separate patch, of course).


Regards,
Ryusuke Konishi


> v3->v4
>  * The desc_blocks value is represented by unsigned long type.
>  * The nilfs_palloc_count_desc_blocks() method is simplified.
>  * The mi_desc_blocks_count field of nilfs_mdt_info structure
>    is represented as atomic64_t for the case of CONFIG_64BIT and
>    as atomic_t for other cases.
> 
> v2->v3
>  * Trivial BUG_ON checks were removed.
>  * Whole calculation algorithm was moved into
>    nilfs_palloc_count_max_entries() method.
>  * Improve error processing in the code.
>  * The nilfs_palloc_mdt_file_can_grow() method was simplified.
>  * The nilfs_ifile_count_free_inodes() method was simplified.
> 
> v1->v2
>  * Change __statfs_word on u64 type.
>  * Rename nilfs_count_free_inodes() into nilfs_ifile_count_free_inodes()
>    method.
>  * Introduce auxiliary functions: nilfs_palloc_count_max_entries(),
>    nilfs_palloc_count_desc_blocks(), nilfs_palloc_mdt_file_can_grow().
>  * Rework processing of returned error from nilfs_ifile_count_free_inodes()
>    in nilfs_statfs().
> 
> With the best regards,
> Vyacheslav Dubeyko.
> ---
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH v4] nilfs2: implement calculation of free inodes count
> 
> Currently, NILFS2 returns 0 as free inodes count (f_ffree) and
> current used inodes count as total file nodes in file system
> (f_files):
> 
> df -i
> Filesystem      Inodes  IUsed   IFree IUse% Mounted on
> /dev/loop0           2      2       0  100% /mnt/nilfs2
> 
> This patch implements real calculation of free inodes count.
> First of all, it is calculated total file nodes in file system
> as (desc_blocks_count * groups_per_desc_block * entries_per_group).
> Then, it is calculated free inodes count as difference the total
> file nodes and used inodes count. As a result, we have such output
> for NILFS2:
> 
> df -i
> Filesystem       Inodes   IUsed    IFree IUse% Mounted on
> /dev/loop0      4194304 2114701  2079603   51% /mnt/nilfs2
> 
> Reported-by: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/nilfs2/alloc.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/alloc.h |    2 ++
>  fs/nilfs2/ifile.c |   22 +++++++++++++++
>  fs/nilfs2/ifile.h |    2 +-
>  fs/nilfs2/mdt.h   |   26 ++++++++++++++++++
>  fs/nilfs2/super.c |   25 +++++++++++++++--
>  6 files changed, 152 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
> index eed4d7b..e5ea7b3 100644
> --- a/fs/nilfs2/alloc.c
> +++ b/fs/nilfs2/alloc.c
> @@ -80,6 +80,13 @@ int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
>  		mi->mi_blocks_per_group + 1;
>  		/* Number of blocks per descriptor including the
>  		   descriptor block */
> +	nilfs_mdt_set_desc_blocks(mi, 1);
> +		/*
> +		 * The field mi_desc_blocks_count is used for
> +		 * storing knowledge about current count of
> +		 * desciptor blocks. Initially, it is initialized
> +		 * by one.
> +		 */
>  	return 0;
>  }
>  
> @@ -398,6 +405,77 @@ nilfs_palloc_rest_groups_in_desc_block(const struct inode *inode,
>  }
>  
>  /**
> + * nilfs_palloc_count_desc_blocks - count descriptor blocks number
> + * @inode: inode of metadata file using this allocator
> + * @desc_blocks: descriptor blocks number [out]
> + */
> +static int nilfs_palloc_count_desc_blocks(struct inode *inode,
> +					  unsigned long *desc_blocks)
> +{
> +	unsigned long blknum;
> +	int ret;
> +
> +	ret = nilfs_bmap_last_key(NILFS_I(inode)->i_bmap, &blknum);
> +	if (likely(!ret))
> +		*desc_blocks = DIV_ROUND_UP(
> +			blknum, NILFS_MDT(inode)->mi_blocks_per_desc_block);
> +	return ret;
> +}
> +
> +/**
> + * nilfs_palloc_mdt_file_can_grow - check potential opportunity for
> + *					MDT file growing
> + * @inode: inode of metadata file using this allocator
> + * @desc_blocks: known current descriptor blocks count
> + */
> +static inline bool nilfs_palloc_mdt_file_can_grow(struct inode *inode,
> +						    unsigned long desc_blocks)
> +{
> +	return (nilfs_palloc_groups_per_desc_block(inode) * desc_blocks) <
> +			nilfs_palloc_groups_count(inode);
> +}
> +
> +/**
> + * nilfs_palloc_count_max_entries - count max number of entries that can be
> + *					described by descriptor blocks count
> + * @inode: inode of metadata file using this allocator
> + * @nused: current number of used entries
> + * @nmaxp: max number of entries [out]
> + */
> +int nilfs_palloc_count_max_entries(struct inode *inode, u64 nused, u64 *nmaxp)
> +{
> +	unsigned long desc_blocks;
> +	u64 entries_per_desc_block, nmax;
> +	int err;
> +
> +	desc_blocks = nilfs_mdt_read_desc_blocks(NILFS_MDT(inode));
> +	entries_per_desc_block = (u64)nilfs_palloc_entries_per_group(inode) *
> +				nilfs_palloc_groups_per_desc_block(inode);
> +
> +	nmax = entries_per_desc_block * desc_blocks;
<snip>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
