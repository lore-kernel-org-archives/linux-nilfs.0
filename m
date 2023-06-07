From: Jinpu Wang <jinpu.wang@ionos.com>
Subject: Re: [PATCH 10/31] block: remove the unused mode argument to ->release
Date: Wed, 7 Jun 2023 11:41:12 +0200
Message-ID: <CAMGffEkqXCkxpA+qqDVfx0echCPvNpWgK3hZWbb11F6cv2EQ-A@mail.gmail.com>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-11-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1686130883; x=1688722883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hFPeu/3BJQ1XAEBfX/WbvMEVzeUhOBPi58IZ/Esj6w=;
        b=DQ2W7u0kTQ72LzKcRWTgSG5Ic2en/sUZGdoBco91l0Mccvv0oAQBf/skoCqaEe9seE
         +dzp3Di1fk566WbDYFELqWJPFl5MunPBPZMeITsSShGZc7BDokFlIiDQLZFB4ZrSewGv
         3oX0GYhrvTDmISog+YzCJR1YtaZTCauUpfCjvwOk/JH+2E22rzqjqm0VAxXGE6uAZmC+
         EGD5OJ0fSz21kp9IqsqErfAtnLdYe5oeRENAmZus9bszHTyvCXJZvWktYhQnQZuZ89iJ
         k32HqmMpJwKqRO7v+RyJDkZmScyggr+L8hspyToZJsfDu3VkwGwgCJBAnl1PESLHhwEf
         au/Q==
In-Reply-To: <20230606073950.225178-11-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs

On Tue, Jun 6, 2023 at 9:40=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> The mode argument to the ->release block_device_operation is never used,
> so remove it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/um/drivers/ubd_kern.c          |  4 ++--
>  arch/xtensa/platforms/iss/simdisk.c |  2 +-
>  block/bdev.c                        | 14 +++++++-------
>  drivers/block/amiflop.c             |  2 +-
>  drivers/block/aoe/aoeblk.c          |  2 +-
>  drivers/block/ataflop.c             |  4 ++--
>  drivers/block/drbd/drbd_main.c      |  4 ++--
>  drivers/block/floppy.c              |  2 +-
>  drivers/block/loop.c                |  2 +-
>  drivers/block/nbd.c                 |  2 +-
>  drivers/block/pktcdvd.c             |  4 ++--
>  drivers/block/rbd.c                 |  2 +-
>  drivers/block/rnbd/rnbd-clt.c       |  2 +-
Acked-by: Jack Wang <jinpu.wang@ionos.com> # for rnbd
