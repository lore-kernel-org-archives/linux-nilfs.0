From: Jinpu Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 24/31] rnbd-srv: replace sess->open_flags with a "bool readonly"
Date: Wed, 7 Jun 2023 11:43:28 +0200
Message-ID: <CAMGffEnM-XmQWjBu8EmXxFPouH9uQX45gL2PFW5vQJu5OaaYjA@mail.gmail.com>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-25-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1686131019; x=1688723019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7De2dV56C4HlWldqRhiqrthNBSi3YmqE+PsGIwemH4=;
        b=Fxs73X18plukFoRmWCEATURAToiPof++AhV2rd1/T2MKXGmjDCPWn+q8ZXibWIJoCl
         fHfu9DBj0R01NVvwasXQiY0lKT1FhoYR2X+c5jE2FnzXFR9NQ6iXute09sA4dYi5/gck
         psOWHas6uKWqFB5zNcQ7IrWLWew12mqmJwAS2YNr2ADMxS+LziF4JcFGcR/G6Q7NeZ7C
         gnc9umHxHhpwxSNb/FTgvTAZTX6T0jxAAcpIFEs4lHfCZdM6nb4VJD4c8dc11CL9vYmB
         PP/GUtutiKFcuL2dMJlAWegEn3D5UBxmkW546B+kzx0X64ETqnOp9+wz6iaKHcNDX6z+
         mItQ==
In-Reply-To: <20230606073950.225178-25-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs

On Tue, Jun 6, 2023 at 9:41=E2=80=AFAM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote=
:
>
> Stop passing the fmode_t around and just use a simple bool to track if
> an export is read-only.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/block/rnbd/rnbd-srv-sysfs.c |  3 +--
>  drivers/block/rnbd/rnbd-srv.c       | 15 +++++++--------
>  drivers/block/rnbd/rnbd-srv.h       |  2 +-
>  3 files changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/block/rnbd/rnbd-srv-sysfs.c b/drivers/block/rnbd/rnb=
d-srv-sysfs.c
> index d5d9267e1fa5e4..ebd95771c85ec7 100644
> --- a/drivers/block/rnbd/rnbd-srv-sysfs.c
> +++ b/drivers/block/rnbd/rnbd-srv-sysfs.c
> @@ -88,8 +88,7 @@ static ssize_t read_only_show(struct kobject *kobj, str=
uct kobj_attribute *attr,
>
>         sess_dev =3D container_of(kobj, struct rnbd_srv_sess_dev, kobj);
>
> -       return sysfs_emit(page, "%d\n",
> -                         !(sess_dev->open_flags & FMODE_WRITE));
> +       return sysfs_emit(page, "%d\n", sess_dev->readonly);
>  }
>
>  static struct kobj_attribute rnbd_srv_dev_session_ro_attr =3D
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.=
c
> index 29d560472d05ba..b680071342b898 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -222,7 +222,7 @@ void rnbd_destroy_sess_dev(struct rnbd_srv_sess_dev *=
sess_dev, bool keep_id)
>         blkdev_put(sess_dev->bdev, NULL);
>         mutex_lock(&sess_dev->dev->lock);
>         list_del(&sess_dev->dev_list);
> -       if (sess_dev->open_flags & FMODE_WRITE)
> +       if (!sess_dev->readonly)
>                 sess_dev->dev->open_write_cnt--;
>         mutex_unlock(&sess_dev->dev->lock);
>
> @@ -561,7 +561,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_ms=
g_open_rsp *rsp,
>  static struct rnbd_srv_sess_dev *
>  rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
>                               const struct rnbd_msg_open *open_msg,
> -                             struct block_device *bdev, fmode_t open_fla=
gs,
> +                             struct block_device *bdev, bool readonly,
>                               struct rnbd_srv_dev *srv_dev)
>  {
>         struct rnbd_srv_sess_dev *sdev =3D rnbd_sess_dev_alloc(srv_sess);
> @@ -576,7 +576,7 @@ rnbd_srv_create_set_sess_dev(struct rnbd_srv_session =
*srv_sess,
>         sdev->bdev              =3D bdev;
>         sdev->sess              =3D srv_sess;
>         sdev->dev               =3D srv_dev;
> -       sdev->open_flags        =3D open_flags;
> +       sdev->readonly          =3D readonly;
>         sdev->access_mode       =3D open_msg->access_mode;
>
>         return sdev;
> @@ -681,13 +681,12 @@ static int process_msg_open(struct rnbd_srv_session=
 *srv_sess,
>         struct rnbd_srv_sess_dev *srv_sess_dev;
>         const struct rnbd_msg_open *open_msg =3D msg;
>         struct block_device *bdev;
> -       fmode_t open_flags;
> +       fmode_t open_flags =3D FMODE_READ;
>         char *full_path;
>         struct rnbd_msg_open_rsp *rsp =3D data;
>
>         trace_process_msg_open(srv_sess, open_msg);
>
> -       open_flags =3D FMODE_READ;
>         if (open_msg->access_mode !=3D RNBD_ACCESS_RO)
>                 open_flags |=3D FMODE_WRITE;
>
> @@ -736,9 +735,9 @@ static int process_msg_open(struct rnbd_srv_session *=
srv_sess,
>                 goto blkdev_put;
>         }
>
> -       srv_sess_dev =3D rnbd_srv_create_set_sess_dev(srv_sess, open_msg,
> -                                                    bdev, open_flags,
> -                                                    srv_dev);
> +       srv_sess_dev =3D rnbd_srv_create_set_sess_dev(srv_sess, open_msg,=
 bdev,
> +                               open_msg->access_mode =3D=3D RNBD_ACCESS_=
RO,
> +                               srv_dev);
>         if (IS_ERR(srv_sess_dev)) {
>                 pr_err("Opening device '%s' on session %s failed, creatin=
g sess_dev failed, err: %ld\n",
>                        full_path, srv_sess->sessname, PTR_ERR(srv_sess_de=
v));
> diff --git a/drivers/block/rnbd/rnbd-srv.h b/drivers/block/rnbd/rnbd-srv.=
h
> index f5962fd31d62e4..76077a9db3dd55 100644
> --- a/drivers/block/rnbd/rnbd-srv.h
> +++ b/drivers/block/rnbd/rnbd-srv.h
> @@ -52,7 +52,7 @@ struct rnbd_srv_sess_dev {
>         struct kobject                  kobj;
>         u32                             device_id;
>         bool                            keep_id;
> -       fmode_t                         open_flags;
> +       bool                            readonly;
>         struct kref                     kref;
>         struct completion               *destroy_comp;
>         char                            pathname[NAME_MAX];
> --
> 2.39.2
>
