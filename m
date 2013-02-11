From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] fs: encode_fh: return FILEID_INVALID if invalid fid_type
Date: Tue, 12 Feb 2013 08:33:11 +1100
Message-ID: <20130211213311.GE8257@dastard>
References: <1360571159-3666-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360571159-3666-1-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, mfasheh-IBi9RG/b67k@public.gmane.org, jlbec-KSFe+WNznQmEi8DpZVb4nw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, bpm-sJ/iWh9BUns@public.gmane.org, elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Vivek Trivedi <t.vivek-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Mon, Feb 11, 2013 at 05:25:58PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> 
> This patch is a follow up on below patch:
> 
> [PATCH] exportfs: add FILEID_INVALID to indicate invalid fid_type
> commit: 216b6cbdcbd86b1db0754d58886b466ae31f5a63 
....
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index a836118..3391800 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -48,7 +48,7 @@ static int xfs_fileid_length(int fileid_type)
>  	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
>  		return 6;
>  	}
> -	return 255; /* invalid */
> +	return FILEID_INVALID; /* invalid */
>  }

I think you can drop the "/* invalid */" comment from there now as
it is redundant with this change.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
