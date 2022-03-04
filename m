From: "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 06/11] ceph: remove reliance on bdi congestion
Date: Fri, 04 Mar 2022 13:47:26 +1100
Message-ID: <164636204663.29369.1845040729675190216@noble.neil.brown.name>
References: <164549971112.9187.16871723439770288255.stgit@noble.brown>,
	<164549983739.9187.14895675781408171186.stgit@noble.brown>,
	<ccc81eb5c23f933137c5da8d5050540cc54e58f0.camel@kernel.org>,
	<164568131640.25116.884631856219777713@noble.neil.brown.name>,
	<e8ec98a9c4fab9b7aa099001f09ff9b11f0c3f96.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646362056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=bRC9lR391e01DA8hmQQ11oCmTpgoNtai0DhkKiv/gqA=;
	b=DPBLhpCy8tSefU0o/0cGFUNHFB2ENiUdz7DL+/QuL66B+hanK6/YVNBgksSwMuDLV2K7do
	gLidl4GftwWDduPicJm1Lt/WdYmoepv57PKKCdtFCC0ehwriXODLDFTWOGNFVdmoGAplJO
	DhmYXWeTCsa6asBh2ztOs4cXy4qTCUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646362056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=bRC9lR391e01DA8hmQQ11oCmTpgoNtai0DhkKiv/gqA=;
	b=OC3LPp6wdT68pzKK+cC/1gJqegadfEfURfONkeOYiYNj+tndz1PDCoyP7hDil8izMoBJdD
	3yON2S4St8a2wPDw==
In-reply-to: <e8ec98a9c4fab9b7aa099001f09ff9b11f0c3f96.camel-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
> On Thu, 2022-02-24 at 16:41 +1100, NeilBrown wrote:
> > On Thu, 24 Feb 2022, Jeff Layton wrote:
> > > On Tue, 2022-02-22 at 14:17 +1100, NeilBrown wrote:
> > > > The bdi congestion tracking in not widely used and will be removed.
> > > > 
> > > > CEPHfs is one of a small number of filesystems that uses it, setting
> > > > just the async (write) congestion flags at what it determines are
> > > > appropriate times.
> > > > 
> > > > The only remaining effect of the async flag is to cause (some)
> > > > WB_SYNC_NONE writes to be skipped.
> > > > 
> > > > So instead of setting the flag, set an internal flag and change:
> > > >  - .writepages to do nothing if WB_SYNC_NONE and the flag is set
> > > >  - .writepage to return AOP_WRITEPAGE_ACTIVATE if WB_SYNC_NONE
> > > >     and the flag is set.
> > > > 
> > > > The writepages change causes a behavioural change in that pageout() can
> > > > now return PAGE_ACTIVATE instead of PAGE_KEEP, so SetPageActive() will
> > > > be called on the page which (I think) wil further delay the next attempt
> > > > at writeout.  This might be a good thing.
> > > > 
> > > > Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> > > 
> > > Maybe. I have to wonder whether all of this is really useful.
> > > 
> > > When things are congested we'll avoid trying to issue new writeback
> > > requests. Note that we don't prevent new pages from being dirtied here -
> > > - only their being written back.
> > > 
> > > This also doesn't do anything in the DIO or sync_write cases, so if we
> > > lose caps or are doing DIO, we'll just keep churning out "unlimited"
> > > writes in those cases anyway.
> > 
> > I think the point of congestion tracking is to differentiate between
> > sync and async IO.  Or maybe "required" and "optional".
> > Eventually the "optional" IO will become required, but if we can delay
> > it until a time when there is less "required" io, then maybe we can
> > improve perceived latency.
> > 
> > "optional" IO here is write-back and read-ahead.  If the load of
> > "required" IO is bursty, and if we can shuffle that optional stuff into
> > the quiet periods, we might win.
> > 
> 
> In that case, maybe we should be counting in-flight reads too and deny
> readahead when the count crosses some threshold? It seems a bit silly to
> only look at writes when it comes to "congestion".

I agree that seems a bit silly.

> 
> > Whether this is a real need is an important question that I don't have an
> > answer for.  And whether it is better to leave delayed requests in the
> > page cache, or in the low-level queue with sync requests able to
> > over-take them - I don't know.  If you have multiple low-level queue as
> > you say you can with ceph, then lower might be better.
> > 
> > The block layer has REQ_RAHEAD ..  maybe those request get should get a
> > lower priority ... though I don't think they do.
> > NFS has a 3 level priority queue, with write-back going at a lower
> > priority ... I think... for NFSv3 at least.
> > 
> > Sometimes I suspect that as all our transports have become faster, we
> > have been able to ignore the extra latency caused by poor scheduling of
> > optional requests.  But at other times when my recently upgraded desktop
> > is struggling to view a web page while compiling a kernel ...  I wonder
> > if maybe we don't have the balance right any more.
> > 
> > So maybe you are right - maybe we can rip all this stuff out.
> > 
> 
> I lean more toward just removing it. The existing implementation seems a
> bit half-baked with the gaps in what's being counted. Granted, the
> default congestion threshold is pretty high with modern memory sizes, so
> it probably doesn't come into play much in practice, but removing it
> would reduce some complexity in the client.

I'd love to have some test that could reliably generate congestion and
measure latencies for other IO.  Without that, it is mostly guess work.
So I cannot argue against your proposal, and do agree that removing the
code would reduce complexity.  I have no idea what the costs might be -
if any.  Hence my focus was on not changing behaviour.

Thanks,
NeilBrown
