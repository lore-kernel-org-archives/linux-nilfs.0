From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: add omitted comment for ns_mount_state
 field of the_nilfs structure
Date: Wed, 23 May 2012 22:22:48 +0900 (JST)
Message-ID: <20120523.222248.27788175.konishi.ryusuke@lab.ntt.co.jp>
References: <1337696715.2530.14.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337696715.2530.14.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 22 May 2012 18:25:15 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> I found that ns_mount_state field doesn't commented in the_nilfs
> structure. I simply add comment for ns_mount_state field.
> 
> With the best regards,
> Vyacheslav Dubeyko.

Thanks.  I will pick it up.

Ryusuke Konishi

> --
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH 1/1] nilfs2: add omitted comment for ns_mount_state
> field of the_nilfs structure
> 
> This patch adds omitted comment for ns_mount_state field of the_nilfs
> structure.
> 
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> ---
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 1a588a3..7885bdb 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -53,6 +53,7 @@ enum {
>   * @ns_sbwtime: previous write time of super block
>   * @ns_sbwcount: write count of super block
>   * @ns_sbsize: size of valid data in super block
> + * @ns_mount_state: file system state
>   * @ns_seg_seq: segment sequence counter
>   * @ns_segnum: index number of the latest full segment.
>   * @ns_nextnum: index number of the full segment index to be used next
> --
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
