From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Lockdep is less useful than it was
Date: Fri, 8 Dec 2017 10:27:17 -0500
Message-ID: <20171208152717.fx5w66wvyrfx6vrz@thunk.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
 <20171207223803.GC26792@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org;
	 s=ef5046eb; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cTYFvaDAV8xIHuT+i3AhbDK+Fxb9vvi50W5rlbPI7Fo=; b=kAOpB9Ax0CZD0She0GhnWOXpfl
	uiYR2jrx8Ba4IgynM4lNQHaAquNEgTaiwwLVXQ1YU4zNCxPKWUQUNA0BfqNYCcgnJX8ciB+HyCA1a
	zFtkJvnX44XaV9fvdiItMiPNZbs5oDpH/ItxxhginUHa2Ft1jHgHYVqrxBPJqNotet6k=;
Content-Disposition: inline
In-Reply-To: <20171207223803.GC26792@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org, byungchul.park@lge.com

On Thu, Dec 07, 2017 at 02:38:03PM -0800, Matthew Wilcox wrote:
> I think it was a mistake to force these on for everybody; they have a
> much higher false-positive rate than the rest of lockdep, so as you say
> forcing them on leads to fewer people using *any* of lockdep.
> 
> The bug you're hitting isn't Byungchul's fault; it's an annotation
> problem.  The same kind of annotation problem that we used to have with
> dozens of other places in the kernel which are now fixed.

The question is whose responsibility is it to annotate the code?  On
another thread it was suggested it was ext4's responsibility to add
annotations to avoid the false positives --- never the mind the fact
that every single file system is going to have add annotations.

Also note that the documentation for how to add annotations is
***horrible***.  It's mostly, "try to figure out how other people
added magic cargo cult code which is not well defined (look at the
definitions of lockdep_set_class, lockdep_set_class_and_name,
lockdep_set_class_and_subclass, and lockdep_set_subclass, and weep) in
other subsystems and hope and pray it works for you."

And the explanation when there are failures, either false positives,
or not, are completely opaque.  For example:

[   16.190198] ext4lazyinit/648 is trying to acquire lock:
[   16.191201]  ((gendisk_completion)1 << part_shift(NUMA_NO_NODE)){+.+.}, at: [<8a1ebe9d>] wait_for_completion_io+0x12/0x20

Just try to tell me that:

	((gendisk_completion)1 << part_shift(NUMA_NO_NODE)){+.+.}

is human comprehensible with a straight face.  And since the messages
don't even include the subclass/class/name key annotations, as lockdep
tries to handle things that are more and more complex, I'd argue it
has already crossed the boundary where unless you are a lockdep
developer, good luck trying to understand what is going on or how to
add annotations.

So if you are adding complexity to the kernel with the argument,
"lockdep will save us", I'm with Dave --- it's just not a believable
argument.

Cheers,

						- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
