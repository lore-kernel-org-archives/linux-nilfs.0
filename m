From: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/17] md: simplify sync_page_io
Date: Tue, 26 Jan 2021 23:22:01 -0800
Message-ID: <CAPhsuW6sVtB-baGn46_o6NVynuxQfy9_FuhC2ZK0cKu5cQHWDg@mail.gmail.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-13-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1611732134;
	bh=UmXZ4WGct5TD5g2zWBqeUZIY7+IEh1H1mojHQndD4p0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oDBiPqUDddARVPP8esIP80QkXjEj9+85T5QDZeh7nu2cYyt+eQZA8QDXikjpMwlat
	MNfPUAT8hEpYvyQzrx6AP5DR+ANmDLKNYdk+3I1Le4ClABg804A6YrqVAha+HDnXt3
	aXXje54ZXGe396yLREjvTO7F28tQlsy1EwE9vIS6460xIuuh3AzToqKFH1MkXqxaCP
	/NJx/3JofqwPazejWSqyqiZGHT+4SBSDqNllnI/Q9rYdu+otPvNjz6i73xOtGWI2Ql
	1f8AcHX5BqzHDL4QaB+j75p6mcXxGRjds0fAREsI+L/1LEC6UF0JYg2RbF8i9aAb9k
	jpAFtWZcqE2ig==
In-Reply-To: <20210126145247.1964410-13-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Damien Le Moal <damien.lemoal-Sjgp3cTcYWE@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 26, 2021 at 7:14 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> Use an on-stack bio and biovec for the single page synchronous I/O.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ---
>  drivers/md/md.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e2b9dbb6e888f6..6a27f52007c871 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1021,29 +1021,29 @@ int md_super_wait(struct mddev *mddev)
>  int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>                  struct page *page, int op, int op_flags, bool metadata_op)
>  {
> -       struct bio *bio = md_bio_alloc_sync(rdev->mddev);
> -       int ret;
> +       struct bio bio;
> +       struct bio_vec bvec;
> +
> +       bio_init(&bio, &bvec, 1);
>
>         if (metadata_op && rdev->meta_bdev)
> -               bio_set_dev(bio, rdev->meta_bdev);
> +               bio_set_dev(&bio, rdev->meta_bdev);
>         else
> -               bio_set_dev(bio, rdev->bdev);
> -       bio_set_op_attrs(bio, op, op_flags);
> +               bio_set_dev(&bio, rdev->bdev);
> +       bio.bi_opf = op | op_flags;
>         if (metadata_op)
> -               bio->bi_iter.bi_sector = sector + rdev->sb_start;
> +               bio.bi_iter.bi_sector = sector + rdev->sb_start;
>         else if (rdev->mddev->reshape_position != MaxSector &&
>                  (rdev->mddev->reshape_backwards ==
>                   (sector >= rdev->mddev->reshape_position)))
> -               bio->bi_iter.bi_sector = sector + rdev->new_data_offset;
> +               bio.bi_iter.bi_sector = sector + rdev->new_data_offset;
>         else
> -               bio->bi_iter.bi_sector = sector + rdev->data_offset;
> -       bio_add_page(bio, page, size, 0);
> +               bio.bi_iter.bi_sector = sector + rdev->data_offset;
> +       bio_add_page(&bio, page, size, 0);
>
> -       submit_bio_wait(bio);
> +       submit_bio_wait(&bio);
>
> -       ret = !bio->bi_status;
> -       bio_put(bio);
> -       return ret;
> +       return !bio.bi_status;
>  }
>  EXPORT_SYMBOL_GPL(sync_page_io);
>
> --
> 2.29.2
>
