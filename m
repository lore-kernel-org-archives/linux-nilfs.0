From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv2] nilfs2: move definition of struct
 nilfs_btree_node
Date: Mon, 09 Nov 2009 20:30:41 +0900 (JST)
Message-ID: <20091109.203041.13035746.ryusuke@osrg.net>
References: <87my2wggak.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <87my2wggak.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Mon, 09 Nov 2009 19:10:11 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a trivial patch to expose struct nilfs_fs_btree_node.
> The struct sould be exposed outside of kernel, for it is disk format.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/btree.h         |   22 ----------------------
>  include/linux/nilfs2_fs.h |   22 ++++++++++++++++++++++
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
> index 0e72bbb..4b82d84 100644
> --- a/fs/nilfs2/btree.h
> +++ b/fs/nilfs2/btree.h
> @@ -34,28 +34,6 @@ struct nilfs_btree;
>  struct nilfs_btree_path;
>  
>  /**
> - * struct nilfs_btree_node - B-tree node
> - * @bn_flags: flags
> - * @bn_level: level
> - * @bn_nchildren: number of children
> - * @bn_pad: padding
> - */
> -struct nilfs_btree_node {
> -	__u8 bn_flags;
> -	__u8 bn_level;
> -	__le16 bn_nchildren;
> -	__le32 bn_pad;
> -};
> -
> -/* flags */
> -#define NILFS_BTREE_NODE_ROOT	0x01
> -
> -/* level */
> -#define NILFS_BTREE_LEVEL_DATA		0
> -#define NILFS_BTREE_LEVEL_NODE_MIN	(NILFS_BTREE_LEVEL_DATA + 1)
> -#define NILFS_BTREE_LEVEL_MAX		14
> -
> -/**
>   * struct nilfs_btree - B-tree structure
>   * @bt_bmap: bmap base structure
>   */
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 79fec6a..42c37ba 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -403,6 +403,28 @@ struct nilfs_segment_summary {
>  #define NILFS_SS_GC     0x0010  /* segment written for cleaner operation */
>  
>  /**
> + * struct nilfs_btree_node - B-tree node
> + * @bn_flags: flags
> + * @bn_level: level
> + * @bn_nchildren: number of children
> + * @bn_pad: padding
> + */
> +struct nilfs_btree_node {
> +	__u8 bn_flags;
> +	__u8 bn_level;
> +	__le16 bn_nchildren;
> +	__le32 bn_pad;
> +};
> +
> +/* flags */
> +#define NILFS_BTREE_NODE_ROOT   0x01
> +
> +/* level */
> +#define NILFS_BTREE_LEVEL_DATA          0
> +#define NILFS_BTREE_LEVEL_NODE_MIN      (NILFS_BTREE_LEVEL_DATA + 1)
> +#define NILFS_BTREE_LEVEL_MAX           14
> +
> +/**
>   * struct nilfs_palloc_group_desc - block group descriptor
>   * @pg_nfrees: number of free entries in block group
>   */
> -- 
> 1.5.6.5
> 

Applied.  Thank you!

Ryusuke Konishi
