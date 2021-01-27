From: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 13/17] md: remove md_bio_alloc_sync
Date: Tue, 26 Jan 2021 23:22:46 -0800
Message-ID: <CAPhsuW4AViTNjq1mp6zvbEJ8zKdK7__BfXEsvATTBWraK2u1Jg@mail.gmail.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-14-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1611732179;
	bh=wys3sZM3KFLi7kSDIT+8OH9R8Mzfn9WfVwnN3287ktM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Bec44/no8t56Z502LgnlM+Qg3a7iRfwb8LyhJ+o5g82IaOznb97Gk8xlDwtFm7y0Q
	4B+/tC5K9lGgUBiHyhE00pi36rFGRQbfNmoExpX38MvaaIEiIlo5Xpl02zb3d2+c9I
	6QT/NDPMg5Mj36lJBF9f+RFUcTIY2MmljvRbc0DiIULgDdoXmR4KXliM+gH3VlyPk6
	mHWoOAExmkNvS6m/z6G7b4ZdKBJLDixAbo/Wzlpm3cgdfJxA927Fy/aSbJhFzA/wq4
	2ciHhZnN+TzrdwTTB4DOYnCFwWnsw1IL4QMJJGrVzDQalyZsi3zFFnOCUMa/DMqtOX
	AkooKL+eqRW2g==
In-Reply-To: <20210126145247.1964410-14-hch-jcswGhMUV9g@public.gmane.org>
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

On Tue, Jan 26, 2021 at 7:17 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> md_bio_alloc_sync is never called with a NULL mddev, and ->sync_set is
> initialized in md_run, so it always must be initialized as well.  Just
> open code the remaining call to bio_alloc_bioset.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ---
>  drivers/md/md.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6a27f52007c871..399c81bddc1ae1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -340,14 +340,6 @@ static int start_readonly;
>   */
>  static bool create_on_open = true;
>
> -static struct bio *md_bio_alloc_sync(struct mddev *mddev)
> -{
> -       if (!mddev || !bioset_initialized(&mddev->sync_set))
> -               return bio_alloc(GFP_NOIO, 1);
> -
> -       return bio_alloc_bioset(GFP_NOIO, 1, &mddev->sync_set);
> -}
> -
>  /*
>   * We have a system wide 'event count' that is incremented
>   * on any 'interesting' event, and readers of /proc/mdstat
> @@ -989,7 +981,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>         if (test_bit(Faulty, &rdev->flags))
>                 return;
>
> -       bio = md_bio_alloc_sync(mddev);
> +       bio = bio_alloc_bioset(GFP_NOIO, 1, &mddev->sync_set);
>
>         atomic_inc(&rdev->nr_pending);
>
> --
> 2.29.2
>
