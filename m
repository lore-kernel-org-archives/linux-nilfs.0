From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 59/92] nilfs2: convert to ctime accessor functions
Date: Thu, 6 Jul 2023 15:35:50 +0200
Message-ID: <20230706133550.fqb6zyhntkglbcmf@quack3>
References: <20230705185755.579053-1-jlayton@kernel.org>
 <20230705190309.579783-1-jlayton@kernel.org>
 <20230705190309.579783-57-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1688650551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ceqPWf0NI1hE49lDCpnOfgQpg2XL9BBah4pOqFXBF+M=;
        b=JqWfHr6bVxmmXe7kNkh9dORylPaxZDDASjAuPSV84s05jr4n9D/fjtv4Es92RE8VRLP0cS
        yURstx+4xfiCfPCIFzbn/OuQnbLDdS5jawngj7K8sQfkd8Ij07FGN75MTv4j3g3xx52beW
        OMptSKq+ZLZHZdf2Lv8lv0Wl13YqA/Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1688650551;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ceqPWf0NI1hE49lDCpnOfgQpg2XL9BBah4pOqFXBF+M=;
        b=0e2qd+macsMH2eFzFQtisE7NDdIL/ra31fyU3boRcogwVMVSkGuEFrsYDTe9mJyIHrUIw7
        71NZacXZ065cOKAw==
Content-Disposition: inline
In-Reply-To: <20230705190309.579783-57-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 05-07-23 15:01:24, Jeff Layton wrote:
> In later patches, we're going to change how the inode's ctime field is
> used. Switch to using accessor functions instead of raw accesses of
> inode->i_ctime.
> 
> Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/nilfs2/dir.c   |  6 +++---
>  fs/nilfs2/inode.c | 12 ++++++------
>  fs/nilfs2/ioctl.c |  2 +-
>  fs/nilfs2/namei.c |  8 ++++----
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index decd6471300b..bce734b68f08 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -429,7 +429,7 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
>  	nilfs_set_de_type(de, inode);
>  	nilfs_commit_chunk(page, mapping, from, to);
>  	nilfs_put_page(page);
> -	dir->i_mtime = dir->i_ctime = current_time(dir);
> +	dir->i_mtime = inode_set_ctime_current(dir);
>  }
>  
>  /*
> @@ -519,7 +519,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
>  	de->inode = cpu_to_le64(inode->i_ino);
>  	nilfs_set_de_type(de, inode);
>  	nilfs_commit_chunk(page, page->mapping, from, to);
> -	dir->i_mtime = dir->i_ctime = current_time(dir);
> +	dir->i_mtime = inode_set_ctime_current(dir);
>  	nilfs_mark_inode_dirty(dir);
>  	/* OFFSET_CACHE */
>  out_put:
> @@ -567,7 +567,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
>  		pde->rec_len = nilfs_rec_len_to_disk(to - from);
>  	dir->inode = 0;
>  	nilfs_commit_chunk(page, mapping, from, to);
> -	inode->i_ctime = inode->i_mtime = current_time(inode);
> +	inode->i_mtime = inode_set_ctime_current(inode);
>  out:
>  	nilfs_put_page(page);
>  	return err;
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index a8ce522ac747..5259b94ca1dc 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -366,7 +366,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
>  	atomic64_inc(&root->inodes_count);
>  	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
>  	inode->i_ino = ino;
> -	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
> +	inode->i_mtime = inode->i_atime = inode_set_ctime_current(inode);
>  
>  	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)) {
>  		err = nilfs_bmap_read(ii->i_bmap, NULL);
> @@ -450,10 +450,10 @@ int nilfs_read_inode_common(struct inode *inode,
>  	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>  	inode->i_size = le64_to_cpu(raw_inode->i_size);
>  	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
> -	inode->i_ctime.tv_sec = le64_to_cpu(raw_inode->i_ctime);
> +	inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
> +			le32_to_cpu(raw_inode->i_ctime_nsec));
>  	inode->i_mtime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
>  	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
> -	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
>  	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
>  	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
>  		return -EIO; /* this inode is for metadata and corrupted */
> @@ -768,9 +768,9 @@ void nilfs_write_inode_common(struct inode *inode,
>  	raw_inode->i_gid = cpu_to_le32(i_gid_read(inode));
>  	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
>  	raw_inode->i_size = cpu_to_le64(inode->i_size);
> -	raw_inode->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
> +	raw_inode->i_ctime = cpu_to_le64(inode_get_ctime(inode).tv_sec);
>  	raw_inode->i_mtime = cpu_to_le64(inode->i_mtime.tv_sec);
> -	raw_inode->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
> +	raw_inode->i_ctime_nsec = cpu_to_le32(inode_get_ctime(inode).tv_nsec);
>  	raw_inode->i_mtime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>  	raw_inode->i_blocks = cpu_to_le64(inode->i_blocks);
>  
> @@ -875,7 +875,7 @@ void nilfs_truncate(struct inode *inode)
>  
>  	nilfs_truncate_bmap(ii, blkoff);
>  
> -	inode->i_mtime = inode->i_ctime = current_time(inode);
> +	inode->i_mtime = inode_set_ctime_current(inode);
>  	if (IS_SYNC(inode))
>  		nilfs_set_transaction_flag(NILFS_TI_SYNC);
>  
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 1dfbc0c34513..40ffade49f38 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -149,7 +149,7 @@ int nilfs_fileattr_set(struct mnt_idmap *idmap,
>  	NILFS_I(inode)->i_flags = oldflags | (flags & FS_FL_USER_MODIFIABLE);
>  
>  	nilfs_set_inode_flags(inode);
> -	inode->i_ctime = current_time(inode);
> +	inode_set_ctime_current(inode);
>  	if (IS_SYNC(inode))
>  		nilfs_set_transaction_flag(NILFS_TI_SYNC);
>  
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index c7024da8f1e2..2a4e7f4a8102 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -185,7 +185,7 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
>  	if (err)
>  		return err;
>  
> -	inode->i_ctime = current_time(inode);
> +	inode_set_ctime_current(inode);
>  	inode_inc_link_count(inode);
>  	ihold(inode);
>  
> @@ -283,7 +283,7 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
>  	if (err)
>  		goto out;
>  
> -	inode->i_ctime = dir->i_ctime;
> +	inode_set_ctime_to_ts(inode, inode_get_ctime(dir));
>  	drop_nlink(inode);
>  	err = 0;
>  out:
> @@ -387,7 +387,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
>  			goto out_dir;
>  		nilfs_set_link(new_dir, new_de, new_page, old_inode);
>  		nilfs_mark_inode_dirty(new_dir);
> -		new_inode->i_ctime = current_time(new_inode);
> +		inode_set_ctime_current(new_inode);
>  		if (dir_de)
>  			drop_nlink(new_inode);
>  		drop_nlink(new_inode);
> @@ -406,7 +406,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
>  	 * Like most other Unix systems, set the ctime for inodes on a
>  	 * rename.
>  	 */
> -	old_inode->i_ctime = current_time(old_inode);
> +	inode_set_ctime_current(old_inode);
>  
>  	nilfs_delete_entry(old_de, old_page);
>  
> -- 
> 2.41.0
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
