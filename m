From: Jinpu Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/19] rnbd-srv: remove struct rnbd_dev_blk_io
Date: Mon, 24 Jan 2022 22:07:26 +0100
Message-ID: <CAMGffEknV3j8nm__Bc_q7QUra+MV2kj-CMcq8O2ZdEK+B3om_Q@mail.gmail.com>
References: <20220124091107.642561-1-hch@lst.de>
	<20220124091107.642561-12-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ionos.com; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=ePWzg4KksjRUDSjqr+o9tEK0DbR7L8NzVM+5lIUlDPo=;
	b=UryOzKtTd2BAlxPDRNgCwCESf13lD5IW6bNOSpBDepFbuH7r9fjbsT6cE5x5Ghft6m
	mvPNVWtkz01mVJrSqeC/gB7JTH8T6qFvFS/VnIIFZHW5/gP/sOhhcnNoyYhFzrPdUaVF
	FvDL8M4vNuURIqj/n/AdjkvXl39lYlpRohMIl+wO54x442N5Kx3ijGlQ972NHhWQkaPM
	2PB2Ht3BymPWofX9NOCMsDhYcC+73YD1E+ldRp1Zbpzgc9ITLFFrLh5PDvAi6v8hFREw
	ZBIZaScnPoiVR8zI3lCx6RkrB7DD23Vmu/ZR3nC2SK8GmSX6IQ39leUg3dHZiL44CE+y
	QY2Q==
In-Reply-To: <20220124091107.642561-12-hch-jcswGhMUV9g@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Md . Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

