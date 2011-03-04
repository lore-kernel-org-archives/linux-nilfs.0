From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: record used amount of each checkpoint in
 checkpoint list
Date: Fri, 04 Mar 2011 19:38:57 +0900 (JST)
Message-ID: <20110304.193857.78339919.ryusuke@osrg.net>
References: <1298740431-13749-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<87hbbjpbdp.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87hbbjpbdp.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 04 Mar 2011 16:56:18 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> At Sun, 27 Feb 2011 02:13:51 +0900,
> Ryusuke Konishi wrote:
> > 
> > This records the number of used blocks per checkpoint in each
> > checkpoint entry of cpfile.  Even though userland tools can get the
> > block count via nilfs_get_cpinfo ioctl, it was not updated by the
> > nilfs2 kernel code.  This fixes the issue and makes it available for
> > userland tools to calculate used amount per checkpoint.
> 
> This and preceding nilfs-utils patch works only for the new nilfs2 module
> that has ability (which is the patch introduced) to count up the used blocks.
> 
> If you mount the same nilfs2 volume, some time by old module, the other time
> by new modlue, the count up block value will be incorrect.  If user is
> able to know it's incorrect when lscp, user may be able to fix the count
> by tools.  However, user only know if the value is correct or not by
> mounting the volume by new module only, and keep the situation under
> hid/her hand.
> 
> Therefore, it would be great to introduce feature bit to protect
> the count up value from old module.  That bit shows that old module can
> only mount read-only.  Those who does care the correctness set the bit.
> Those who doesn't care unset the bit.

Agreed.

I will consider introducing the new feature bit and revise that patch
later.

Thanks,
Ryusuke Konishi

> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> > ---
> >  fs/nilfs2/bmap.c          |   11 -----------
> >  fs/nilfs2/bmap.h          |    3 ---
> >  fs/nilfs2/btree.c         |    6 +++---
> >  fs/nilfs2/direct.c        |    4 ++--
> >  fs/nilfs2/inode.c         |   18 ++++++++++++++++++
> >  fs/nilfs2/nilfs.h         |    2 ++
> >  include/linux/nilfs2_fs.h |    2 +-
> >  7 files changed, 26 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> > index 3ee67c6..85447a2 100644
> > --- a/fs/nilfs2/bmap.c
> > +++ b/fs/nilfs2/bmap.c
> > @@ -425,17 +425,6 @@ int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
> >  /*
> >   * Internal use only
> >   */
> > -
> > -void nilfs_bmap_add_blocks(const struct nilfs_bmap *bmap, int n)
> > -{
> > -	inode_add_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
> > -}
> > -
> > -void nilfs_bmap_sub_blocks(const struct nilfs_bmap *bmap, int n)
> > -{
> > -	inode_sub_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
> > -}
> > -
> >  __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
> >  			      const struct buffer_head *bh)
> >  {
> > diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
> > index bde1c0a..40d9f45 100644
> > --- a/fs/nilfs2/bmap.h
> > +++ b/fs/nilfs2/bmap.h
> > @@ -240,9 +240,6 @@ __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *,
> >  __u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *, __u64);
> >  __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *);
> >  
> > -void nilfs_bmap_add_blocks(const struct nilfs_bmap *, int);
> > -void nilfs_bmap_sub_blocks(const struct nilfs_bmap *, int);
> > -
> >  
> >  /* Assume that bmap semaphore is locked. */
> >  static inline int nilfs_bmap_dirty(const struct nilfs_bmap *bmap)
> > diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> > index 300c2bc..d451ae0 100644
> > --- a/fs/nilfs2/btree.c
> > +++ b/fs/nilfs2/btree.c
> > @@ -1174,7 +1174,7 @@ static int nilfs_btree_insert(struct nilfs_bmap *btree, __u64 key, __u64 ptr)
> >  	if (ret < 0)
> >  		goto out;
> >  	nilfs_btree_commit_insert(btree, path, level, key, ptr);
> > -	nilfs_bmap_add_blocks(btree, stats.bs_nblocks);
> > +	nilfs_inode_add_blocks(btree->b_inode, stats.bs_nblocks);
> >  
> >   out:
> >  	nilfs_btree_free_path(path);
> > @@ -1511,7 +1511,7 @@ static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
> >  	if (ret < 0)
> >  		goto out;
> >  	nilfs_btree_commit_delete(btree, path, level, dat);
> > -	nilfs_bmap_sub_blocks(btree, stats.bs_nblocks);
> > +	nilfs_inode_sub_blocks(btree->b_inode, stats.bs_nblocks);
> >  
> >  out:
> >  	nilfs_btree_free_path(path);
> > @@ -1776,7 +1776,7 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
> >  		return ret;
> >  	nilfs_btree_commit_convert_and_insert(btree, key, ptr, keys, ptrs, n,
> >  					      di, ni, bh);
> > -	nilfs_bmap_add_blocks(btree, stats.bs_nblocks);
> > +	nilfs_inode_add_blocks(btree->b_inode, stats.bs_nblocks);
> >  	return 0;
> >  }
> >  
> > diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> > index 324d80c..82f4865 100644
> > --- a/fs/nilfs2/direct.c
> > +++ b/fs/nilfs2/direct.c
> > @@ -146,7 +146,7 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
> >  		if (NILFS_BMAP_USE_VBN(bmap))
> >  			nilfs_bmap_set_target_v(bmap, key, req.bpr_ptr);
> >  
> > -		nilfs_bmap_add_blocks(bmap, 1);
> > +		nilfs_inode_add_blocks(bmap->b_inode, 1);
> >  	}
> >  	return ret;
> >  }
> > @@ -168,7 +168,7 @@ static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
> >  	if (!ret) {
> >  		nilfs_bmap_commit_end_ptr(bmap, &req, dat);
> >  		nilfs_direct_set_ptr(bmap, key, NILFS_BMAP_INVALID_PTR);
> > -		nilfs_bmap_sub_blocks(bmap, 1);
> > +		nilfs_inode_sub_blocks(bmap->b_inode, 1);
> >  	}
> >  	return ret;
> >  }
> > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > index 2534af8..22a816b 100644
> > --- a/fs/nilfs2/inode.c
> > +++ b/fs/nilfs2/inode.c
> > @@ -41,6 +41,24 @@ struct nilfs_iget_args {
> >  	int for_gc;
> >  };
> >  
> > +void nilfs_inode_add_blocks(struct inode *inode, int n)
> > +{
> > +	struct nilfs_root *root = NILFS_I(inode)->i_root;
> > +
> > +	inode_add_bytes(inode, (1 << inode->i_blkbits) * n);
> > +	if (root)
> > +		atomic_add(n, &root->blocks_count);
> > +}
> > +
> > +void nilfs_inode_sub_blocks(struct inode *inode, int n)
> > +{
> > +	struct nilfs_root *root = NILFS_I(inode)->i_root;
> > +
> > +	inode_sub_bytes(inode, (1 << inode->i_blkbits) * n);
> > +	if (root)
> > +		atomic_sub(n, &root->blocks_count);
> > +}
> > +
> >  /**
> >   * nilfs_get_block() - get a file block on the filesystem (callback function)
> >   * @inode - inode struct of the target file
> > diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> > index 45b1fd1..03ba4d8 100644
> > --- a/fs/nilfs2/nilfs.h
> > +++ b/fs/nilfs2/nilfs.h
> > @@ -251,6 +251,8 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, struct nilfs_argv *,
> >  				       void **);
> >  
> >  /* inode.c */
> > +void nilfs_inode_add_blocks(struct inode *inode, int n);
> > +void nilfs_inode_sub_blocks(struct inode *inode, int n);
> >  extern struct inode *nilfs_new_inode(struct inode *, int);
> >  extern void nilfs_free_inode(struct inode *);
> >  extern int nilfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
> > diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> > index 3a65e5a..cc5bbe9 100644
> > --- a/include/linux/nilfs2_fs.h
> > +++ b/include/linux/nilfs2_fs.h
> > @@ -509,7 +509,7 @@ struct nilfs_checkpoint {
> >  	__le64 cp_create;
> >  	__le64 cp_nblk_inc;
> >  	__le64 cp_inodes_count;
> > -	__le64 cp_blocks_count;		/* Reserved (might be deleted) */
> > +	__le64 cp_blocks_count;
> >  
> >  	/* Do not change the byte offset of ifile inode.
> >  	   To keep the compatibility of the disk format,
> > -- 
> > 1.7.3.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > 
> 
> 
> -- 
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
