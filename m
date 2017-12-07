From: Matthew Wilcox <willy@infradead.org>
Subject: Lockdep is less useful than it was
Date: Thu, 7 Dec 2017 14:38:03 -0800
Message-ID: <20171207223803.GC26792@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=pw+msOHydh1fs/+lsbf5ld8ik79YvrP7cd87nogxTqE=; b=VkWQs394EwC6AYW/yzUhEO9Pb
	9QrkqjSaXT6F2bdHNR/BwNX3+j7W5gwhXlteAqK9HDEW2Fl1kZJcL8FZhvN7WwXTEIwueG5kZMBZh
	cmttjKbcWZzUnQJF+K0bliMftMazWI3IVJ/HvOZwf4xORsWGSULJ6/c3ETSOm4r+afw9/Zbsoq5wu
	HHv3Y2h/CVvPyKlmL3HvJ/QJVugorbsuNdWGxrqozpNViQz4A/kLyRYTeD1G/Ib4xV8V3l4qdaH2M
	6vKLoZ02Q+YDmUZQvcDsxCtKzzAezgLSWOOAXfFbob5T90SPuic+kZMzUtW87eeKU3SLsA0Aa+dBD
	S73DFGaPQ==;
Content-Disposition: inline
In-Reply-To: <20171207160634.il3vt5d6a4v5qesi@thunk.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, byungchul.park@lge.com

On Thu, Dec 07, 2017 at 11:06:34AM -0500, Theodore Ts'o wrote:
> The problem is that if it has too many false positives --- and it's
> gotten *way* worse with the completion callback "feature", people will
> just stop using Lockdep as being too annyoing and a waste of developer
> time when trying to figure what is a legitimate locking bug versus
> lockdep getting confused.
> 
> <Rant>I can't even disable the new Lockdep feature which is throwing
> lots of new false positives --- it's just all or nothing.</Rant>

You *can* ... but it's way more hacking Kconfig than you ought to have
to do (which is a separate rant ...)

You need to get LOCKDEP_CROSSRELEASE off.  I'd revert patches
e26f34a407aec9c65bce2bc0c838fabe4f051fc6 and
b483cf3bc249d7af706390efa63d6671e80d1c09

I think it was a mistake to force these on for everybody; they have a
much higher false-positive rate than the rest of lockdep, so as you say
forcing them on leads to fewer people using *any* of lockdep.

The bug you're hitting isn't Byungchul's fault; it's an annotation
problem.  The same kind of annotation problem that we used to have with
dozens of other places in the kernel which are now fixed.  If you didn't
have to hack Kconfig to get rid of this problem, you'd be happier, right?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
