From: Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/92] fs: new helper: simple_rename_timestamp
Date: Thu, 6 Jul 2023 08:19:00 +0900
Message-ID: <3b403ef1-22e6-0220-6c9c-435e3444b4d3__38656.3255147607$1688599216$gmane$org@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <20230705185812.579118-3-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688599164;
        bh=KCTloaubNslRR/SoL8UluRoG/IUPJVjSzADYJrfAJHU=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=b2X6YIL6Vy56XALQtKdhzhDP4FaYYu72cv/nQy9J7p20qPoaFddY4NYMECi8UiElG
         KXeBp5mYG0Tr3Z/9dS3G7DFV3U+NrS3kS1Bj4OLdG2oLV7lkerc27aKsKkqjab0O9K
         FATIdox5v3Da+YKWUBF3YXN3ElwAHoGXAASphNzizKagSfTJcPF38/AQplhEub1AKR
         LkLgfDZcW1uv2KNe1PZmf257zQ+kLCx4ktYMXGFo0Ya/ipY5JnCfPPINteVMs1bXpn
         61eVfSZI95423vo52gH8KvQcVqXg5RZ32hLmWLwnt3Gj7afC9O4NqxdEhtaz5kVF+Y
         8axRcbIlbfAZA==
Content-Language: en-US
In-Reply-To: <20230705185812.579118-3-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christophe.leroy-2tlSp11Fh4xulxpn9UvDqw@public.gmane.org, hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bwarrum-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, rituagar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, ericvh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, asmadeus-9aU+PIKW3UvdtAWm4Da02A@public.gmane.org, linux_oss-kKOvUW9iAPtl57MIdRCFDg@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marc.dionne-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org, luisbg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, salah.triki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aivazian.tigran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, e

On 7/6/23 03:58, Jeff Layton wrote:
> A rename potentially involves updating 4 different inode timestamps. Add
> a function that handles the details sanely, and convert the libfs.c
> callers to use it.
> 
> Signed-off-by: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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

This is somewhat changing the current behavior: before the patch, the mtime and
ctime of old_dir, new_dir and the inodes associated with the dentries are always
equal. But given that simple_rename_timestamp() calls inode_set_ctime_current()
4 times, the times could potentially be different.

I am not sure if that is an issue, but it seems that calling
inode_set_ctime_current() once, recording the "now" time it sets and using that
value to set all times may be more efficient and preserve the existing behavior.

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

-- 
Damien Le Moal
Western Digital Research

