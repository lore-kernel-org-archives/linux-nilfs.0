From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Tue, 5 Dec 2017 20:52:54 -0800
Message-ID: <20171206045254.GP26021@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=EDAzjCT0o/Y9Q6tvmEFj0X2wzxhSACnAmbCiMhkg9g8=; b=gYHInRW1obr4FytHsGhY/D7+2
	eYwsUftI3Ax3JNwZ8nFMNDbTlQp18JXTetBkUhSHPI9wJ3UGyX3ZrQczyhAs3Dgfx8YgPw9B8tRP0
	rI2vy9E2hupKhlz2r+pHm/92meXf5y7DPKRMin9Z3LIY1lvbwFaaMlGJdrEdn49wzPuH3vOVai5vR
	4iLL0xPpX35k6u4Ne0vnnq8UoEOrzrL7/UE+UqUbs0uhOcgZu2Cg9iSqr+doUZ4drIFaat2owlfx0
	invAXBlFhrJCU1sdmYnjKKQI/CxiG64v84lk4EZPhndbKirKoqr14QSa08eyP29xz4JcJnSEHuj95
	Bz9oYzQHg==;
Content-Disposition: inline
In-Reply-To: <20171206044549.GO26021@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 05, 2017 at 08:45:49PM -0800, Matthew Wilcox wrote:
> The dquot code is just going to have to live with the fact that there's
> additional locking going on that it doesn't need.  I'm open to getting
> rid of the irqsafety, but we can't give up the spinlock protection
> without giving up the RCU/lockdep analysis and the ability to move nodes.
> I don't suppose the dquot code can 

Oops, thought I'd finished writing this paragraph.

I don't suppose the dquot code can be restructured to use the xa_lock to
protect, say, qi_dquots?  I suspect not, since you wouldn't know which
of the three xarray locks to use.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
