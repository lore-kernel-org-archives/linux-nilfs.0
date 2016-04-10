From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] nilfs2: constify nilfs_sc_operations structures
Date: Sun, 10 Apr 2016 12:11:38 +0900 (JST)
Message-ID: <20160410.121138.2044396586371844072.konishi.ryusuke@lab.ntt.co.jp>
References: <1460190503-8672-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M5QPonpOmbkt+NqNKr+VWbOOlmAJMQPzOzilgZ8CRug=;
        b=DTyn51BUJYl1nkL9XEATAoosn3syT0B4ziRumudVgLSfmZd9Y9+RkiVMa/vJUa4Wn4
         pLOjmYQT4KPhfvYw0zDN8hG59w95pyhTf6u+dZqmXYh5Nd4JjsSmN7kvNSMPjnXf7IgP
         LL24tNQb42L00g3afUrDdAiy9vUv/FHRe6dvQobZ4JwlZGKF//lMXPZNqcXv8vBCElR1
         vCOX/SBLAjy3IAKrNDRlemy2AwlmsH1MQh9KmEuY478WYyLVLh7Y3/USudS88oivr8pt
         OrsuVR+mhv+YAvyTxcPbUaiV47rh4kGx5q4JheuSe/wuSGevMQyup/Gzd7ho/1lQ7RLe
         o3TA==
In-Reply-To: <1460190503-8672-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat,  9 Apr 2016 10:28:23 +0200, Julia Lawall wrote:
> The nilfs_sc_operations structures are never modified, so declare them
> as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 

Applied, thanks.

Ryusuke Konishi

> ---
>  fs/nilfs2/segment.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 4317f72..483e663 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -617,7 +617,7 @@ static void nilfs_write_file_node_binfo(struct nilfs_sc_info *sci,
>  	*vblocknr = binfo->bi_v.bi_vblocknr;
>  }
>  
> -static struct nilfs_sc_operations nilfs_sc_file_ops = {
> +static const struct nilfs_sc_operations nilfs_sc_file_ops = {
>  	.collect_data = nilfs_collect_file_data,
>  	.collect_node = nilfs_collect_file_node,
>  	.collect_bmap = nilfs_collect_file_bmap,
> @@ -666,7 +666,7 @@ static void nilfs_write_dat_node_binfo(struct nilfs_sc_info *sci,
>  	*binfo_dat = binfo->bi_dat;
>  }
>  
> -static struct nilfs_sc_operations nilfs_sc_dat_ops = {
> +static const struct nilfs_sc_operations nilfs_sc_dat_ops = {
>  	.collect_data = nilfs_collect_dat_data,
>  	.collect_node = nilfs_collect_file_node,
>  	.collect_bmap = nilfs_collect_dat_bmap,
> @@ -674,7 +674,7 @@ static struct nilfs_sc_operations nilfs_sc_dat_ops = {
>  	.write_node_binfo = nilfs_write_dat_node_binfo,
>  };
>  
> -static struct nilfs_sc_operations nilfs_sc_dsync_ops = {
> +static const struct nilfs_sc_operations nilfs_sc_dsync_ops = {
>  	.collect_data = nilfs_collect_file_data,
>  	.collect_node = NULL,
>  	.collect_bmap = NULL,
> @@ -1043,7 +1043,7 @@ static size_t nilfs_segctor_buffer_rest(struct nilfs_sc_info *sci)
>  
>  static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
>  				   struct inode *inode,
> -				   struct nilfs_sc_operations *sc_ops)
> +				   const struct nilfs_sc_operations *sc_ops)
>  {
>  	LIST_HEAD(data_buffers);
>  	LIST_HEAD(node_buffers);
> @@ -1550,7 +1550,7 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
>  	sector_t blocknr;
>  	unsigned long nfinfo = segbuf->sb_sum.nfinfo;
>  	unsigned long nblocks = 0, ndatablk = 0;
> -	struct nilfs_sc_operations *sc_op = NULL;
> +	const struct nilfs_sc_operations *sc_op = NULL;
>  	struct nilfs_segsum_pointer ssp;
>  	struct nilfs_finfo *finfo = NULL;
>  	union nilfs_binfo binfo;
> 
