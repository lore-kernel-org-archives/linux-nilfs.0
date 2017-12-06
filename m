From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 00/73] XArray version 4
Date: Tue, 5 Dec 2017 18:05:15 -0800
Message-ID: <20171206020515.GL26021@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206014536.GA4094@dastard>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RkFkT8VGsUTPdc0PFxEEcW3oSpzK/Ae1EfidcmtwgFM=; b=Er3Ldkr/k+kZOvXK6pQgHav5F
        M17/DINMMOM9xUmnWpSYY/wHzcLeG/ddcY+F1/uNlw7xhAelth2ccjUr2X1rV8/Qng4ZKLtC7c9zR
        y/gA3XgG94NvEiYSZjzN+mJS+bljXIQHFwCoo5Mxz8J3WH9WD4Nu1eGMFB9CXGNDgfasCCd413YLA
        q5Cz6NyTHzDPiZfnDDDOa48MntIvIqhs+5BYrlAXdZRZbbh0gKqL4FmcaJWgTiCfe3ECT2BAygcJ8
        P/89IfPfArCq5ux3yPQeh5Dj4pI0NE6EGLTSVsZHYHM2wMHmlGHTJVnM+RjA9F9pdBGjWo3nYK2zJ
    
Content-Disposition: inline
In-Reply-To: <20171206014536.GA4094@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Dec 06, 2017 at 12:45:49PM +1100, Dave Chinner wrote:
> On Tue, Dec 05, 2017 at 04:40:46PM -0800, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > 
> > I looked through some notes and decided this was version 4 of the XArray.
> > Last posted two weeks ago, this version includes a *lot* of changes.
> > I'd like to thank Dave Chinner for his feedback, encouragement and
> > distracting ideas for improvement, which I'll get to once this is merged.
> 
> BTW, you need to fix the "To:" line on your patchbombs:
> 
> > To: unlisted-recipients: ;, no To-header on input <@gmail-pop.l.google.com> 
> 
> This bad email address getting quoted to the cc line makes some MTAs
> very unhappy.

I know :-(  I was unhappy when I realised what I'd done.

https://marc.info/?l=git&m=151252237912266&w=2

> I'll give this a quick burn this afternoon and see what catches fire...

All of the things ... 0day gave me a 90% chance of hanging in one
configuration.  Need to drill down on it more and find out what stupid
thing I've done wrong this time.
