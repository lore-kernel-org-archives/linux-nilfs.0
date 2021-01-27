From: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/17] md: remove bio_alloc_mddev
Date: Tue, 26 Jan 2021 23:21:16 -0800
Message-ID: <CAPhsuW4SRXoOjfU5GHoOGfONjb1yMT7HEyHLZb4E4vNARF44jw@mail.gmail.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-12-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1611732089;
	bh=PHGvgPZS9fmzb8WwHWTDSJ0PUf4j0hQIB49cA17Ux8M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aOcLULEJAETe0ZlQOMFoWv+xV+961UgFHoRNBzUMPi/oFzrgBLf6fpFTjN/IS05QO
	zYzdqWHKfbJrw60OF8NQxrmzPpTarFG5BYYhXfdM82s2hq4GFbvrBTg0+/gc9t50It
	YL3Oe/Z9JLGMVM5I+aLWcGsKrktoXC5hMjaVZsxS33HhjLk4OG2Duzg5eJzML2qsTX
	SvIigcKxB7d/BjQsPegVpK8LEUO0LIj3aQP1HkoGMEQsssBIbzs2Nv5jASFVBV6Rrv
	RhIZkevlJdJVxgQR3wvBJsdnYdlgcaGm25mcIExHcY0pbsKd4dATwjIkTayV/aOI2P
	9V2GznHJHrLLQ==
In-Reply-To: <20210126145247.1964410-12-hch-jcswGhMUV9g@public.gmane.org>
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

On Tue, Jan 26, 2021 at 7:12 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> bio_alloc_mddev is never called with a NULL mddev, and ->bio_set is
> initialized in md_run, so it always must be initialized as well.  Just
> open code the remaining call to bio_alloc_bioset.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ---
>  drivers/md/md.c     | 12 +-----------
>  drivers/md/md.h     |  2 --
>  drivers/md/raid1.c  |  2 +-
>  drivers/md/raid10.c |  2 +-
>  4 files changed, 3 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7d1bb24add3107..e2b9dbb6e888f6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -340,16 +340,6 @@ static int start_readonly;
>   */
>  static bool create_on_open = true;
>
> -struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
> -                           struct mddev *mddev)
> -{
> -       if (!mddev || !bioset_initialized(&mddev->bio_set))
> -               return bio_alloc(gfp_mask, nr_iovecs);
> -
> -       return bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
> -}
> -EXPORT_SYMBOL_GPL(bio_alloc_mddev);
> -
>  static struct bio *md_bio_alloc_sync(struct mddev *mddev)
>  {
>         if (!mddev || !bioset_initialized(&mddev->sync_set))
> @@ -613,7 +603,7 @@ static void submit_flushes(struct work_struct *ws)
>                         atomic_inc(&rdev->nr_pending);
>                         atomic_inc(&rdev->nr_pending);
>                         rcu_read_unlock();
> -                       bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
> +                       bi = bio_alloc_bioset(GFP_NOIO, 0, &mddev->bio_set);
>                         bi->bi_end_io = md_end_flush;
>                         bi->bi_private = rdev;
>                         bio_set_dev(bi, rdev->bdev);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index f13290ccc1c248..bcbba1b5ec4a71 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -742,8 +742,6 @@ extern void md_rdev_clear(struct md_rdev *rdev);
>  extern void md_handle_request(struct mddev *mddev, struct bio *bio);
>  extern void mddev_suspend(struct mddev *mddev);
>  extern void mddev_resume(struct mddev *mddev);
> -extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
> -                                  struct mddev *mddev);
>
>  extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>  extern void md_update_sb(struct mddev *mddev, int force);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 3b19141cdb4bc2..d2378765dc154f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1104,7 +1104,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
>         int i = 0;
>         struct bio *behind_bio = NULL;
>
> -       behind_bio = bio_alloc_mddev(GFP_NOIO, vcnt, r1_bio->mddev);
> +       behind_bio = bio_alloc_bioset(GFP_NOIO, vcnt, &r1_bio->mddev->bio_set);
>         if (!behind_bio)
>                 return;
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index be8f14afb6d143..e1eefbec15d444 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4531,7 +4531,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
>                 return sectors_done;
>         }
>
> -       read_bio = bio_alloc_mddev(GFP_KERNEL, RESYNC_PAGES, mddev);
> +       read_bio = bio_alloc_bioset(GFP_KERNEL, RESYNC_PAGES, &mddev->bio_set);
>
>         bio_set_dev(read_bio, rdev->bdev);
>         read_bio->bi_iter.bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
> --
> 2.29.2
>
