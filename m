From: "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/9] Remove inode_congested()
Date: Sat, 29 Jan 2022 08:36:02 +1100
Message-ID: <164340576289.5493.5784848964540459557@noble.neil.brown.name>
References: <164325106958.29787.4865219843242892726.stgit@noble.brown>,
	<164325158954.29787.7856652136298668100.stgit@noble.brown>,
	<CAJfpegt-igF8HqsDUcMzfU0jYv8WpofLy0Uv0YnXLzsfx=tkGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1643405774;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=NLILDfYIewMcTAbJZc9mPjKMlBqDlqhTsKM2N1uM+Vw=;
	b=taayjmIQ/dw3pRt7LXMXgV+h3N2iGR9k6iWV1POVgUTfQy7v0b53WKl6W7epBEuQeWPNId
	2nS5W8Zz+JDvOI2H2O325FIcHt7vLtCdfAuhacvrf751M2nGilH84Y1DtEW6P5pWfmkFXk
	3R+tAum3D39BD7myqsYNPl0uf7Iudaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1643405774;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=NLILDfYIewMcTAbJZc9mPjKMlBqDlqhTsKM2N1uM+Vw=;
	b=24PK3VAQmVA51Rx99IGbDGj51tJod8UX27xeq8Emd3IiwsHonr+XB9p01yVh4lqGGFRKKK
	qudbZz9CfGjnNuAQ==
In-reply-to: <CAJfpegt-igF8HqsDUcMzfU0jYv8WpofLy0Uv0YnXLzsfx=tkGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux NFS list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>

On Fri, 28 Jan 2022, Miklos Szeredi wrote:
> On Thu, 27 Jan 2022 at 03:47, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> >
> > inode_congested() reports if the backing-device for the inode is
> > congested.  Few bdi report congestion any more, only ceph, fuse, and
> > nfs.  Having support just for those is unlikely to be useful.
> >
> > The places which test inode_congested() or it variants like
> > inode_write_congested(), avoid initiating IO if congestion is present.
> > We now have to rely on other places in the stack to back off, or abort
> > requests - we already do for everything except these 3 filesystems.
> >
> > So remove inode_congested() and related functions, and remove the call
> > sites, assuming that inode_congested() always returns 'false'.
> 
> Looks to me this is going to "break" fuse; e.g. readahead path will go
> ahead and try to submit more requests, even if the queue is getting
> congested.   In this case the readahead submission will eventually
> block, which is counterproductive.
> 
> I think we should *first* make sure all call sites are substituted
> with appropriate mechanisms in the affected filesystems and as a last
> step remove the superfluous bdi congestion mechanism.
> 
> You are saying that all fs except these three already have such
> mechanisms in place, right?  Can you elaborate on that?

Not much.  I haven't looked into how other filesystems cope, I just know
that they must because no other filesystem ever has a congested bdi
(with one or two minor exceptions, like filesystems over drbd).

Surely read-ahead should never block.  If it hits congestion, the
read-ahead request should simply fail.  block-based filesystems seem to
set REQ_RAHEAD which might get mapped to REQ_FAILFAST_MASK, though I
don't know how that is ultimately used.

Maybe fuse and others should continue to track 'congestion' and reject
read-ahead requests when congested.
Maybe also skip WB_SYNC_NONE writes..

Or maybe this doesn't really matter in practice...  I wonder if we can
measure the usefulness of congestion.

Thanks,
NeilBrown
