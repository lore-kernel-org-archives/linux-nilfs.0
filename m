From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/79] fs: add ctime accessors
 infrastructure
Date: Wed, 21 Jun 2023 18:34:06 +0200
Message-ID: <20230621163406.udwkxl6tteg6nlcn@quack3>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621144507.55591-2-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687365259;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=83XiFVWYz/09+oGN/3WNfR8rOmdHj8dhtkMP8AULWnA=;
	b=ffer2imyyy0aKFxKumz2/+snTgsw/9X41CHK//FhVjVKedJ0eK0FBJlSsVIR5V7ob6/iSE
	YvsiwCptj8ixKT884hZR7z5AMw/5DwdF8QfeawVgKcr/VLw9zwTXe7B+ALgJK5F1FvV0SR
	FobXaPLpE7lrvMGDFr+oMGv0cjm1UxA=
In-Reply-To: <20230621144507.55591-2-jlayton@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, "Rafael J. Wysocki" <rafael@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Anders Larsen <al@alarsen.net>, Carlos Llamas <cmllamas@google.com>, Andrii Nakryiko <andrii@kernel.org>, Hugh Dickins <hughd@google.com>, John Johansen <john.johansen@canonical.com>, Seth Forshee <sforshee@digitalocean.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Mike Marshall <hubcap@omnibond.com>, Paulo Alcantara <pc@manguebit.com>, linux-xfs@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Michael Ellerman <mpe@ellerman.id.au>, John Keeping <john@keeping.me.uk>, Zhang Yi <yi.zhang@huawei.com>, James Morris <jmorris@namei.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, Tyler Hicks <code@tyhicks.com>, Alan Stern <stern@rowland.harvard.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, devel@lists.ora

On Wed 21-06-23 10:45:06, Jeff Layton wrote:
> struct timespec64 has unused bits in the tv_nsec field that can be used
> for other purposes. In future patches, we're going to change how the
> inode->i_ctime is accessed in certain inodes in order to make use of
> them. In order to do that safely though, we'll need to eradicate raw
> accesses of the inode->i_ctime field from the kernel.
> 
> Add new accessor functions for the ctime that we can use to replace them.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c         | 16 ++++++++++++++
>  include/linux/fs.h | 53 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 68 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index d37fad91c8da..c005e7328fbb 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2499,6 +2499,22 @@ struct timespec64 current_time(struct inode *inode)
>  }
>  EXPORT_SYMBOL(current_time);
>  
> +/**
> + * inode_ctime_set_current - set the ctime to current_time
> + * @inode: inode
> + *
> + * Set the inode->i_ctime to the current value for the inode. Returns
> + * the current value that was assigned to i_ctime.
> + */
> +struct timespec64 inode_ctime_set_current(struct inode *inode)
> +{
> +	struct timespec64 now = current_time(inode);
> +
> +	inode_set_ctime(inode, now);
> +	return now;
> +}
> +EXPORT_SYMBOL(inode_ctime_set_current);
> +
>  /**
>   * in_group_or_capable - check whether caller is CAP_FSETID privileged
>   * @idmap:	idmap of the mount @inode was found from
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6867512907d6..9afb30606373 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1474,7 +1474,58 @@ static inline bool fsuidgid_has_mapping(struct super_block *sb,
>  	       kgid_has_mapping(fs_userns, kgid);
>  }
>  
> -extern struct timespec64 current_time(struct inode *inode);
> +struct timespec64 current_time(struct inode *inode);
> +struct timespec64 inode_ctime_set_current(struct inode *inode);
> +
> +/**
> + * inode_ctime_peek - fetch the current ctime from the inode
> + * @inode: inode from which to fetch ctime
> + *
> + * Grab the current ctime from the inode and return it.
> + */
> +static inline struct timespec64 inode_ctime_peek(const struct inode *inode)
> +{
> +	return inode->i_ctime;
> +}
> +
> +/**
> + * inode_ctime_set - set the ctime in the inode to the given value
> + * @inode: inode in which to set the ctime
> + * @ts: timespec value to set the ctime
> + *
> + * Set the ctime in @inode to @ts.
> + */
> +static inline struct timespec64 inode_ctime_set(struct inode *inode, struct timespec64 ts)
> +{
> +	inode->i_ctime = ts;
> +	return ts;
> +}
> +
> +/**
> + * inode_ctime_set_sec - set only the tv_sec field in the inode ctime
> + * @inode: inode in which to set the ctime
> + * @sec:  value to set the tv_sec field
> + *
> + * Set the sec field in the ctime. Returns @sec.
> + */
> +static inline time64_t inode_ctime_set_sec(struct inode *inode, time64_t sec)
> +{
> +	inode->i_ctime.tv_sec = sec;
> +	return sec;
> +}
> +
> +/**
> + * inode_ctime_set_nsec - set only the tv_nsec field in the inode ctime
> + * @inode: inode in which to set the ctime
> + * @nsec:  value to set the tv_nsec field
> + *
> + * Set the nsec field in the ctime. Returns @nsec.
> + */
> +static inline long inode_ctime_set_nsec(struct inode *inode, long nsec)
> +{
> +	inode->i_ctime.tv_nsec = nsec;
> +	return nsec;
> +}
>  
>  /*
>   * Snapshotting support.
> -- 
> 2.41.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

