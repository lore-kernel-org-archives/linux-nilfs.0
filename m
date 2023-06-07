From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/31] block: remove the unused mode argument to ->release
Date: Wed, 7 Jun 2023 14:20:50 +0200
Message-ID: <bb59f7f1-0d12-ed28-9754-7027959ada0b@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-11-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=pZf/k7i2e1PfqP1u6ky3YLMcMeR3hHUcovmqktZtuDY=; b=oOvG8APflLVAqV
	XyTPIapkE9alWHR4zB48d16YYjl7zM1OqStXP7unWQz45dxQFekQ2qnxKQW5UcnJRrOPUcCEtv+hU
	DDyzHdw+hiPOE843Do3Swyj4RcjPf6oMmLLfUqUw0vGeH5oZFBnC1W4ZaDPDqCK7krDxeoewyzAG1
	PCNUeDlpTgHXhFEFceQ6nrgrdt7x6y/Qt2vNqcbGh+UlkTr79I/tdfWzw13yy7k/UNHHjYkfLMKkk
	FV2xN3gWEXG8eDdMGebOiYZK+ghDbTDVOj21H/wf8CfBAZykpk3OsSqKdXGZuVXpuNmHwoDlbncyN
	T6tdeCEnO6u6Nofl4GMw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686140450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1Rl1qGqvM4Z5x8Xq+CyMv3eUpGokjis8a1uEGHT2oM=;
	b=NtfJezGisqgVMGMlpHu5h7lKBliQJSnIU40FJjYFHclq1pJ2yccwB2gCrQVYr/XEAgBe//
	SwWqpD3W1ozsd6dyaotuzbIDg6Oacufyt0jV/rrLR+MxmjDwaQJv56xVitpaNX1eUWndRD
	n4xYwVUPyj+t5hxm3UfoFljrLDNuTx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686140450;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1Rl1qGqvM4Z5x8Xq+CyMv3eUpGokjis8a1uEGHT2oM=;
	b=zQ5xWW4Z2foG7bGxNOdFosbyzeVEHPlunA2KDXAT7USZKkViaz3OAfkcgfavN420ThY0SP
	Jl33OjNpQS/R7bCg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-11-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kerne

On 6/6/23 09:39, Christoph Hellwig wrote:
> The mode argument to the ->release block_device_operation is never used,
> so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/um/drivers/ubd_kern.c          |  4 ++--
>   arch/xtensa/platforms/iss/simdisk.c |  2 +-
>   block/bdev.c                        | 14 +++++++-------
>   drivers/block/amiflop.c             |  2 +-
>   drivers/block/aoe/aoeblk.c          |  2 +-
>   drivers/block/ataflop.c             |  4 ++--
>   drivers/block/drbd/drbd_main.c      |  4 ++--
>   drivers/block/floppy.c              |  2 +-
>   drivers/block/loop.c                |  2 +-
>   drivers/block/nbd.c                 |  2 +-
>   drivers/block/pktcdvd.c             |  4 ++--
>   drivers/block/rbd.c                 |  2 +-
>   drivers/block/rnbd/rnbd-clt.c       |  2 +-
>   drivers/block/swim.c                |  2 +-
>   drivers/block/swim3.c               |  3 +--
>   drivers/block/z2ram.c               |  2 +-
>   drivers/cdrom/gdrom.c               |  2 +-
>   drivers/md/bcache/super.c           |  2 +-
>   drivers/md/dm.c                     |  2 +-
>   drivers/md/md.c                     |  2 +-
>   drivers/mmc/core/block.c            |  2 +-
>   drivers/mtd/mtd_blkdevs.c           |  2 +-
>   drivers/mtd/ubi/block.c             |  2 +-
>   drivers/nvme/host/core.c            |  2 +-
>   drivers/nvme/host/multipath.c       |  2 +-
>   drivers/s390/block/dasd.c           |  2 +-
>   drivers/s390/block/dcssblk.c        |  4 ++--
>   drivers/scsi/sd.c                   |  3 +--
>   drivers/scsi/sr.c                   |  2 +-
>   include/linux/blkdev.h              |  2 +-
>   30 files changed, 41 insertions(+), 43 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
