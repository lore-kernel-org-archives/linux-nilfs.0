From: Jinpu Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 28/31] block: replace fmode_t with a block-specific type
 for block open flags
Date: Wed, 7 Jun 2023 11:45:39 +0200
Message-ID: <CAMGffEk2LB0CDqR6DJczhejkkyK1Q5Ybu-wJ_fr99O0fXa-pew@mail.gmail.com>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-29-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1686131150; x=1688723150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79vzDiF+tHrnH1dRnmQpod9DfGlW5ryqo0lz5n79FPI=;
        b=FJamJYdT3if+5bC5MiBpMp+FFu/lOoO4qwlYSJv9n0/h/OCDUjBN+06Y5+uXbPlxGg
         WzF23UIBA7vCWADd8Vks7i2cG2U4opcA9P/78wHN/K4fj8HGhf6KnCl8YjjpgJJVnvlB
         hiZSt/O06mq6yVTGbe1Xbm78hWMDypBHvsUI14YH2ldWO/fNP5glJNykhF7/3t13XEm8
         J+PFP/ZVX+XFyUteBqBkDLqr81iNO7g4hjhPuN5y9T9TIVwh6rNLUX/Nk3vsBKiV6F+x
         GXhYFeACevO08CL9xeeLqMtmWxMOgxDUBpFi70eYskDjDqEfgVaRrrjyxsUtCDN7+EvU
         utwQ==
In-Reply-To: <20230606073950.225178-29-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs

On Tue, Jun 6, 2023 at 9:41=E2=80=AFAM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote=
:
>
> The only overlap between the block open flags mapped into the fmode_t and
> other uses of fmode_t are FMODE_READ and FMODE_WRITE.  Define a new
> blk_mode_t instead for use in blkdev_get_by_*, ->open and ->ioctl and
> stop abusing fmode_t.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  arch/um/drivers/ubd_kern.c          |  8 +++---
>  arch/xtensa/platforms/iss/simdisk.c |  2 +-
>  block/bdev.c                        | 32 +++++++++++-----------
>  block/blk-zoned.c                   |  8 +++---
>  block/blk.h                         | 11 ++++----
>  block/fops.c                        | 26 +++++++++++++-----
>  block/genhd.c                       |  8 +++---
>  block/ioctl.c                       | 42 +++++++++--------------------
>  drivers/block/amiflop.c             | 12 ++++-----
>  drivers/block/aoe/aoeblk.c          |  4 +--
>  drivers/block/ataflop.c             | 25 +++++++++--------
>  drivers/block/drbd/drbd_main.c      |  7 ++---
>  drivers/block/drbd/drbd_nl.c        |  2 +-
>  drivers/block/floppy.c              | 28 +++++++++----------
>  drivers/block/loop.c                | 22 +++++++--------
>  drivers/block/mtip32xx/mtip32xx.c   |  4 +--
>  drivers/block/nbd.c                 |  4 +--
>  drivers/block/pktcdvd.c             | 17 ++++++------
>  drivers/block/rbd.c                 |  2 +-
>  drivers/block/rnbd/rnbd-clt.c       |  4 +--
>  drivers/block/rnbd/rnbd-srv.c       |  4 +--
Acked-by: Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org> # for rnbd.
