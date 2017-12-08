From: Matthew Wilcox <willy@infradead.org>
Subject: Re: Lockdep is less useful than it was
Date: Fri, 8 Dec 2017 10:14:38 -0800
Message-ID: <20171208181438.GA6406@bombadil.infradead.org>
References: <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
 <20171207223803.GC26792@bombadil.infradead.org>
 <20171208152717.fx5w66wvyrfx6vrz@thunk.org>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QaJeIeXvhjfC1DWvpjWvB0LrV9p5JhHi4jaqPofV11Y=; b=cjL4+e4NcDzmHbqklqVWCO6cF
        4yWKDtuhnfZQavG1P04wecThMSlJEGZuotwcKfuWE0hnbfOl+otXa3KpGxEYjBy9EkidyWeAlgqYB
        cYOdXwdkZBk74gwdcm3bf93X9SQHVP1lbbAWdSB7L+fpgWH5qGu39ocHioDaiqBVBmM6v2Oy0QcI/
        FvpxBZA4xhQMdu/nV9rIdEI7sLU7KYI7yL9alK3si9XftNdaJzJMPwm+lDbcN/sxQCZOcgzPbDdRI
        0o4v29j/52ZBqzVLWujUGIMWKEpoKKaWAY1D71SQ7fnui7kI8VzORd1Dcdc5n+neNO7Kmp6dHP8qB
    
Content-Disposition: inline
In-Reply-To: <20171208152717.fx5w66wvyrfx6vrz@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org, byungchul.park@lge.com

On Fri, Dec 08, 2017 at 10:27:17AM -0500, Theodore Ts'o wrote:
> So if you are adding complexity to the kernel with the argument,
> "lockdep will save us", I'm with Dave --- it's just not a believable
> argument.

I think that's a gross misrepresentation of what I'm doing.

At the moment, the radix tree actively disables the RCU checking that
enabling lockdep would give us.  It has to, because it has no idea what
lock protects any individual access to the radix tree.  The XArray can
use the RCU checking because it knows that every reference is protected
by either the spinlock or the RCU lock.

Dave was saying that he has a tree which has to be protected by a mutex
because of where it is in the locking hierarchy, and I was vigorously
declining his proposal of allowing him to skip taking the spinlock.

And yes, we have bugs today that I assume we only stumble across every
few billion years (or only on alpha, or only if our compiler gets more
aggressive) because we have missing rcu_dereference annotations.
