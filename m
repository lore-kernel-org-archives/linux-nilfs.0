From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 25/31] ubd: remove commented out code in ubd_open
Date: Tue, 6 Jun 2023 10:20:46 +0200 (CEST)
Message-ID: <766259639.3687124.1686039646763.JavaMail.zimbra@nod.at>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-26-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20230606073950.225178-26-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: hch <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel <dm-devel@redhat.com>, linux-block <linux-block@vger.kernel.org>, linux-um <linux-um@lists.infradead.org>, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd <linux-mtd@lists.infradead.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "hch" <hch@lst.de>
> This code has been dead forever, make sure it doesn't show up in code
> searches.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> arch/um/drivers/ubd_kern.c | 7 -------
> 1 file changed, 7 deletions(-)
>=20
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index 8b79554968addb..20c1a16199c503 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -1170,13 +1170,6 @@ static int ubd_open(struct gendisk *disk, fmode_t =
mode)
> 	}
> 	ubd_dev->count++;
> 	set_disk_ro(disk, !ubd_dev->openflags.w);
> -
> -	/* This should no more be needed. And it didn't work anyway to exclude
> -	 * read-write remounting of filesystems.*/
> -	/*if((mode & FMODE_WRITE) && !ubd_dev->openflags.w){
> -	        if(--ubd_dev->count =3D=3D 0) ubd_close_dev(ubd_dev);
> -	        err =3D -EROFS;
> -	}*/

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
