From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 22/29] xfs: comment page allocation for
 nowait case in xfs_buf_find_insert()
Date: Fri, 25 Aug 2023 15:09:03 +0100
Message-ID: <ZOi1/yafn3HQFWnW@casper.infradead.org>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-23-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=EU4c+QvmUrzx56YT6HV/cCIR2Pjqx+IXpn7k2GV7Q+c=; b=CLsoO6jo7RARLT0+xnPhG0lX9A
 ozEgb+OPb7WWchr210TDWVXK3alsotfYdpLT5HSDeeU3HDzLoTFwXSaFA7eMZaquxnBul+F69JGH1
 bOeGpU6pYCS7cWkypBMEwIu9BXp0t0SPolPtEgwLjeONzLt1dapHTs1z3/lfHDE8kbss=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=EU4c+QvmUrzx56YT6HV/cCIR2Pjqx+IXpn7k2GV7Q+c=; b=FjqdomSPdfpsveEo9HaJbELSpY
 rXoR5IviCOcd+uFEsrE2irmCw8R+FZN/s+6sDLf34mZaJv6gvpq1sd7qlAaTNSV7dtiLm+Lg/iifG
 EF6enWRf77o5YSmb5ZXeqI3DHHAHBj+er7BAwkxQc7YfRZsaOuPeAmcYk7bIJ+whMQ4U=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=EU4c+QvmUrzx56YT6HV/cCIR2Pjqx+IXpn7k2GV7Q+c=; b=sXnwInRucx8CcJKwrlTfZ031er
 LEY7y8jsL9Hib5zZnhCnKvqEBOaupx8CYhaoOaWj/VYF41GGvSOMwZwP7gnqnUjyUY5nybhBoSrxT
 cix5TlGhcoCY3jjdx5/eXfy7PSYCUWLL6z2ZL1LRTqjCJLf619sI6Mfr/SSckV734m8GK683QEHy+
 aF/xKkJIUvAhE/VXofyvjMKZ4LYU11OPTfozENym+/mg5hUGQWADpmiwU301hOx3e6IcpV8ta4h3y
 7U3MMVZnd623qdMqd3D0FkVtdSaK+AiLgU+Qa7F9jQSRFB1EUCUT2iSVWxr49S72DAzkgcEx6R3cM
 2mytwuWw==;
Content-Disposition: inline
In-Reply-To: <20230825135431.1317785-23-hao.xu@linux.dev>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Hao Xu <hao.xu@linux.dev>
Cc: Wanpeng Li <wanpengli@tencent.com>, "Darrick J . Wong" <djwong@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, linux-cachefs@redhat.com, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org, samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kerne

On Fri, Aug 25, 2023 at 09:54:24PM +0800, Hao Xu wrote:
> @@ -633,6 +633,8 @@ xfs_buf_find_insert(
>  	 * allocate the memory from the heap to minimise memory usage. If we
>  	 * can't get heap memory for these small buffers, we fall back to using
>  	 * the page allocator.
> +	 * xfs_buf_alloc_kmem may return -EAGAIN, let's not return it but turn
> +	 * to page allocator as well.

This new sentence seems like it says exactly the same thing as the
previous sentence.  What am I missing?
