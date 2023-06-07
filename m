From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/31] block: pass a gendisk to ->open
Date: Wed, 7 Jun 2023 14:19:36 +0200
Message-ID: <9d7ae46b-f963-3412-cf5c-4d11c54eea58@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-10-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=hIcAmuwwomlFKuWyJzT2ZczfUfDqBv+dd3ElI46NTH0=; b=ERd+1raQfp09PSimSYzmiOcc9l
 RWHL9sQxBr17zqiH6LSUL0B9at2dHCTqUP+fnW5GFi3ywe1OuikzgYG1HuyglS1TCM0sstDnoxOBG
 ZAHDbkakyaSnkOg2TFYsQERg8RNZkHFmXIHmhG3RgRDL1uVDe15VCE0wpXiLVuUkrrBs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
 Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=hIcAmuwwomlFKuWyJzT2ZczfUfDqBv+dd3ElI46NTH0=; b=i5OZQSqYLxtJsncSLQOBTO9nO/
 ogZJdoS2yGtM8rvZBYWW69Vu/RsONucBf4x6UR2034wNcj50nVo9ZBzPsA0KKxOPJ4eMsGs42x9zn
 RC5bCdMW/+95MvahSJpIP0OS/cZ3Wlyj72HWPm56Vd4aGcet9ORgImutu28J1D5D+N8Y=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1686140377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hIcAmuwwomlFKuWyJzT2ZczfUfDqBv+dd3ElI46NTH0=;
 b=nwl1WimOwPcjF98AEDnJ2K0z5H5r6S9PZV0NMxPrxeO+b6iUxsJL+D1fFXUbalAwuKeyE3
 zDs72n/QwOPnZMi8nk3pSIarBQVHhZeQACSX9v+viDkwrv0NDl02wL5QLAw6mpY+lpJvKO
 GLq8dP5GTUTOdUeWCMUzXQ+Ee2PhJ1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1686140377;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hIcAmuwwomlFKuWyJzT2ZczfUfDqBv+dd3ElI46NTH0=;
 b=E1AF4AwgkO2HnPq1es8OnevAsUmnYalHeDtF1c1JN6GfSa26Y5PIvIwVLzXxB76McWsDjz
 R09PGSzfxNnSgdAQ==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-10-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

On 6/6/23 09:39, Christoph Hellwig wrote:
> ->open is only called on the whole device.  Make that explicit by
> passing a gendisk instead of the block_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/um/drivers/ubd_kern.c          |  5 ++---
>   arch/xtensa/platforms/iss/simdisk.c |  4 ++--
>   block/bdev.c                        |  2 +-
>   drivers/block/amiflop.c             |  8 ++++----
>   drivers/block/aoe/aoeblk.c          |  4 ++--
>   drivers/block/ataflop.c             | 16 +++++++--------
>   drivers/block/drbd/drbd_main.c      |  6 +++---
>   drivers/block/floppy.c              | 30 +++++++++++++++--------------
>   drivers/block/nbd.c                 |  8 ++++----
>   drivers/block/pktcdvd.c             |  6 +++---
>   drivers/block/rbd.c                 |  4 ++--
>   drivers/block/rnbd/rnbd-clt.c       |  4 ++--
>   drivers/block/swim.c                | 10 +++++-----
>   drivers/block/swim3.c               | 10 +++++-----
>   drivers/block/ublk_drv.c            |  4 ++--
>   drivers/block/z2ram.c               |  6 ++----
>   drivers/block/zram/zram_drv.c       | 13 +++++--------
>   drivers/cdrom/gdrom.c               |  4 ++--
>   drivers/md/bcache/super.c           |  4 ++--
>   drivers/md/dm.c                     |  4 ++--
>   drivers/md/md.c                     |  6 +++---
>   drivers/mmc/core/block.c            |  4 ++--
>   drivers/mtd/mtd_blkdevs.c           |  4 ++--
>   drivers/mtd/ubi/block.c             |  4 ++--
>   drivers/nvme/host/core.c            |  4 ++--
>   drivers/nvme/host/multipath.c       |  4 ++--
>   drivers/s390/block/dasd.c           |  4 ++--
>   drivers/s390/block/dcssblk.c        |  7 +++----
>   drivers/scsi/sd.c                   | 12 ++++++------
>   drivers/scsi/sr.c                   |  6 +++---
>   include/linux/blkdev.h              |  2 +-
>   31 files changed, 102 insertions(+), 107 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
