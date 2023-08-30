From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 08/92] fs: new helper:
 simple_rename_timestamp
Date: Tue, 29 Aug 2023 20:48:48 -0400
Message-ID: <d73e7de5056a34578a193185770e46584450d8b7.camel@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <20230705185812.579118-3-jlayton@kernel.org>
 <20230830001917.GC461907@ZenIV>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693356559;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=l6ldWDOqGKIdEumDQQZraLp712clgs44Ub5voSyAlmQ=;
	b=ig9dVJm1VVR8k5T2cyCvm4nXAKMx49G0nD+XDkZjX9A1xsOvzcGKPG+z92m7n1BMAQU9Uz
	WJmzNbZYJFaFp0QenUhUuOfzNGrauPookXK1UyDgfwb2TSntyndq3XQTnG1zddLSk52zbe
	2HbXjlbNUf1uZdaNQT8CKpd4nJEsQng=
In-Reply-To: <20230830001917.GC461907@ZenIV>
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
Content-Type: text/plain; charset="us-ascii"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: lucho@ionkov.net, rafael@kernel.org, djwong@kernel.org, al@alarsen.net, cmllamas@google.com, andrii@kernel.org, hughd@google.com, john.johansen@canonical.com, agordeev@linux.ibm.com, hch@lst.de, hubcap@omnibond.com, pc@manguebit.com, linux-xfs@vger.kernel.org, bvanassche@acm.org, jeffxu@chromium.org, mpe@ellerman.id.au, john@keeping.me.uk, yi.zhang@huawei.com, jmorris@namei.org, christophe.leroy@csgroup.eu, code@tyhicks.com, stern@rowland.harvard.edu, borntraeger@linux.ibm.com, devel@lists.orangefs.org, mirimmad17@gmail.com, sprasad@microsoft.com, jaharkes@cs.cmu.edu, linux-um@lists.infradead.org, npiggin@gmail.com, jlbec@evilplan.org, ericvh@kernel.org, surenb@google.com, trond.myklebust@hammerspace.com, anton@tuxera.com, brauner@kernel.org, wsa+renesas@sang-engineering.com, gregkh@linuxfoundation.org, stephen.smalley.work@gmail.com, linux-usb@vger.kernel.org, linux-ker

On Wed, 2023-08-30 at 01:19 +0100, Al Viro wrote:
> On Wed, Jul 05, 2023 at 02:58:11PM -0400, Jeff Layton wrote:
>=20
> > + * POSIX mandates that the old and new parent directories have their c=
time and
> > + * mtime updated, and that inodes of @old_dentry and @new_dentry (if a=
ny), have
> > + * their ctime updated.
>=20
> APPLICATION USAGE
> Some implementations mark for update the last file status change timestam=
p
> of renamed files and some do not. Applications which make use of the
> last file status change timestamp may behave differently with respect
> to renamed files unless they are designed to allow for either behavior.
>
> So for children POSIX permits rather than mandates.  Doesn't really matte=
r;
> Linux behaviour had been to touch ctime on children since way back, if
> not since the very beginning.

Mea culpa. You're quite correct. I'll plan to roll a small patch to
update the comment over this function.

Thanks!
--=20
Jeff Layton <jlayton@kernel.org>

