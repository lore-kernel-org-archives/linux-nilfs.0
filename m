From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 11/30] swsusp: don't pass a stack address to blkdev_get_by_path
Date: Fri, 9 Jun 2023 20:13:23 +0200
Message-ID: <CAJZ5v0h61q6=JxjeUjjMz5k05HuRGWVKp_rK+9N8rug58kU_VQ@mail.gmail.com>
References: <20230608110258.189493-1-hch@lst.de> <20230608110258.189493-12-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20230608110258.189493-12-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvm

On Thu, Jun 8, 2023 at 1:03=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrote:
>
> holder is just an on-stack pointer that can easily be reused by other cal=
ls,
> replace it with a static variable that doesn't change.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>  kernel/power/swap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 81aec3b2c60510..b03ff1a33c7f68 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -1510,6 +1510,8 @@ int swsusp_read(unsigned int *flags_p)
>         return error;
>  }
>
> +static void *swsusp_holder;
> +
>  /**
>   *      swsusp_check - Check for swsusp signature in the resume device
>   */
> @@ -1517,14 +1519,13 @@ int swsusp_read(unsigned int *flags_p)
>  int swsusp_check(bool snapshot_test)
>  {
>         int error;
> -       void *holder;
>         fmode_t mode =3D FMODE_READ;
>
>         if (snapshot_test)
>                 mode |=3D FMODE_EXCL;
>
>         hib_resume_bdev =3D blkdev_get_by_dev(swsusp_resume_device,
> -                                           mode, &holder, NULL);
> +                                           mode, &swsusp_holder, NULL);
>         if (!IS_ERR(hib_resume_bdev)) {
>                 set_blocksize(hib_resume_bdev, PAGE_SIZE);
>                 clear_page(swsusp_header);
> --
> 2.39.2
>
