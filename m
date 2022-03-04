From: "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 04/11] fuse: remove reliance on bdi congestion
Date: Fri, 04 Mar 2022 13:42:29 +1100
Message-ID: <164636174972.29369.5216919060965840586@noble.neil.brown.name>
References: <164549971112.9187.16871723439770288255.stgit@noble.brown>,
	<164549983737.9187.2627117501000365074.stgit@noble.brown>,
	<CAJfpegsGOFD46KM8pxFAemokv9OOsCSHk=ag6jZZ=VscijMXZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646361759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=E1LSsS3hFazVJuoQhofGl3WFIJIfnvw/hjoFnxzGa8Q=;
	b=kSHYevnIlEV/nAB3Xb2sRoUgVahgqrrLpnNU/rj78jXyCzqgxhJIIbDb3QEvOcrMP7LvDe
	4NFc1B3zwex4VffmlBHljE0pG1V6JbHvSSVwiwwVFrzzno61GNqQ0x09zyG9WYl/60C2Qy
	uRIUO2cQUjcdNbPtqxxoPSK3oNfH6hk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646361759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=E1LSsS3hFazVJuoQhofGl3WFIJIfnvw/hjoFnxzGa8Q=;
	b=A/VT+8oYrZEqs09lFC8Pz065G6GP0zURBYxKKH1zgKh4n8fEz30Rkylz0nWBpbCLzoPCy5
	SnbxIVcZ29yF5KDQ==
In-reply-to: <CAJfpegsGOFD46KM8pxFAemokv9OOsCSHk=ag6jZZ=VscijMXZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux NFS list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anna Schumaker <anna.sch>

On Wed, 02 Mar 2022, Miklos Szeredi wrote:
> On Tue, 22 Feb 2022 at 04:18, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> >
> > The bdi congestion tracking in not widely used and will be removed.
> >
> > Fuse is one of a small number of filesystems that uses it, setting both
> > the sync (read) and async (write) congestion flags at what it determines
> > are appropriate times.
> >
> > The only remaining effect of the sync flag is to cause read-ahead to be
> > skipped.
> > The only remaining effect of the async flag is to cause (some)
> > WB_SYNC_NONE writes to be skipped.
> >
> > So instead of setting the flags, change:
> >  - .readahead to stop when it has submitted all non-async pages
> >     for read.
> >  - .writepages to do nothing if WB_SYNC_NONE and the flag would be set
> >  - .writepage to return AOP_WRITEPAGE_ACTIVATE if WB_SYNC_NONE
> >     and the flag would be set.
> >
> > The writepages change causes a behavioural change in that pageout() can
> > now return PAGE_ACTIVATE instead of PAGE_KEEP, so SetPageActive() will
> > be called on the page which (I think) will further delay the next attempt
> > at writeout.  This might be a good thing.
> >
> > Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> > ---
> >  fs/fuse/control.c |   17 -----------------
> >  fs/fuse/dev.c     |    8 --------
> >  fs/fuse/file.c    |   17 +++++++++++++++++
> >  3 files changed, 17 insertions(+), 25 deletions(-)
> >
> > diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> > index 000d2e5627e9..7cede9a3bc96 100644
> > --- a/fs/fuse/control.c
> > +++ b/fs/fuse/control.c
> > @@ -164,7 +164,6 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
> >  {
> >         unsigned val;
> >         struct fuse_conn *fc;
> > -       struct fuse_mount *fm;
> >         ssize_t ret;
> >
> >         ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
> > @@ -178,22 +177,6 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
> >         down_read(&fc->killsb);
> >         spin_lock(&fc->bg_lock);
> >         fc->congestion_threshold = val;
> > -
> > -       /*
> > -        * Get any fuse_mount belonging to this fuse_conn; s_bdi is
> > -        * shared between all of them
> > -        */
> > -
> > -       if (!list_empty(&fc->mounts)) {
> > -               fm = list_first_entry(&fc->mounts, struct fuse_mount, fc_entry);
> > -               if (fc->num_background < fc->congestion_threshold) {
> > -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> > -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> > -               } else {
> > -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> > -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> > -               }
> > -       }
> >         spin_unlock(&fc->bg_lock);
> >         up_read(&fc->killsb);
> >         fuse_conn_put(fc);
> > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > index cd54a529460d..e1b4a846c90d 100644
> > --- a/fs/fuse/dev.c
> > +++ b/fs/fuse/dev.c
> > @@ -315,10 +315,6 @@ void fuse_request_end(struct fuse_req *req)
> >                                 wake_up(&fc->blocked_waitq);
> >                 }
> >
> > -               if (fc->num_background == fc->congestion_threshold && fm->sb) {
> > -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> > -                       clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> > -               }
> >                 fc->num_background--;
> >                 fc->active_background--;
> >                 flush_bg_queue(fc);
> > @@ -540,10 +536,6 @@ static bool fuse_request_queue_background(struct fuse_req *req)
> >                 fc->num_background++;
> >                 if (fc->num_background == fc->max_background)
> >                         fc->blocked = 1;
> > -               if (fc->num_background == fc->congestion_threshold && fm->sb) {
> > -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
> > -                       set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
> > -               }
> >                 list_add_tail(&req->list, &fc->bg_queue);
> >                 flush_bg_queue(fc);
> >                 queued = true;
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 829094451774..94747bac3489 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -966,6 +966,14 @@ static void fuse_readahead(struct readahead_control *rac)
> >                 struct fuse_io_args *ia;
> >                 struct fuse_args_pages *ap;
> >
> > +               if (fc->num_background >= fc->congestion_threshold &&
> > +                   rac->ra->async_size >= readahead_count(rac))
> > +                       /*
> > +                        * Congested and only async pages left, so skip the
> > +                        * rest.
> > +                        */
> > +                       break;
> 
> Ah, you are taking care of it here...
> 
> Regarding the async part: a potential (corner?) case is if task A is
> reading region X and triggering readahead for region Y and at the same
> time task B is reading region Y.  In the congestion case it can happen
> that non-uptodate pages in Y are truncated off the pagecache while B
> is waiting for them to become uptodate.

I don't think that is a problem.
If the second reader finds the non-uptodate page that is waiting for
attention from the readahead of the first reader, then it will wait
until the page is unlocked.  Once it gets the lock, it will find that
->mapping is NULL (in the middle of filemap_update_page() for example)
and so will drop the page and try again.
Second time around (in e.g. filemap_get_pages()) it will find that there
is no page, and so will call pagE_cache_sync_readahead() which allocates
some pages as appropriate and calls ->readahead() on them.

It might be best for the discarding of pages to having in reverse index
order so that there is no risk of waiting and retrying a series of
times, but I suspect that wouldn't happen very often.

> 
> This shouldn't be too hard to trigger, just need two sequential
> readers of the same file, where one is just ahead of the other.  I'll
> try to do a test program for this case specifically.

Thanks - I'd love to hear of any test results you can produce.

Thanks,
NeilBrown
