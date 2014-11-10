From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: avoid duplicate segment construction for
 fsync()
Date: Tue, 11 Nov 2014 08:43:30 +0900 (JST)
Message-ID: <20141111.084330.1647452726894509124.konishi.ryusuke@lab.ntt.co.jp>
References: <1415548812-1018-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=DOEOKeJN7SRdzSc8FcfChOK8Pe9Wx/ALDgzdGiXHZqY=;
        b=fc2DNTPZggJA5eudsZUTmK97AbDm1zD82YrzkXL6sMnjeTk38L9duy6I8rLoAlUb63
         /uZ7fmBEjDs4asE1xpg9OEuU4MD3iljMTLZu9X6KY33V4taAONZXvn88mTxlg101Xh8G
         4QTZaJhVQQXizMGaoXlCiiq1evknO2aDUSDjm1t20YG/xemwZw1LNNOUyL+zGdYVUW4W
         nO/9cDt9HItGzZegcAATZcbZa7dM9m5ggphV3Ko3vD2NHli+dZwF0J9m4n9jks7f0OCc
         UI04ilItgdGB06I/xsyLZuIz+hUkywuFLRdLgUpZWsIOmItuwddI0ok4ySIhokA11z1W
         kz3A==
In-Reply-To: <1415548812-1018-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun,  9 Nov 2014 17:00:12 +0100, Andreas Rohner wrote:
> This patch removes filemap_write_and_wait_range() from
> nilfs_sync_file(), because it triggers a data segment construction by
> calling nilfs_writepages() with WB_SYNC_ALL. A data segment construction
> does not remove the inode from the i_dirty list and it does not clear
> the NILFS_I_DIRTY flag. Therefore nilfs_inode_dirty() still returns
> true, which leads to an unnecessary duplicate segment construction in
> nilfs_sync_file().
> 
> A call to filemap_write_and_wait_range() is not needed, because NILFS2
> does not rely on the generic writeback mechanisms. Instead it implements
> its own mechanism to collect all dirty pages and write them into
> segments. It is more efficient to initiate the segment construction
> directly in nilfs_sync_file() without the detour over
> filemap_write_and_wait_range().
> 
> Additionally the lock of i_mutex is not needed, because all code blocks
> that are protected by i_mutex are also protected by a NILFS transaction:
> 
> Function                i_mutex     nilfs_transaction
> ------------------------------------------------------
> nilfs_ioctl_setflags:   yes         yes
> nilfs_fiemap:           yes         no
> nilfs_write_begin:      yes         yes
> nilfs_write_end:        yes         yes
> nilfs_lookup:           yes         no
> nilfs_create:           yes         yes
> nilfs_link:             yes         yes
> nilfs_mknod:            yes         yes
> nilfs_symlink:          yes         yes
> nilfs_mkdir:            yes         yes
> nilfs_unlink:           yes         yes
> nilfs_rmdir:            yes         yes
> nilfs_rename:           yes         yes
> nilfs_setattr:          yes         yes
> 
> For nilfs_lookup() i_mutex is held for the parent directory, to protect
> it from modification. The segment construction does not modify directory
> inodes, so no lock is needed.
> 
> nilfs_fiemap() reads the block layout on the disk, by using
> nilfs_bmap_lookup_contig(). This is already protected by bmap->b_sem.

Thank you.

I reached the same conclusion that the i_mutex in nilfs_sync_file()
can be deleted.  The side effect of removing
filemap_write_and_wait_range() still looks to need some care.
Anyway, I queued this patch in my nilfs.git tree.

Regards,
Ryusuke Konishi


> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/file.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index e9e3325..1ad6bdf 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -41,19 +41,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	struct inode *inode = file->f_mapping->host;
>  	int err;
>  
> -	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
> -	if (err)
> -		return err;
> -	mutex_lock(&inode->i_mutex);
> -
> -	if (nilfs_inode_dirty(inode)) {
> -		if (datasync)
> -			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
> -							    0, LLONG_MAX);
> -		else
> -			err = nilfs_construct_segment(inode->i_sb);
> -	}
> -	mutex_unlock(&inode->i_mutex);
> +	if (!nilfs_inode_dirty(inode))
> +		return 0;
> +
> +	if (datasync)
> +		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
> +						    start, end);
> +	else
> +		err = nilfs_construct_segment(inode->i_sb);
>  
>  	nilfs = inode->i_sb->s_fs_info;
>  	if (!err)
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
