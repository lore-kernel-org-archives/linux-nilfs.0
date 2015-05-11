From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/3] UDF: support NFSv2 export
Date: Mon, 11 May 2015 10:57:41 +0200
Message-ID: <20150511085741.GA9962@quack.suse.cz>
References: <20150508001142.31129.7604.stgit@notabene.brown>
 <20150508001623.31129.24710.stgit@notabene.brown>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150508001623.31129.24710.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 08-05-15 10:16:23, NeilBrown wrote:
> The "fh_len" passed to ->fh_to_* is not guaranteed to be that same as
> that returned by encode_fh - it may be larger.
> 
> With NFSv2, the filehandle is fixed length, so it may appear longer
> than expected and be zero-padded.
> 
> So we must test that fh_len is at least some value, not exactly equal
> to it.
> 
> Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
  Thanks. The patch looks good to me. I've added it to my tree.

								Honza
> ---
>  fs/udf/namei.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 5c03f0dfb98b..facc2a840f7b 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -1221,7 +1221,7 @@ static struct dentry *udf_nfs_get_inode(struct super_block *sb, u32 block,
>  static struct dentry *udf_fh_to_dentry(struct super_block *sb,
>  				       struct fid *fid, int fh_len, int fh_type)
>  {
> -	if ((fh_len != 3 && fh_len != 5) ||
> +	if (fh_len < 3 ||
>  	    (fh_type != FILEID_UDF_WITH_PARENT &&
>  	     fh_type != FILEID_UDF_WITHOUT_PARENT))
>  		return NULL;
> @@ -1233,7 +1233,7 @@ static struct dentry *udf_fh_to_dentry(struct super_block *sb,
>  static struct dentry *udf_fh_to_parent(struct super_block *sb,
>  				       struct fid *fid, int fh_len, int fh_type)
>  {
> -	if (fh_len != 5 || fh_type != FILEID_UDF_WITH_PARENT)
> +	if (fh_len < 5 || fh_type != FILEID_UDF_WITH_PARENT)
>  		return NULL;
>  
>  	return udf_nfs_get_inode(sb, fid->udf.parent_block,
> 
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
