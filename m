From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 2/3] NILFS2: support NFSv2 export
Date: Mon, 11 May 2015 01:31:43 +0900 (JST)
Message-ID: <20150511.013143.706881749197692581.konishi.ryusuke@lab.ntt.co.jp>
References: <20150508001142.31129.7604.stgit@notabene.brown>
	<20150508001623.31129.25102.stgit@notabene.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=/q4pXWtmOwWcuO/cZ6BxwVNutgUGPPzdNtmJjYC71Ew=;
        b=UKzjkqx5ZU/UdOLkUxA2dr7SIAanhJJvaMqoCEhapFBlIHRGFUGaVZXBIXEkxbU2aR
         HKgIP0rw6OWKa6OuUCmPLvAEbk9lpWIw8GkU3J6K+vdcg9gUJJWgz9xtV7MtOHB8YCrF
         3tQJs+oRDjndfW05S+lmX7NNoAAkg0rnD+bQq2Ro0W+xV3NufvtCnwIVHFA07uhvkMim
         6MpjT2hSjsEC5TjIEWrlqT7bFBo/OiW2CBl0K379+HZWAdtPyfCsnfXoiNM5KUARjlsM
         pkiGJpqH/asNgU242KrYfCIUbGCn8jdW62WBoOUc14ejSG5Wrh6snpSKBQLe3DKUjtdX
         o0iw==
In-Reply-To: <20150508001623.31129.25102.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 08 May 2015 10:16:23 +1000, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
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
> ---
>  fs/nilfs2/namei.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index 22180836ec22..b65fb79d16fd 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -496,8 +496,8 @@ static struct dentry *nilfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
>  {
>  	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
>  
> -	if ((fh_len != NILFS_FID_SIZE_NON_CONNECTABLE &&
> -	     fh_len != NILFS_FID_SIZE_CONNECTABLE) ||

> +	if ((fh_len < NILFS_FID_SIZE_NON_CONNECTABLE &&
> +	     fh_len < NILFS_FID_SIZE_CONNECTABLE) ||
>  	    (fh_type != FILEID_NILFS_WITH_PARENT &&
>  	     fh_type != FILEID_NILFS_WITHOUT_PARENT))
>  		return NULL;

A bit weird.  "fh_len < NILFS_FID_SIZE_CONNECTABLE" implies "fh_len <
NILFS_FID_SIZE_NON_CONNECTABLE".

How about the following fix ?

	if ((fh_type != FILEID_NILFS_WITH_PARENT ||
	     fh_len < NILFS_FID_SIZE_CONNECTABLE) &&
	    (fh_type != FILEID_NILFS_WITHOUT_PARENT ||
	     fh_len < NILFS_FID_SIZE_NON_CONNECTABLE))
		return NULL;

Regards,
Ryusuke Konishi

> @@ -510,7 +510,7 @@ static struct dentry *nilfs_fh_to_parent(struct super_block *sb, struct fid *fh,
>  {
>  	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
>  
> -	if (fh_len != NILFS_FID_SIZE_CONNECTABLE ||
> +	if (fh_len < NILFS_FID_SIZE_CONNECTABLE ||
>  	    fh_type != FILEID_NILFS_WITH_PARENT)
>  		return NULL;
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
