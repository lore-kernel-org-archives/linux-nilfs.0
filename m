From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [PATCH 16/29] jfs: use bdev_nr_sectors instead of open coding it
Date: Wed, 13 Oct 2021 09:13:57 -0500
Message-ID: <b9fdcc41-2ec5-d628-968b-0aea1091cf9a@oracle.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-17-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PH7q9sawEABNgdVYbDwjq/7q/2jR9ANS90FeZ6DyQ0U=;
 b=YacAys6/08Sm/C1atr5EYZvm+FyjC9GNkvsCF1CTmhyzLCE2zs1o72HGKBAuqS15J2Ok
 He/dkCz1K6coLyLaahtWykGTN/UFwZruUoROox/zCGVb5WjkBiSQtKD5XDZPi8rQNXTR
 DUSxwLglXd5jhso61yEgiCljsTrcz1sqC+XV8vIWf9Sz2Q7FLWwyAi2bNWYLKiX63Eco
 kDC81TS4zj74+v2bYfQD196AIqUvdpUp5Nk+5Z525Zxz3DDyTt2N9Ft6FKkQ+WLJS5Ci
 hWUJ8iTuVpBcCPDXJlfCwKDDJQBWozfBmPhNDxpZ38Xo5EcpP+6hdLgvxYrD8T7DNT7L sQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH7q9sawEABNgdVYbDwjq/7q/2jR9ANS90FeZ6DyQ0U=;
 b=aNNc1wp5Q2xDCjFLXwB8TPyMHJD4jMCCjBknIjg9zdW11OkjYreEXy2cV2Gjq639R4K9Jp82uI9Xc5HKfXRWK7wWIfIM0fdtnnhfjE/5fSfFjDllJ4588EQCtYbE8Y7D3h3hFek9rwWtVI/gFg+cPXTeKkYwkbnlNTcUEe1Gtoo=
Content-Language: en-US
In-Reply-To: <20211013051042.1065752-17-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lin

On 10/13/21 12:10AM, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>   fs/jfs/resize.c | 2 +-
>   fs/jfs/super.c  | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
> index bde787c354fcc..51a8b22e71030 100644
> --- a/fs/jfs/resize.c
> +++ b/fs/jfs/resize.c
> @@ -199,7 +199,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
>   	txQuiesce(sb);
>   
>   	/* Reset size of direct inode */
> -	sbi->direct_inode->i_size =  i_size_read(sb->s_bdev->bd_inode);
> +	sbi->direct_inode->i_size = bdev_nr_sectors(sb->s_bdev) << SECTOR_SHIFT;
>   
>   	if (sbi->mntflag & JFS_INLINELOG) {
>   		/*
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 9030aeaf0f886..992870160903d 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -551,7 +551,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
>   		ret = -ENOMEM;
>   		goto out_unload;
>   	}
> -	inode->i_size = i_size_read(sb->s_bdev->bd_inode);
> +	inode->i_size = bdev_nr_sectors(sb->s_bdev) << SECTOR_SHIFT;
>   	inode->i_mapping->a_ops = &jfs_metapage_aops;
>   	inode_fake_hash(inode);
>   	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
> 
