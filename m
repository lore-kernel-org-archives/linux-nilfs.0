From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Tue, 12 Dec 2017 10:51:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1712121041240.1358-100000@iolanthe.rowland.org>
References: <1513035963.3036.17.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:Message-ID:In-Reply-To:
 Subject:cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=OT7IoOR6cg7GsEoh8ZMqfyHAfNhodIf0n2ypBC/tOH8=; b=LZQrWycGXHnqCU2elsDhVvI/Ui
 CXNIwpxsT2k8FUcjTqWxyuqnfYNvFOwUjGjbundLEVmE3XkpCq4L657Iwzf1icg/cjSMnajhBwDUb
 Lx62I189Pwa/zefiDP64pFdpy+LB6geSzXrihZDt5GlkxqiiYln/72D1qsMx8ZC/O34s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:Message-ID:In-Reply-To:Subject:cc:To:From:Date:
 Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
 Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=OT7IoOR6cg7GsEoh8ZMqfyHAfNhodIf0n2ypBC/tOH8=; b=L
 BExhRBIkaosFpUSLglzNEGN5PKFEadsz+VlWD/4PpcV72XhzuIXimgpcJvXkHfFs93dxBtQ+CSkmw
 cGE39H1bEINe58s3FF6N26gmoOg9Z+nQIRT+eH5r9QmpnG2WB9D79qBPV7UNIJS6AybdGcEmgM8vb
 oE0cPz1VxhPMXvGg=;
In-Reply-To: <1513035963.3036.17.camel@perches.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Joe Perches <joe@perches.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, linux-usb@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Byungchul Park <byungchul.park@lge.com>, linux-mm@kvack.org, kernel-team@lge.com, Andy Whitcroft <apw@shadowen.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Rehas Sachdeva <aquannie@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-btrfs@vger.kernel.org

On Mon, 11 Dec 2017, Joe Perches wrote:

> >  - I don't understand the error for xa_head here:
> > 
> > struct xarray {
> >         spinlock_t      xa_lock;
> >         gfp_t           xa_flags;
> >         void __rcu *    xa_head;
> > };
> > 
> >    Do people really think that:
> > 
> > struct xarray {
> >         spinlock_t      xa_lock;
> >         gfp_t           xa_flags;
> >         void __rcu	*xa_head;
> > };
> > 
> >    is more aesthetically pleasing?  And not just that, but it's an *error*
> >    so the former is *RIGHT* and this is *WRONG*.  And not just a matter

Not sure what was meant here.  Neither one is *WRONG* in the sense of 
being invalid C code.  In the sense of what checkpatch will accept, the 
former is *WRONG* and the latter is *RIGHT* -- the opposite of what 
was written.

> >    of taste?
> 
> No opinion really.
> That's from Andy Whitcroft's original implementation.

This one, at least, is easy to explain.  The original version tends to
lead to bugs, or easily misunderstood code.  Consider if another
variable was added to the declaration; it could easily turn into:

	void __rcu *	xa_head, xa_head2;

(The compiler will reject this, but it wouldn't if the underlying type
had been int instead of void.)

Doing it the other way makes the meaning a lot more clear:

	void __rcu	*xa_head, *xa_head2;

This is an idiom specifically intended to reduce the likelihood of 
errors.  Rather like avoiding assignments inside conditionals.

Alan Stern


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
