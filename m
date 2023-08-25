From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 01/30] block: also call ->open for
 incremental partition opens
Date: Fri, 25 Aug 2023 03:44:57 +0100
Message-ID: <20230825024457.GD95084@ZenIV>
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692931526;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n2uWQEWgWHy7Mf2g0Q7Eceo9+N3kI3C6qoDD3ukqi4A=;
	b=apHsYQCQDKJiqY91wePClt1M3y/ECHK4GlKSTVnD16zfUlBJpQvHgO+Za7B+LVa1IneRtn
	FulDeF6qgPImKeQt5HBHgWHys/tsZ2QlbJaj6qPr6pDGjj/+CmIXy8ASj4C7NrBpQ/RiR7
	axh/m6gALpYwgsfjDlG2OH1sEPPOImE=
In-Reply-To: <20230608110258.189493-2-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
Content-Disposition: inline
To: Christoph Hellwig <hch@lst.de>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-b

On Thu, Jun 08, 2023 at 01:02:29PM +0200, Christoph Hellwig wrote:

> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -683,9 +683,6 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
>  	struct gendisk *disk = part->bd_disk;
>  	int ret;
>  
> -	if (atomic_read(&part->bd_openers))
> -		goto done;
> -
>  	ret = blkdev_get_whole(bdev_whole(part), mode);
>  	if (ret)
>  		return ret;
> @@ -694,9 +691,10 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
>  	if (!bdev_nr_sectors(part))
>  		goto out_blkdev_put;
>  
> -	disk->open_partitions++;
> -	set_init_blocksize(part);
> -done:
> +	if (!atomic_read(&part->bd_openers)) {
> +		disk->open_partitions++;
> +		set_init_blocksize(part);
> +	}

[with apologies for very late (and tangential) reply]

That got me curious about the ->bd_openers - do we need it atomic?
Most of the users (and all places that do modifications) are
under ->open_mutex; the only exceptions are
	* early sync logics in blkdev_put(); it's explicitly racy -
see the comment there.
	* callers of disk_openers() in loop and nbd (the ones in
zram are under ->open_mutex).  There's driver-private exclusion
around those, but in any case - READ_ONCE() is no worse than
atomic_read() in those cases.

Is there something subtle I'm missing here?
