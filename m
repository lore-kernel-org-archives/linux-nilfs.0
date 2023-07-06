From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 08/92] fs: new helper: simple_rename_timestamp
Date: Thu, 6 Jul 2023 12:27:06 +0200
Message-ID: <20230706102706.w7udmbmuwp7hhcry@quack3>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <20230705185812.579118-3-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1688639226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bA8lspzVCI0QkBBZSOZ2NaXyU+WIcRfNoOGE3kPhpJ0=;
        b=cwJXVYMxjabgJAc1WiPXwEoX0OTfi47rAf4OBX1TAQ+OGmO9dcjviKfq9JaMZbP2e77Zft
        ZFGj4L7K2Mk/xcezt5kjd+qP2pHojrW25RMENmZ0z2yxrjNTco/s31l/aUs5F51DaCvlcK
        y6kdxWpKryRTZKsAyjQoNnmkqAh2mzg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1688639226;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bA8lspzVCI0QkBBZSOZ2NaXyU+WIcRfNoOGE3kPhpJ0=;
        b=NZCT2CDl1JUNY6ijIJLjHssrtsmLEPFUK3ppAhWe46d1TfukNG5xi7VbWtXEv0lhKCq/xt
        xNVG4YexDp28AbCA==
Content-Disposition: inline
In-Reply-To: <20230705185812.579118-3-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christophe.leroy-2tlSp11Fh4xulxpn9UvDqw@public.gmane.org, hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bwarrum-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, rituagar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, ericvh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, asmadeus-9aU+PIKW3UvdtAWm4Da02A@public.gmane.org, linux_oss-kKOvUW9iAPtl57MIdRCFDg@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marc.dionne-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org, luisbg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, salah.triki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aivazian.tigran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, kees

On Wed 05-07-23 14:58:11, Jeff Layton wrote:
> A rename potentially involves updating 4 different inode timestamps. Add
> a function that handles the details sanely, and convert the libfs.c
> callers to use it.
> 
> Signed-off-by: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/libfs.c         | 36 +++++++++++++++++++++++++++---------
>  include/linux/fs.h |  2 ++
>  2 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index a7e56baf8bbd..9ee79668c909 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -692,6 +692,31 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
>  }
>  EXPORT_SYMBOL(simple_rmdir);
>  
> +/**
> + * simple_rename_timestamp - update the various inode timestamps for rename
> + * @old_dir: old parent directory
> + * @old_dentry: dentry that is being renamed
> + * @new_dir: new parent directory
> + * @new_dentry: target for rename
> + *
> + * POSIX mandates that the old and new parent directories have their ctime and
> + * mtime updated, and that inodes of @old_dentry and @new_dentry (if any), have
> + * their ctime updated.
> + */
> +void simple_rename_timestamp(struct inode *old_dir, struct dentry *old_dentry,
> +			     struct inode *new_dir, struct dentry *new_dentry)
> +{
> +	struct inode *newino = d_inode(new_dentry);
> +
> +	old_dir->i_mtime = inode_set_ctime_current(old_dir);
> +	if (new_dir != old_dir)
> +		new_dir->i_mtime = inode_set_ctime_current(new_dir);
> +	inode_set_ctime_current(d_inode(old_dentry));
> +	if (newino)
> +		inode_set_ctime_current(newino);
> +}
> +EXPORT_SYMBOL_GPL(simple_rename_timestamp);
> +
>  int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
>  			   struct inode *new_dir, struct dentry *new_dentry)
>  {
> @@ -707,11 +732,7 @@ int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
>  			inc_nlink(old_dir);
>  		}
>  	}
> -	old_dir->i_ctime = old_dir->i_mtime =
> -	new_dir->i_ctime = new_dir->i_mtime =
> -	d_inode(old_dentry)->i_ctime =
> -	d_inode(new_dentry)->i_ctime = current_time(old_dir);
> -
> +	simple_rename_timestamp(old_dir, old_dentry, new_dir, new_dentry);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(simple_rename_exchange);
> @@ -720,7 +741,6 @@ int simple_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  		  struct dentry *old_dentry, struct inode *new_dir,
>  		  struct dentry *new_dentry, unsigned int flags)
>  {
> -	struct inode *inode = d_inode(old_dentry);
>  	int they_are_dirs = d_is_dir(old_dentry);
>  
>  	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
> @@ -743,9 +763,7 @@ int simple_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  		inc_nlink(new_dir);
>  	}
>  
> -	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
> -		new_dir->i_mtime = inode->i_ctime = current_time(old_dir);
> -
> +	simple_rename_timestamp(old_dir, old_dentry, new_dir, new_dentry);
>  	return 0;
>  }
>  EXPORT_SYMBOL(simple_rename);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bdfbd11a5811..14e38bd900f1 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2979,6 +2979,8 @@ extern int simple_open(struct inode *inode, struct file *file);
>  extern int simple_link(struct dentry *, struct inode *, struct dentry *);
>  extern int simple_unlink(struct inode *, struct dentry *);
>  extern int simple_rmdir(struct inode *, struct dentry *);
> +void simple_rename_timestamp(struct inode *old_dir, struct dentry *old_dentry,
> +			     struct inode *new_dir, struct dentry *new_dentry);
>  extern int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
>  				  struct inode *new_dir, struct dentry *new_dentry);
>  extern int simple_rename(struct mnt_idmap *, struct inode *,
> -- 
> 2.41.0
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
