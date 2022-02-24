From: "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 06/11] ceph: remove reliance on bdi congestion
Date: Thu, 24 Feb 2022 16:41:56 +1100
Message-ID: <164568131640.25116.884631856219777713@noble.neil.brown.name>
References: <164549971112.9187.16871723439770288255.stgit@noble.brown>,
	<164549983739.9187.14895675781408171186.stgit@noble.brown>,
	<ccc81eb5c23f933137c5da8d5050540cc54e58f0.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1645681327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=LKmtUS8Iww56ZG9AedqwAoOu6e9VunJUN5pEfmlFqFg=;
	b=oacCq8DpEx+HDVYUG2DsF2wuspiuS5qhOaHg1qyYd+T9C2DteAD78mmee61D0FUkZI1YLt
	89gaqCC57biyg1VI4eWpjZIyZz5bUCc+qIzPagHkvNRbHUbMXkbpK1X9DZdFRD07Aas5HD
	lAXZBPvJQXlq+oS7kaTZ3tDK1PH657o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1645681327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=LKmtUS8Iww56ZG9AedqwAoOu6e9VunJUN5pEfmlFqFg=;
	b=MEMewd7NbYPArVPBoXiNu4N+Gd4+gUbLnYQ+eJp9sW2uduqkIYyCem3t9SIAJPZbOtxf7E
	cjDOc2g76XCgQcAw==
In-reply-to: <ccc81eb5c23f933137c5da8d5050540cc54e58f0.camel-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>

On Thu, 24 Feb 2022, Jeff Layton wrote:
> On Tue, 2022-02-22 at 14:17 +1100, NeilBrown wrote:
> > The bdi congestion tracking in not widely used and will be removed.
> > 
> > CEPHfs is one of a small number of filesystems that uses it, setting
> > just the async (write) congestion flags at what it determines are
> > appropriate times.
> > 
> > The only remaining effect of the async flag is to cause (some)
> > WB_SYNC_NONE writes to be skipped.
> > 
> > So instead of setting the flag, set an internal flag and change:
> >  - .writepages to do nothing if WB_SYNC_NONE and the flag is set
> >  - .writepage to return AOP_WRITEPAGE_ACTIVATE if WB_SYNC_NONE
> >     and the flag is set.
> > 
> > The writepages change causes a behavioural change in that pageout() can
> > now return PAGE_ACTIVATE instead of PAGE_KEEP, so SetPageActive() will
> > be called on the page which (I think) wil further delay the next attempt
> > at writeout.  This might be a good thing.
> > 
> > Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> 
> Maybe. I have to wonder whether all of this is really useful.
> 
> When things are congested we'll avoid trying to issue new writeback
> requests. Note that we don't prevent new pages from being dirtied here -
> - only their being written back.
> 
> This also doesn't do anything in the DIO or sync_write cases, so if we
> lose caps or are doing DIO, we'll just keep churning out "unlimited"
> writes in those cases anyway.

I think the point of congestion tracking is to differentiate between
sync and async IO.  Or maybe "required" and "optional".
Eventually the "optional" IO will become required, but if we can delay
it until a time when there is less "required" io, then maybe we can
improve perceived latency.

"optional" IO here is write-back and read-ahead.  If the load of
"required" IO is bursty, and if we can shuffle that optional stuff into
the quiet periods, we might win.

Whether this is a real need is an important question that I don't have an
answer for.  And whether it is better to leave delayed requests in the
page cache, or in the low-level queue with sync requests able to
over-take them - I don't know.  If you have multiple low-level queue as
you say you can with ceph, then lower might be better.

The block layer has REQ_RAHEAD ..  maybe those request get should get a
lower priority ... though I don't think they do.
NFS has a 3 level priority queue, with write-back going at a lower
priority ... I think... for NFSv3 at least.

Sometimes I suspect that as all our transports have become faster, we
have been able to ignore the extra latency caused by poor scheduling of
optional requests.  But at other times when my recently upgraded desktop
is struggling to view a web page while compiling a kernel ...  I wonder
if maybe we don't have the balance right any more.

So maybe you are right - maybe we can rip all this stuff out.

Or maybe not.

Thanks,
NeilBrown
