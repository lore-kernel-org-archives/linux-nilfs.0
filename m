From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [RFC][PATCH] nilfs2: enlarge s_volume_name member
Date: Sun, 02 May 2010 11:59:38 +0900 (JST)
Message-ID: <20100502.115938.01479064.ryusuke@osrg.net>
References: <878w834pml.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <878w834pml.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Sun, 02 May 2010 00:18:26 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is an RFC patch to enlarge s_volume_name member of nilfs_super_block.
> 
> Current s_volume_name has 16 bytes, which is too small as modern filesystem.
> 
> s_last_mounted resides just after s_volume_name and has 64 bytes.
> 
> s_last_mounted is historically came from ext2, but not used in nilfs2 at all.
> Deleting s_last_mounted member and merging that space with s_volume_name
> enlarge s_volume_name upto 80 bytes for volume label.
> 
> When user land tools see the old header for new disk, it will just ignore
> additional bytes stored in s_last_mounted.  While, old disk format has only
> 16 bytes label, it doesn't affects in case seeing the new header for old disk.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Thank you for the proposal.

You're right.  The current s_volume_name/s_last_mounted are mimics of
ext2/ext3, and looking back today, the 16 bytes volume name looks a
bit short.

Appending the region reserved for s_last_mounted to s_volume_name is
quite a nice idea!

I confirmed that this simple patch doesn't sacrifice compatibility.
This should be incorporated while we can.


BTW, the patch hit a style issue that I recently fixed with the patch
titled "nilfs2: fix style problems in nilfs2_fs.h":

 $ scripts/checkpatch.pl --file include/linux/nilfs2_fs.h
 WARNING: please, no space before tabs
 #210: FILE: linux/nilfs2_fs.h:210:
 +^Ichar^Is_volume_name[80]; ^I/* volume name */$

Could you rewrite it for the for-next branch of nilfs2.git?

You can also remove ``RFC'' from the changelog next time.

Thank you in advance,
Ryusuke Konishi

> ---
>  include/linux/nilfs2_fs.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 640702e..a41931d 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -207,8 +207,7 @@ struct nilfs_super_block {
>  	__le16	s_segment_usage_size;	/* Size of a segment usage */
>  
>  	__u8	s_uuid[16];		/* 128-bit uuid for volume */
> -	char	s_volume_name[16]; 	/* volume name */
> -	char	s_last_mounted[64]; 	/* directory where last mounted */
> +	char	s_volume_name[80]; 	/* volume name */
>  
>  	__le32  s_c_interval;           /* Commit interval of segment */
>  	__le32  s_c_block_max;          /* Threshold of data amount for
> -- 
> 1.5.6.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
