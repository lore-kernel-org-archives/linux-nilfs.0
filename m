From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 09/11] vfs: error out -EAGAIN if atime needs to be updated
Date: Sun, 27 Aug 2023 21:51:55 +0100
Message-ID: <ZOu3a/24YJrtpIy1@casper.infradead.org>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-10-hao.xu@linux.dev>
Mime-Version: 1.0
Return-path: <bpf+bounces-8813-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=64WGA8VV9Ar6eu59jwKakipB5IQeiUdKnhF4bZRyjJg=; b=f4Amt/s2VPJBfpbA4kwhdXTdVg
	/pn5N3WZwWFuLeNUpjeDraYY4nQbaO2UYvFIaQahuWJpv6yWj9SJhm3438dxwJSqQjroyoc9F0SYv
	XAWPI0/B2+Jwn7WLlLOC7qTdz3pp+yI4mEjVaLz0qln0W2Hlp6Bqseo3n3BK6S7q8PWF2QR7jDDR5
	5QOB+otXNut9VVTlFGgE9OB8fNY4Zqee0Fvn6lAYSC0XLvrtBqaDQzjA8XPvUV/U40DN9P1BUUcT+
	KJAEsVOCJlXQA4wp82KhD9XmJfIxAUdOp4MXoPkTY5GoW5ML77D0bFxP371EeaBKUbiVosNZkp33g
	ozZ78lYw==;
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-10-hao.xu@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <hao.xu@linux.dev>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Dominique Martinet <asmadeus@codewreck.org>, Pavel Begunkov <asml.silence@gmail.com>, Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cachefs@redhat.com, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, devel@lists.orangefs.

On Sun, Aug 27, 2023 at 09:28:33PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> To enforce nowait semantics, error out -EAGAIN if atime needs to be
> updated.

Squash this into patch 6.  Otherwise patch 6 makes no sense.

