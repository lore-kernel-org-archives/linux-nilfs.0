From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH 04/11] fuse: remove reliance on bdi congestion
Date: Tue, 1 Mar 2022 14:27:33 +0100
Message-ID: <CAJfpegsGOFD46KM8pxFAemokv9OOsCSHk=ag6jZZ=VscijMXZQ@mail.gmail.com>
References: <164549971112.9187.16871723439770288255.stgit@noble.brown> <164549983737.9187.2627117501000365074.stgit@noble.brown>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0rqEHtyUvKInY3eDADJFtpu+gdfZq4axYpoJEFqNG8M=;
        b=I2qodJt4VEaNZJyZteahkXLrk3gcBP6spDM9mba7O5eU1RB0noMF3SaBN+E8vfdw3Y
         GW1Qja0562jHy97CnNHFiAvEnhDIzFZuk2nVuHxePbR8HX9rviCDiIna9neO0UiGoLDn
         jsXu+RAKBdy7qxqlxo03hClTY9xe+rR+zNfDg=
In-Reply-To: <164549983737.9187.2627117501000365074.stgit-KMjKAoDPBoBHWa5fdsenEw@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmnfLDRD5uJR0wg@public.gmane.org

On Tue, 22 Feb 2022 at 04:18, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
>
> The bdi congestion tracking in not widely used and will be removed.
>
> Fuse is one of a small number of filesystems that uses it, setting both
> the sync (read) and async (write) congestion flags at what it determines
> are appropriate times.
>
> The only remaining effect of the sync flag is to cause read-ahead to be
> skipped.
> The only remaining effect of the async flag is to cause (some)
> WB_SYNC_NONE writes to be skipped.
>
> So instead of setting the flags, change:
>  - .readahead to stop when it has submitted all non-async pages
>     for read.
>  - .writepages to do nothing if WB_SYNC_NONE and the flag would be set
>  - .writepage to return AOP_WRITEPAGE_ACTIVATE if WB_SYNC_NONE
>     and the flag would be set.
>
> The writepages change causes a behavioural change in that pageout() can
> now return PAGE_ACTIVATE instead of PAGE_KEEP, so SetPageActive() will
> be called on the page which (I think) will further delay the next attempt
> at writeout.  This might be a good thing.
>
> Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/fuse/control.c |   17 -----------------
>  fs/fuse/dev.c     |    8 --------
>  fs/fuse/file.c    |   17 +++++++++++++++++
>  3 files changed, 17 insertions(+), 25 deletions(-)
>
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 000d2e5627e9..7cede9a3bc96 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -164,7 +164,6 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
>  {
>         unsigned val;
>         struct fuse_conn *fc;
> -       struct fuse_mount *fm;
>         ssize_t ret;
>
>         ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
> @@ -178,22 +177,6 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
>         down_read(&fc->killsb);
>         spin_lock(&fc->bg_lock);
>         fc->congestion_threshold = val;
> -
> -       /*
> -        * Get any fuse_mount belonging to this fuse_conn; s_bdi is
> -        * shared between all of them
> -        */
> -
> -       if (!list_empty(&fc->mounts)) {
> -               fm = list_first_entry(&fc->mounts, struct fuse_mount, fc_entry);
> -               if (fc->num_background < fc->congestion_threshold) {
> -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> -               } else {
> -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> -               }
> -       }
>         spin_unlock(&fc->bg_lock);
>         up_read(&fc->killsb);
>         fuse_conn_put(fc);
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index cd54a529460d..e1b4a846c90d 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -315,10 +315,6 @@ void fuse_request_end(struct fuse_req *req)
>                                 wake_up(&fc->blocked_waitq);
>                 }
>
> -               if (fc->num_background == fc->congestion_threshold && fm->sb) {
> -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> -               }
>                 fc->num_background--;
>                 fc->active_background--;
>                 flush_bg_queue(fc);
> @@ -540,10 +536,6 @@ static bool fuse_request_queue_background(struct fuse_req *req)
>                 fc->num_background++;
>                 if (fc->num_background == fc->max_background)
>                         fc->blocked = 1;
> -               if (fc->num_background == fc->congestion_threshold && fm->sb) {
> -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> -               }
>                 list_add_tail(&req->list, &fc->bg_queue);
>                 flush_bg_queue(fc);
>                 queued = true;
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 829094451774..94747bac3489 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -966,6 +966,14 @@ static void fuse_readahead(struct readahead_control *rac)
>                 struct fuse_io_args *ia;
>                 struct fuse_args_pages *ap;
>
> +               if (fc->num_background >= fc->congestion_threshold &&
> +                   rac->ra->async_size >= readahead_count(rac))
> +                       /*
> +                        * Congested and only async pages left, so skip the
> +                        * rest.
> +                        */
> +                       break;

Ah, you are taking care of it here...

Regarding the async part: a potential (corner?) case is if task A is
reading region X and triggering readahead for region Y and at the same
time task B is reading region Y.  In the congestion case it can happen
that non-uptodate pages in Y are truncated off the pagecache while B
is waiting for them to become uptodate.

This shouldn't be too hard to trigger, just need two sequential
readers of the same file, where one is just ahead of the other.  I'll
try to do a test program for this case specifically.

Thanks,
Miklos
