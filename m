From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 00/89] fs: new accessors for
 inode->i_ctime
Date: Mon, 10 Jul 2023 09:32:23 -0400
Message-ID: <c4eaff9389fe63ec4e29404ec0d1181b74935426.camel@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <5e40891f6423feb5b68f025e31f26e9a50ae9390.camel@kernel.org>
 <20230710-zudem-entkam-bb508cbd8c78@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688995975;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ypo6EEC/a10vTp0LME1omXwBE1UiKK/mReyAl6l5UHQ=;
	b=DXnqApzEtbWlfgwnEz+7m8CDyjIvXf2fgGhSF5qhBu7Aye1JYbTAMwSYZl82iRu13wMB+t
	zFdX2QJ5gahRU8JBKPJQBQHv1CE/dJQC2+jeZlILdObSp860aNABLPHR0rH4yKsEhWPA1F
	WmzHsb7UN/qIta7NKNloc6zQzs4TQ5g=
In-Reply-To: <20230710-zudem-entkam-bb508cbd8c78@brauner>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
To: Christian Brauner <brauner@kernel.org>
Cc: lucho@ionkov.net, rafael@kernel.org, djwong@kernel.org, al@alarsen.net, cmllamas@google.com, andrii@kernel.org, hughd@google.com, john.johansen@canonical.com, agordeev@linux.ibm.com, hch@lst.de, hubcap@omnibond.com, pc@manguebit.com, linux-xfs@vger.kernel.org, bvanassche@acm.org, jeffxu@chromium.org, mpe@ellerman.id.au, john@keeping.me.uk, yi.zhang@huawei.com, jmorris@namei.org, christophe.leroy@csgroup.eu, code@tyhicks.com, stern@rowland.harvard.edu, borntraeger@linux.ibm.com, devel@lists.orangefs.org, mirimmad17@gmail.com, sprasad@microsoft.com, jaharkes@cs.cmu.edu, linux-um@lists.infradead.org, npiggin@gmail.com, viro@zeniv.linux.org.uk, ericvh@kernel.org, surenb@google.com, trond.myklebust@hammerspace.com, anton@tuxera.com, wsa+renesas@sang-engineering.com, gregkh@linuxfoundation.org, stephen.smalley.work@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel

On Mon, 2023-07-10 at 14:35 +0200, Christian Brauner wrote:
> On Fri, Jul 07, 2023 at 08:42:31AM -0400, Jeff Layton wrote:
> > On Wed, 2023-07-05 at 14:58 -0400, Jeff Layton wrote:
> > > v2:
> > > - prepend patches to add missing ctime updates
> > > - add simple_rename_timestamp helper function
> > > - rename ctime accessor functions as inode_get_ctime/inode_set_ctime_=
*
> > > - drop individual inode_ctime_set_{sec,nsec} helpers
> > >=20
> >=20
> > After review by Jan and others, and Jan's ext4 rework, the diff on top
> > of the series I posted a couple of days ago is below. I don't really
> > want to spam everyone with another ~100 patch v3 series, but I can if
> > you think that's best.
> >=20
> > Christian, what would you like me to do here?
>=20
> I picked up the series from the list and folded the fixups you posted
> here into the respective fs conversion patches. I hope that helps you
> avoid a resend. You should have received a separate "thank you" mail for
> all of this.
>=20
> To each patch that I folded one of the fixlets from below into I added a
> git note that records a link to your mail here and the respective patch
> hunk from this mail that I folded into the patch. git.kernel.org will
> show notes by default. For example,
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=3Dv=
fs.ctime&id=3D8b0e3c2e99004609a16ba145bcbdfdddb78e220e
> should show you the note I added. You can also fetch them via
> git fetch $remote refs/notes/*:refs/notes/*
> (You probably know that ofc but jic.) if you're interested.
>=20
> Based on v6.5-rc1 as of today.
>=20

Many thanks!!! I'll get to work rebasing the multigrain timestamp series
on top of that.

> Btw, both b4 and patchwork somehow treat the series in weird was.
> IOW, based on the message id of the cover letter I was able to pull most
> messages except for:
>=20
> [07/92] fs: add ctime accessors infrastructure
> [08/92] fs: new helper: simple_rename_timestamp
> [92/92] fs: rename i_ctime field to __i_ctime
>=20
> which I pulled in separately. Not sure what the cause of=A0
>=20
> this is.

Good to know.

I ended up doing the send in two phases: one for the cover letter and
infrastructure patches that went to everyone, and one for the per-
subsystem patches that went do individual maintainers and lists.

I suspect that screwed up the message IDs somehow. Hopefully I won't
need to do a posting like that again soon, but I'll pay closer attention
to the message id handling next time.

Thanks again!
--=20
Jeff Layton <jlayton@kernel.org>

