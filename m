From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/31] block: pass a gendisk on bdev_check_media_change
Date: Wed, 7 Jun 2023 14:15:05 +0200
Message-ID: <3db66acd-112a-906b-5e2f-25ab843253cc@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-8-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686140106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCf1JgyrYBVXKyreePtxys/QiUi87JN83HRlMRb2lYE=;
        b=CRDzZNeTguzVV10MP0Cz5mjZfwsyQGQRMvccEpkjxWr6pSG/xzALuvyRhI1wD2mh48HhAY
        65ExpR0IOIaw9C+DUYtbqHHrUH6NcON5dQBfQeEvRNslIYmedAR1Bqhfpw8oom/MiT3gFY
        nXlAz/paj0eO5VYqifRjRAxjliakFbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686140106;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCf1JgyrYBVXKyreePtxys/QiUi87JN83HRlMRb2lYE=;
        b=OtqJFtTN6bvGkX0HHZPsY0QQ3cDJ9AcCdim3RmTqYjZmzFRMxXuf8vsckjvqb94lWEJnay
        LXsic/Ff7fLJ9eDQ==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-8-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> bdev_check_media_change should only ever be called for the whole device.
> Pass a gendisk to make that explicit and rename the function to
> disk_check_media_change.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/disk-events.c     | 18 +++++++++---------
>   drivers/block/amiflop.c |  2 +-
>   drivers/block/ataflop.c |  6 +++---
>   drivers/block/floppy.c  | 16 ++++++++--------
>   drivers/block/swim.c    |  2 +-
>   drivers/block/swim3.c   |  2 +-
>   drivers/cdrom/gdrom.c   |  2 +-
>   drivers/md/md.c         |  2 +-
>   drivers/scsi/sd.c       |  9 ++++-----
>   drivers/scsi/sr.c       |  2 +-
>   include/linux/blkdev.h  |  2 +-
>   11 files changed, 31 insertions(+), 32 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

