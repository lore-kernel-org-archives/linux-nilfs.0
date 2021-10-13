From: Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH 07/29] target/iblock: use bdev_nr_sectors instead of open
 coding it
Date: Wed, 13 Oct 2021 11:31:11 +0200
Message-ID: <3babe7ca-cf08-fd19-6793-39f6d78bca12@gmail.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-8-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jSDv3nCwYvRWF60PFzYmVFtCqi6n+8kG/qLGRQcEwXY=;
        b=XDrKXspyEQaSQYdqJnWhS/O0wblIXJrWl9pE6svv7KjgrDGVXul7dxFR95SMikNbI8
         dPBwNGXnMZrq9ECfkN9qd8qudIplcKbKQ02+dvBybldEqKgGTDn4o+Q+1yZvLDbQTpxH
         j0F3JAFmKpiVLRpHTHEBPzaDyzHphlM3B0d+/j7Ro7xiITFiea8XjX1E/h70+j8E07xJ
         iueofrb4NiJyC6FBpvAD+REiiIZXBpKUegBHgRICkLNGzc50RGa+mMfC0qBppipcUZ0O
         0MOGnuc/w5sEpIO1qpW0KnLTEIw6dv//T71InSxwu/1xkmLMW6ESgvB/ttIEAHR+9lRU
         du6Q==
In-Reply-To: <20211013051042.1065752-8-hch@lst.de>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 13.10.21 07:10, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/target/target_core_iblock.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 31df20abe141f..ab7f5678ebc44 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -232,8 +232,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
>   	struct block_device *bd,
>   	struct request_queue *q)
>   {
> -	unsigned long long blocks_long = (div_u64(i_size_read(bd->bd_inode),
> -					bdev_logical_block_size(bd)) - 1);
> +	loff_t size = bdev_nr_sectors(bd) << SECTOR_SHIFT;
> +	unsigned long long blocks_long =
> +		div_u64(size, bdev_logical_block_size(bd)) - 1;
>   	u32 block_size = bdev_logical_block_size(bd);

To enhance readability, would it make sense to shift the new lines
behind "u32 block_size = ...", so block_size can be used in div_u64
instead of using bdev_logical_block_size twice?

>   
>   	if (block_size == dev->dev_attrib.block_size)
> 
