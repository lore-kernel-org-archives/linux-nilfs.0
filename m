From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/31] bcache: don't pass a stack address to
 blkdev_get_by_path
Date: Wed, 7 Jun 2023 14:23:17 +0200
Message-ID: <a5a9ca4d-cbbc-ab1a-18e9-04701fc36f72@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-14-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686140598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+iIOsQLPB7YZZYVVrausU5kIOvN1cfOb9IWj5ZxDzbs=;
        b=tUDPgFGh7AnivU0V9GcUwo1xQYyZd5gcErtEGaqwWUCoXCd4jiaMFokUF4WY8LLDDiqJWr
        JufyNO098hsKKp8QyvyLhf4f0UK+2z5JKS1txinQSQzKJ9i6WkxoMpHDu6kNCdh6BMY5X9
        vKLoAqZ8Xb8SBcLECt+Y5xJy75WAix8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686140598;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+iIOsQLPB7YZZYVVrausU5kIOvN1cfOb9IWj5ZxDzbs=;
        b=MUq/mCltjJxBM+miHzSe96ZT+T+bP01yFlcat1Ang0sVf+yjMl7Uimw08eK0YLrU6uvP58
        uVESDDRgNl+t65Dg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-14-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> sb is just an on-stack pointer that can easily be reused by other calls.
> Switch to use the bcache-wide bcache_kobj instead as there is no need to
> claim per-bcache device anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/bcache/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

