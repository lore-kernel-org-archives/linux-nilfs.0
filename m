From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 00/44] Manually convert filesystem FS
	documents to ReST
Date: Wed, 19 Feb 2020 02:32:34 -0700
Message-ID: <20200219023234.7b704acb@lwn.net>
References: <cover.1581955849.git.mchehab+huawei@kernel.org>
	<20200218040146.GM7778@bombadil.infradead.org>
	<20200218110406.098fdc09@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1582104797;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g7qX9mp4oJ6yBemyXwClHjkdSOM0BIl1OFgwFQscLhE=;
	b=dOBcALV0PAFd6IIrPklyfdxJltd3LFJI/OHUUGnAY8FoRuDrsJh2Oy1aVbQtQr6gN5Nd7Z
	XeIshF+u1MSmUVzRSOI9m5H2mp1i7YATYuPzKYY4X1iBzLERTncZOYKce54TYkY9NjvdKm
	1RNu3ad6u2gu6/jDq+/R3CigzQwMSrg=
In-Reply-To: <20200218110406.098fdc09@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
Content-Type: text/plain; charset="us-ascii"
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Brandenburg <martin@omnibond.com>, Jan Kara <jack@suse.cz>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Martinet <asmadeus@codewreck.org>, Amir Goldstein <amir73il@gmail.com>, Copeland <me@bobcopeland.com>, David Howells <dhowells@redhat.com>, Mason <clm@fb.com>, linux-mtd@lists.infradead.org, Dominique, Ilya Dryomov <idryomov@gmail.com>, linux-afs@lists.infradead.org, Jan Kara <jack@suse.com>, Mike Marshall <hubcap@omnibond.com>, Aota <naohiro.aota@wdc.com>, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, Sage Weil <sage@redhat.com>, Richard Weinberger <richard@nod.at>, Matthew Wilcox <willy@infradead.org>, Tyler Hicks <code@tyhicks.com>, Naohiro, v9fs-developer@lists.sourceforge.net, Gao Xiang <xiang@kernel.org>, linux-ext4@vger.kernel.org, Salah Triki <salah.triki@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>

On Tue, 18 Feb 2020 11:04:06 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Then, do a second pass at files outside the new directories (like
> admin-guide), in order to better organize things, eventually splitting
> some files into kAPI, uAPI and/or admin-guide.

I'm looking forward to this phase!  Yes it is harder, and it often
requires selling the idea to skeptical maintainers.  But that is how,
IMO, we get from where we're at now to something closer to a set of
coherent kernel docs.

Thanks,

jon