On Mon, Jan 24, 2022 at 10:11 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> Only the priv field of rnbd_dev_blk_io is used, so store the value of
> that in bio->bi_private directly and remove the entire bio_set overhead.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
Thanks!
> ---
>  drivers/block/rnbd/rnbd-srv-dev.c |  4 +---
>  drivers/block/rnbd/rnbd-srv-dev.h | 13 ++-----------
>  drivers/block/rnbd/rnbd-srv.c     | 27 ++++-----------------------
>  drivers/block/rnbd/rnbd-srv.h     |  1 -
>  4 files changed, 7 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/block/rnbd/rnbd-srv-dev.c b/drivers/block/rnbd/rnbd-srv-dev.c
> index 98d3e591a0885..c5d0a03911659 100644
> --- a/drivers/block/rnbd/rnbd-srv-dev.c
> +++ b/drivers/block/rnbd/rnbd-srv-dev.c
> @@ -12,8 +12,7 @@
>  #include "rnbd-srv-dev.h"
>  #include "rnbd-log.h"
>
> -struct rnbd_dev *rnbd_dev_open(const char *path, fmode_t flags,
> -                              struct bio_set *bs)
> +struct rnbd_dev *rnbd_dev_open(const char *path, fmode_t flags)
>  {
>         struct rnbd_dev *dev;
>         int ret;
> @@ -30,7 +29,6 @@ struct rnbd_dev *rnbd_dev_open(const char *path, fmode_t flags,
>
>         dev->blk_open_flags = flags;
>         bdevname(dev->bdev, dev->name);
> -       dev->ibd_bio_set = bs;
>
>         return dev;
>
> diff --git a/drivers/block/rnbd/rnbd-srv-dev.h b/drivers/block/rnbd/rnbd-srv-dev.h
> index 1a14ece0be726..2c3df02b5e8ec 100644
> --- a/drivers/block/rnbd/rnbd-srv-dev.h
> +++ b/drivers/block/rnbd/rnbd-srv-dev.h
> @@ -14,25 +14,16 @@
>
>  struct rnbd_dev {
>         struct block_device     *bdev;
> -       struct bio_set          *ibd_bio_set;
>         fmode_t                 blk_open_flags;
>         char                    name[BDEVNAME_SIZE];
>  };
>
> -struct rnbd_dev_blk_io {
> -       struct rnbd_dev *dev;
> -       void             *priv;
> -       /* have to be last member for front_pad usage of bioset_init */
> -       struct bio      bio;
> -};
> -
>  /**
>   * rnbd_dev_open() - Open a device
> + * @path:      path to open
>   * @flags:     open flags
> - * @bs:                bio_set to use during block io,
>   */
> -struct rnbd_dev *rnbd_dev_open(const char *path, fmode_t flags,
> -                              struct bio_set *bs);
> +struct rnbd_dev *rnbd_dev_open(const char *path, fmode_t flags);
>
>  /**
>   * rnbd_dev_close() - Close a device
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
> index 6d228af1dcc35..ff9b389976078 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -116,9 +116,7 @@ rnbd_get_sess_dev(int dev_id, struct rnbd_srv_session *srv_sess)
>
>  static void rnbd_dev_bi_end_io(struct bio *bio)
>  {
> -       struct rnbd_dev_blk_io *io = bio->bi_private;
> -
> -       rnbd_endio(io->priv, blk_status_to_errno(bio->bi_status));
> +       rnbd_endio(bio->bi_private, blk_status_to_errno(bio->bi_status));
>         bio_put(bio);
>  }
>
> @@ -131,7 +129,6 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
>         struct rnbd_srv_sess_dev *sess_dev;
>         u32 dev_id;
>         int err;
> -       struct rnbd_dev_blk_io *io;
>         struct bio *bio;
>         short prio;
>
> @@ -152,7 +149,7 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
>         priv->sess_dev = sess_dev;
>         priv->id = id;
>
> -       bio = bio_alloc_bioset(GFP_KERNEL, 1, sess_dev->rnbd_dev->ibd_bio_set);
> +       bio = bio_alloc(GFP_KERNEL, 1);
>         if (bio_add_page(bio, virt_to_page(data), datalen,
>                         offset_in_page(data)) != datalen) {
>                 rnbd_srv_err(sess_dev, "Failed to map data to bio\n");
> @@ -160,12 +157,8 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
>                 goto bio_put;
>         }
>
> -       io = container_of(bio, struct rnbd_dev_blk_io, bio);
> -       io->dev = sess_dev->rnbd_dev;
> -       io->priv = priv;
> -
>         bio->bi_end_io = rnbd_dev_bi_end_io;
> -       bio->bi_private = io;
> +       bio->bi_private = priv;
>         bio->bi_opf = rnbd_to_bio_flags(le32_to_cpu(msg->rw));
>         bio->bi_iter.bi_sector = le64_to_cpu(msg->sector);
>         bio->bi_iter.bi_size = le32_to_cpu(msg->bi_size);
> @@ -260,7 +253,6 @@ static void destroy_sess(struct rnbd_srv_session *srv_sess)
>
>  out:
>         xa_destroy(&srv_sess->index_idr);
> -       bioset_exit(&srv_sess->sess_bio_set);
>
>         pr_info("RTRS Session %s disconnected\n", srv_sess->sessname);
>
> @@ -289,16 +281,6 @@ static int create_sess(struct rtrs_srv_sess *rtrs)
>                 return -ENOMEM;
>
>         srv_sess->queue_depth = rtrs_srv_get_queue_depth(rtrs);
> -       err = bioset_init(&srv_sess->sess_bio_set, srv_sess->queue_depth,
> -                         offsetof(struct rnbd_dev_blk_io, bio),
> -                         BIOSET_NEED_BVECS);
> -       if (err) {
> -               pr_err("Allocating srv_session for path %s failed\n",
> -                      pathname);
> -               kfree(srv_sess);
> -               return err;
> -       }
> -
>         xa_init_flags(&srv_sess->index_idr, XA_FLAGS_ALLOC);
>         INIT_LIST_HEAD(&srv_sess->sess_dev_list);
>         mutex_init(&srv_sess->lock);
> @@ -747,8 +729,7 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
>                 goto reject;
>         }
>
> -       rnbd_dev = rnbd_dev_open(full_path, open_flags,
> -                                &srv_sess->sess_bio_set);
> +       rnbd_dev = rnbd_dev_open(full_path, open_flags);
>         if (IS_ERR(rnbd_dev)) {
>                 pr_err("Opening device '%s' on session %s failed, failed to open the block device, err: %ld\n",
>                        full_path, srv_sess->sessname, PTR_ERR(rnbd_dev));
> diff --git a/drivers/block/rnbd/rnbd-srv.h b/drivers/block/rnbd/rnbd-srv.h
> index e5604bce123ab..be2ae486d407e 100644
> --- a/drivers/block/rnbd/rnbd-srv.h
> +++ b/drivers/block/rnbd/rnbd-srv.h
> @@ -23,7 +23,6 @@ struct rnbd_srv_session {
>         struct rtrs_srv_sess    *rtrs;
>         char                    sessname[NAME_MAX];
>         int                     queue_depth;
> -       struct bio_set          sess_bio_set;
>
>         struct xarray           index_idr;
>         /* List of struct rnbd_srv_sess_dev */
> --
> 2.30.2
>
