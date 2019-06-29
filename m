From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] vfs: only allow FSSETXATTR to set
 DAX flag on files and dirs
Date: Sat, 29 Jun 2019 22:09:01 +0200
Message-ID: <20190629200901.GA18642@quack2.suse.cz>
References: <156174682897.1557318.14418894077683701275.stgit@magnolia>
	<156174687185.1557318.13703922197244050336.stgit@magnolia>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <156174687185.1557318.13703922197244050336.stgit@magnolia>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: " Darrick J. Wong " <darrick.wong@oracle.com>
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, yuchao0@huawei.com, clm@fb.com, adilger.kernel@dilger.ca, ocfs2-devel@oss.oracle.com, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, matthew.garrett@nebula.com, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, David Sterba <dsterba@suse.com>, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org

On Fri 28-06-19 11:34:31,  Darrick J. Wong  wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The DAX flag only applies to files and directories, so don't let it get
> set for other types of files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 670d5408d022..f08711b34341 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2259,6 +2259,14 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
>  	    !S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>  		return -EINVAL;
>  
> +	/*
> +	 * It is only valid to set the DAX flag on regular files and
> +	 * directories on filesystems.
> +	 */
> +	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
> +	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> +		return -EINVAL;
> +
>  	/* Extent size hints of zero turn off the flags. */
>  	if (fa->fsx_extsize == 0)
>  		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

