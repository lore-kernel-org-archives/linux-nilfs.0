From: "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 02/11] MM: document and polish read-ahead
	code.
Date: Mon, 28 Feb 2022 16:19:24 +1100
Message-ID: <164602556430.20161.5451268677064506613@noble.neil.brown.name>
References: <164447124918.23354.17858831070003318849.stgit@noble.brown>,
	<164447147257.23354.2801426518649016278.stgit@noble.brown>,
	<20220210122440.vqth5mwsqtv6vjpq@quack3.lan>,
	<164453611721.27779.1299851963795418722@noble.neil.brown.name>,
	<20220224182622.n7abfey3asszyq3x@quack3.lan>,
	<164602251992.20161.9146570952337454229@noble.neil.brown.name>,
	<20220227204728.b2eb5dd94ecc3e86912bacad@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646025575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=OsOdRKyOPTsqFVySVeje99MCazN8FHXIRZGctTB3Fjc=;
	b=1aDnYNyCMKoqi7852ELng+RjN9qj4H3oZKIs6lZKTxoiwJvkWraBZGmj+Lgr7uB+1SHFJz
	Yh2mZu17ZFxMhdj6twoLK7xeDGS6uw7JuUWs/fN+ewmZBdcdER+polBa/xGaRr74gldhFA
	Ag1t4rw/IZDJ70lWUTD3DCkE1pDKQVg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646025575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=OsOdRKyOPTsqFVySVeje99MCazN8FHXIRZGctTB3Fjc=;
	b=ETy1bbk4AvRTgoyR516RJsfNTn47d24xVl6EFjxT7PerkTAmm+E/x1KFcnx2xiTY9paC/z
	4vNKWy2UyfSPGfDg==
In-reply-to: <20220227204728.b2eb5dd94ecc3e86912bacad-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
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
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anna Schumaker <anna.schumaker@netapp>

On Mon, 28 Feb 2022, Andrew Morton wrote:
> On Mon, 28 Feb 2022 15:28:39 +1100 "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> 
> > When writing documentation the intent of the author is of some interest,
> > but the behaviour of the code is paramount.
> 
> uh, er, ah, no.  The code describes the behaviour of the code.  The
> comments are there to describe things other than the code's behaviour.
> Things such as the author's intent.
> 
> Any deviation between the author's intent and the code's behaviour is
> called a "bug", so it's pretty important to understand authorial
> intent, no?

When the author is writing the documentation - then yes - definitely. 
When the "author" is several different people over a period of years,
then it is not even certain that there is a single unified "intent".

The author's intent is less interesting not so much because it is less
relevant, but because it is less available.

So when writing third-party post-hoc documentation, the focus has to be
on the code, though with reference to the intent to whatever extent it
is available.  Bugs then show up where the actual behaviour turns out to
be impossible to document coherently.

Thanks,
NeilBrown
