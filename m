From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [PATCH 27/30] jfs: use sb_bdev_nr_blocks
Date: Fri, 15 Oct 2021 09:16:58 -0500
Message-ID: <2056d9b3-cf07-36fc-ad60-381e4a4e6d7b@oracle.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-28-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dd79Ru+92+tvwwdfde/giyArZGTbUGkHFZZOlpDPINg=;
 b=Nb9oCbiHqcNu4X0+Mm+5TnAMYUBDw7kBhpRANsDsnCrivtIo5ainQVFfk3opJwek/Dsp
 s1FTnGzRCXQ3xo1aQpTfgmAedT0vCNriREocxzx/eJyGZrVkyMOm3vQWv9flsUUWJxgo
 0Zfoop+PJPJeD9R0m2BBRlMhulbk47da3a57+UGyRcsmzMBTvwCWUAfDv0VQ+Tqqk8cK
 /gYHGldmQC1r0L+ONi7vW8KA+kt9D4p5EOmtCDTbDdKg72VOuw4OMec0F2uabUbON89I
 KqisYO+x5SXcrL5UtPeo4xE52dA3D6S+PYvpyQA4gKVLsLPZ+5w7wpMxYIgXI16n4Kin hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd79Ru+92+tvwwdfde/giyArZGTbUGkHFZZOlpDPINg=;
 b=d6md9LI2Up2AzO5ehqmcnD4Ruah/2S2iYGWAyYCBky31g5GPR9WvBvdmKIS32ed2wNBkRkvwAvUkxodv+2b6Zey5rnDOJ8FgO6gOKBcdUM4yhDwOHp0pbtLDPOPDwsSt/r8klV9qIlQ1SWCRym3cEJrueh9VYWjerTMC6DjCKxE=
Content-Language: en-US
In-Reply-To: <20211015132643.1621913-28-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 10/15/21 8:26AM, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>   fs/jfs/resize.c | 3 +--
>   fs/jfs/super.c  | 3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
> index a42dbb0d3d28a..8b9a72ae5efa7 100644
> --- a/fs/jfs/resize.c
> +++ b/fs/jfs/resize.c
> @@ -86,8 +86,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
>   		goto out;
>   	}
>   
> -	VolumeSize = i_size_read(sb->s_bdev->bd_inode) >> sb->s_blocksize_bits;
> -
> +	VolumeSize = sb_bdev_nr_blocks(sb);
>   	if (VolumeSize) {
>   		if (newLVSize > VolumeSize) {
>   			printk(KERN_WARNING "jfs_extendfs: invalid size\n");
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 9241caa161163..24cbc9946e01c 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -284,8 +284,7 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
>   		}
>   		case Opt_resize_nosize:
>   		{
> -			*newLVSize = i_size_read(sb->s_bdev->bd_inode) >>
> -				sb->s_blocksize_bits;
> +			*newLVSize = sb_bdev_nr_blocks(sb);
>   			if (*newLVSize == 0)
>   				pr_err("JFS: Cannot determine volume size\n");
>   			break;
> 
