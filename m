From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 19/25] nilfs2: Convert to properly refcounting bdi
Date: Wed, 12 Apr 2017 22:47:31 +0900
Message-ID: <eb194a7c-d6cf-786d-0a06-d9836a2a05c5@lab.ntt.co.jp>
References: <20170412102449.16901-1-jack@suse.cz>
 <20170412102449.16901-20-jack@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170412102449.16901-20-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

On 2017/04/12 19:24, Jan Kara wrote:
> Similarly to set_bdev_super() NILFS2 just used block device reference to
> bdi. Convert it to properly getting bdi reference. The reference will
> get automatically dropped on superblock destruction.
>
> CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> CC: linux-nilfs@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine, thanks.

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


> ---
>  fs/nilfs2/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index e1872f36147f..feb796a38b8d 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -1068,7 +1068,8 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_time_gran = 1;
>  	sb->s_max_links = NILFS_LINK_MAX;
>
> -	sb->s_bdi = bdev_get_queue(sb->s_bdev)->backing_dev_info;
> +	sb->s_bdi = bdi_get(sb->s_bdev->bd_bdi);
> +	sb->s_iflags |= SB_I_DYNBDI;
>
>  	err = load_nilfs(nilfs, sb);
>  	if (err)
>


