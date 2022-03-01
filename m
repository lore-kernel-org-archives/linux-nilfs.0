From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH 03/11] MM: improve cleanup when ->readpages
 doesn't process all pages.
Date: Tue, 1 Mar 2022 14:00:24 +0100
Message-ID: <CAJfpegs=DhCO62EFV0Q_i2fmqJnziJy1t4itP9deS=FuWEA=TQ@mail.gmail.com>
References: <164549971112.9187.16871723439770288255.stgit@noble.brown>
	<164549983736.9187.16755913785880819183.stgit@noble.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=QG2k2eItwE4VAk3PGGex6QHZy3T0xaD3lTCoY/HpYco=;
	b=ZQjeLrdHbWEck4K6RpeBY4QI1uE5CcoVwO5sZTKvbH0jCtE/epL+AV1J2T6nTvQB7B
	/yPS0KVOUZAhUGfHU54H1jmlgYJUgdfLLmM3xmB3rY9RzzFoWNFI2Zci83Jzu2Okp0E4
	AJRAtv/WKjpa/XnIsui/qXUZ2c4GyPza8OAZk=
In-Reply-To: <164549983736.9187.16755913785880819183.stgit-KMjKAoDPBoBHWa5fdsenEw@public.gmane.org>
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
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux NFS list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anna Schumaker <anna.sch>

On Tue, 22 Feb 2022 at 04:18, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
>
> If ->readpages doesn't process all the pages, then it is best to act as
> though they weren't requested so that a subsequent readahead can try
> again.
> So:
>   - remove any 'ahead' pages from the page cache so they can be loaded
>     with ->readahead() rather then multiple ->read()s
>   - update the file_ra_state to reflect the reads that were actually
>     submitted.
>
> This allows ->readpages() to abort early due e.g.  to congestion, which
> will then allow us to remove the inode_read_congested() test from
> page_Cache_async_ra().
>
> Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> ---
>  mm/readahead.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 73b2bc5302e0..8a97bd408cf6 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -104,7 +104,13 @@
>   * for necessary resources (e.g.  memory or indexing information) to
>   * become available.  Pages in the final ``async_size`` may be
>   * considered less urgent and failure to read them is more acceptable.
> - * They will eventually be read individually using ->readpage().
> + * In this case it is best to use delete_from_page_cache() to remove the
> + * pages from the page cache as is automatically done for pages that
> + * were not fetched with readahead_page().  This will allow a
> + * subsequent synchronous read ahead request to try them again.  If they
> + * are left in the page cache, then they will be read individually using
> + * ->readpage().
> + *
>   */
>
>  #include <linux/kernel.h>
> @@ -226,8 +232,17 @@ static void read_pages(struct readahead_control *rac, struct list_head *pages,
>
>         if (aops->readahead) {
>                 aops->readahead(rac);
> -               /* Clean up the remaining pages */
> +               /*
> +                * Clean up the remaining pages.  The sizes in ->ra
> +                * maybe be used to size next read-ahead, so make sure
> +                * they accurately reflect what happened.
> +                */
>                 while ((page = readahead_page(rac))) {
> +                       rac->ra->size -= 1;
> +                       if (rac->ra->async_size > 0) {
> +                               rac->ra->async_size -= 1;
> +                               delete_from_page_cache(page);
> +                       }

Does the  above imply that filesystem should submit at least ra->size
pages, regardless of congestion?

Thanks,
Miklos
