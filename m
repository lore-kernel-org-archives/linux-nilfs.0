From: Jinpu Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 14/31] rnbd-srv: don't pass a holder for non-exclusive blkdev_get_by_path
Date: Wed, 7 Jun 2023 11:38:27 +0200
Message-ID: <CAMGffEk8Zex5+u69YW9AXGQh-ch79mw7=Gn3L1M=qwvZCVa5VA@mail.gmail.com>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-15-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1686130719; x=1688722719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjKWGYzTLmxl6ndmaqY1vhf0MYCxKeiBaM5D6TZOn9k=;
        b=YXuPeKYHXY8x573VqT+WBt2/3c0ykgaHJuCFCznCBd9Wetpo4vgup6yqqURCu0byaA
         Z/WQU4wI1a6QCL47tLiZRI6KTt32VZU/qDKhKKJKLQFyY7AmMCGDwrGB1pizVTFQERU7
         t/x6PD6wstNl8G+Np+qAroVsRlq5DhK6VHOceLAS64dGk9Gj3fcvwZo0Y8lemLlMRb9N
         lmkimh7iJEnOSo+NJeMchGTnQhFoj8noYEGMLBj46T+S0Fm4jsdixCjB8sRTniHot4zo
         HY10z3v3++4U48Fj0kZDnrEgImtyRX0sgkHyTWWoWMiMmGGRFIMZm1Lm0qh585DtYYsI
         wCGA==
In-Reply-To: <20230606073950.225178-15-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs

On Tue, Jun 6, 2023 at 9:40=E2=80=AFAM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote=
:
>
> Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
> make sense, so pass NULL instead.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/block/rnbd/rnbd-srv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.=
c
> index cec22bbae2f9a5..ce505e552f4d50 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -719,7 +719,7 @@ static int process_msg_open(struct rnbd_srv_session *=
srv_sess,
>                 goto reject;
>         }
>
> -       bdev =3D blkdev_get_by_path(full_path, open_flags, THIS_MODULE, N=
ULL);
> +       bdev =3D blkdev_get_by_path(full_path, open_flags, NULL, NULL);
>         if (IS_ERR(bdev)) {
>                 ret =3D PTR_ERR(bdev);
>                 pr_err("Opening device '%s' on session %s failed, failed =
to open the block device, err: %d\n",
> --
> 2.39.2
>
