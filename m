From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 08/92] fs: new helper:
 simple_rename_timestamp
Date: Wed, 30 Aug 2023 01:19:17 +0100
Message-ID: <20230830001917.GC461907@ZenIV>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <20230705185812.579118-3-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693354838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=zZxZUyqerb7julFXQ03Jti/01WDk420m8vSi4C3S7Zg=;
	b=WiuPyaT2ShS6GFlA9rYyQhd6IKjJqwQbO3IF3l3DORTbsgtWqiKzRrzD7KInSnm6W4VvPB
	xpfVub4Dxv4sXbEbUmY9A7FoCgL1q5MQZivH6+Q7eYYS4/P+UAtiFzE3CLQr1WN1S9auYg
	oWqteg9jwomQha86GivhrksPylL39cs=
In-Reply-To: <20230705185812.579118-3-jlayton@kernel.org>
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: lucho@ionkov.net, rafael@kernel.org, djwong@kernel.org, al@alarsen.net, cmllamas@google.com, andrii@kernel.org, hughd@google.com, john.johansen@canonical.com, agordeev@linux.ibm.com, hch@lst.de, hubcap@omnibond.com, pc@manguebit.com, linux-xfs@vger.kernel.org, bvanassche@acm.org, jeffxu@chromium.org, mpe@ellerman.id.au, john@keeping.me.uk, yi.zhang@huawei.com, jmorris@namei.org, christophe.leroy@csgroup.eu, code@tyhicks.com, stern@rowland.harvard.edu, borntraeger@linux.ibm.com, devel@lists.orangefs.org, mirimmad17@gmail.com, sprasad@microsoft.com, jaharkes@cs.cmu.edu, linux-um@lists.infradead.org, npiggin@gmail.com, jlbec@evilplan.org, ericvh@kernel.org, surenb@google.com, trond.myklebust@hammerspace.com, anton@tuxera.com, brauner@kernel.org, wsa+renesas@sang-engineering.com, gregkh@linuxfoundation.org, stephen.smalley.work@gmail.com, linux-usb@vger.kernel.org, linux-ker

On Wed, Jul 05, 2023 at 02:58:11PM -0400, Jeff Layton wrote:

> + * POSIX mandates that the old and new parent directories have their ctime and
> + * mtime updated, and that inodes of @old_dentry and @new_dentry (if any), have
> + * their ctime updated.

APPLICATION USAGE
Some implementations mark for update the last file status change timestamp
of renamed files and some do not. Applications which make use of the
last file status change timestamp may behave differently with respect
to renamed files unless they are designed to allow for either behavior.

So for children POSIX permits rather than mandates.  Doesn't really matter;
Linux behaviour had been to touch ctime on children since way back, if
not since the very beginning.

