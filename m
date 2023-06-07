From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 16/31] block: use the holder as indication for exclusive
 opens
Date: Wed, 7 Jun 2023 15:53:54 +0200
Message-ID: <20230607135354.GP25292@twin.jikos.cz>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-17-hch@lst.de>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:Reply-To:List-Subscribe:List-Help:
	List-Post:List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=u+fQKnQQeZyhYKwAX4MA9S+PydNtTgUj3uERQmG6sHk=; b=k8c2LBpgFo3fcP
	Iu7RbuBhX00PdlYmcsiNayYLbw0CNC8OIgPoJE21NGnwfEI2Y8iNvB/hi20suHDgElAdqOA3o/5gr
	OD7BlB+2nM7D4o0D8y6YjVaXwYzLU/iPIptLuNc8aePJInxIkpnD28V9lXA1AJrucYbSzuWIXjk1b
	hfqfYOYxCoZs5OpZ96Hvp852D2gawBWdTyHSDhCle57nbAt8xjymjnEp2H/cYm+xuwNpgXcfkaVwI
	1LRhDYeR8IEi9Dd9E0FJslWoHpqmTf5cXlyKMUE+QJqONuVabilow+yXeZrvB5HgXyV19AcS4/1mx
	I6IKnen7egNX5hQkRZbA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1686146410;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UrhG/vp+m03DiK3yFBmnkaqHBlBTfdkmOZNwI5+daeI=;
	b=aaeNmU5ZCbhkqsc+e7TmqELd+MojX+TJ4sW47FDZ16ksOKTS1HV5xIbX0zomficAn/Jh5v
	VZiRj0mibB+S0/nZ9oVGZBw1IUP0IX/+ZnPW1SQuG9FRCZsxkZPR09gqoOTRnF+vHJM2YE
	Ooe+gJXDWNv9E7scSycsuGNec+mAcBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1686146410;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UrhG/vp+m03DiK3yFBmnkaqHBlBTfdkmOZNwI5+daeI=;
	b=KHxasVxySgF+IfYKHAeDp2hM9up/Wuoe5ajJJXZVSidBzHNz58lOdiZ2OyRWPEh/mFqMqo
	GNlPBbs8U0FDH+DA==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-17-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.ke

On Tue, Jun 06, 2023 at 09:39:35AM +0200, Christoph Hellwig wrote:
> The current interface for exclusive opens is rather confusing as it
> requires both the FMODE_EXCL flag and a holder.  Remove the need to pass
> FMODE_EXCL and just key off the exclusive open off a non-NULL holder.
> 
> For blkdev_put this requires adding the holder argument, which provides
> better debug checking that only the holder actually releases the hold,
> but at the same time allows removing the now superfluous mode argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bdev.c                        | 37 ++++++++++++++++------------
>  block/fops.c                        |  6 +++--
>  block/genhd.c                       |  5 ++--
>  block/ioctl.c                       |  5 ++--
>  drivers/block/drbd/drbd_nl.c        | 23 ++++++++++-------
>  drivers/block/pktcdvd.c             | 13 +++++-----
>  drivers/block/rnbd/rnbd-srv.c       |  4 +--
>  drivers/block/xen-blkback/xenbus.c  |  2 +-
>  drivers/block/zram/zram_drv.c       |  8 +++---
>  drivers/md/bcache/super.c           | 15 ++++++------
>  drivers/md/dm.c                     |  6 ++---
>  drivers/md/md.c                     | 38 +++++++++++++++--------------
>  drivers/mtd/devices/block2mtd.c     |  4 +--
>  drivers/nvme/target/io-cmd-bdev.c   |  2 +-
>  drivers/s390/block/dasd_genhd.c     |  2 +-
>  drivers/target/target_core_iblock.c |  6 ++---
>  drivers/target/target_core_pscsi.c  |  8 +++---

For

>  fs/btrfs/dev-replace.c              |  6 ++---
>  fs/btrfs/ioctl.c                    | 12 ++++-----
>  fs/btrfs/volumes.c                  | 28 ++++++++++-----------
>  fs/btrfs/volumes.h                  |  6 ++---

Acked-by: David Sterba <dsterba@suse.com>
