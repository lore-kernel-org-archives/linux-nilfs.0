From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 92/92] fs: rename i_ctime field to __i_ctime
Date: Thu, 6 Jul 2023 16:58:31 +0200
Message-ID: <20230706145831.iwmb7c3jerbkctda@quack3>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <20230705185812.579118-4-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1688655512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3WCjuVtP408kA5MLjuqcXtfVFT/xUBAoafKmCX5mTQ=;
        b=24baoWftvYiGQFO3002Q0+aX8kw5mHmt4Cu1N910tREAGtuxcOaRXmP0pM+lOVAJim6+VD
        dQX99wfdHC9+7VMIIenAeKOTV3XT6+7YZiyj/RCSzIS+4DKmzNEvO8ziEQ7uku2gaTxrzh
        E0opuusKVm/bz4GqT0HBn9z2vEqLBRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1688655512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3WCjuVtP408kA5MLjuqcXtfVFT/xUBAoafKmCX5mTQ=;
        b=N/aHHWlEsq3Q8ok8VkNIK3F/VOqPWCTaj4AqfwvPqV9l0evDoZQtQa232xNNYABuuek3bk
        kdzAUhIiYKjnxQAA==
Content-Disposition: inline
In-Reply-To: <20230705185812.579118-4-jlayton@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: jk@ozlabs.org, arnd@arndb.de, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com, maco@android.com, joel@joelfernandes.org, brauner@kernel.org, cmllamas@google.com, surenb@google.com, dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org, bwarrum@linux.ibm.com, rituagar@linux.ibm.com, ericvh@kernel.org, lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com, dsterba@suse.com, dhowells@redhat.com, marc.dionne@auristor.com, viro@zeniv.linux.org.uk, raven@themaw.net, luisbg@kernel.org, salah.triki@gmail.com, aivazian.tigran@gmail.com, ebiederm@xmission.com, kees

On Wed 05-07-23 14:58:12, Jeff Layton wrote:
> Now that everything in-tree is converted to use the accessor functions,
> rename the i_ctime field in the inode to discourage direct access.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 14e38bd900f1..b66442f91835 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -642,7 +642,7 @@ struct inode {
>  	loff_t			i_size;
>  	struct timespec64	i_atime;
>  	struct timespec64	i_mtime;
> -	struct timespec64	i_ctime;
> +	struct timespec64	__i_ctime; /* use inode_*_ctime accessors! */
>  	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
>  	unsigned short          i_bytes;
>  	u8			i_blkbits;
> @@ -1485,7 +1485,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode);
>   */
>  static inline struct timespec64 inode_get_ctime(const struct inode *inode)
>  {
> -	return inode->i_ctime;
> +	return inode->__i_ctime;
>  }
>  
>  /**
> @@ -1498,7 +1498,7 @@ static inline struct timespec64 inode_get_ctime(const struct inode *inode)
>  static inline struct timespec64 inode_set_ctime_to_ts(struct inode *inode,
>  						      struct timespec64 ts)
>  {
> -	inode->i_ctime = ts;
> +	inode->__i_ctime = ts;
>  	return ts;
>  }
>  
> -- 
> 2.41.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
