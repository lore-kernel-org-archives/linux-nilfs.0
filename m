From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 04/11] vfs: add a vfs helper for io_uring file pos lock
Date: Sun, 27 Aug 2023 21:47:05 +0100
Message-ID: <ZOu2SbpbRtQPeaDk@casper.infradead.org>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-5-hao.xu@linux.dev>
Mime-Version: 1.0
Return-path: <bpf+bounces-8812-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PcFOPVpAmfEy32wmLZk8ueqNLvTCgnNwnqcJznT/RPQ=; b=rNsimzjbKmM2oAlOTJ0DzjsqcD
	17aYtuzwaGU+CR8bJtkEeJr/wCSQMKchDc0n2mlQZ7v9rEEKKGacwZsk+Mho4BlGQdRHWhRckPvPs
	fMAYQy7+QXBdTjAznfYn8yoo2Vt8NnBgsp0KpbdkC6EeIBdGLqHsafJ8s67fpw63Doi4IWtOlBji1
	MNTrBEfgnOFbk2WLamTkOgHWwWl/muBmiqb1Xzl2D+NHqIQ82dzKbnLLfmjRYZ7IV0n24RJ6z3j9d
	dk+Bi80MVVBrmB0+FFfEqYIN7sGr6Bu4FSHMLVu2SkHeyRuhO+l5+YcAQVjuGi14l8MuPMLDNTwlB
	D4MIXbrw==;
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-5-hao.xu@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <hao.xu@linux.dev>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Dominique Martinet <asmadeus@codewreck.org>, Pavel Begunkov <asml.silence@gmail.com>, Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cachefs@redhat.com, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, devel@lists.orangefs.

On Sun, Aug 27, 2023 at 09:28:28PM +0800, Hao Xu wrote:
> +++ b/include/linux/file.h
> @@ -81,6 +81,8 @@ static inline void fdput_pos(struct fd f)
>  	fdput(f);
>  }
>  
> +extern int file_pos_lock_nowait(struct file *file, bool nowait);

No extern on function declarations.

