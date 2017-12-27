From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 05/78] xarray: Replace exceptional entries
Date: Wed, 27 Dec 2017 13:24:42 +0300
Message-ID: <20171227102442.ozazdtj56q73hvkb@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-6-willy@infradead.org>
 <20171226171542.v25xieedd46y5peu@node.shutemov.name>
 <20171227030534.GA24828@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=csMfRlSt6qpe/UggwybGxWqZ5LKSGCnK0mf60vIeCq0=;
        b=IQgfNk01PDOrJ21872VyQQV4kwoehrHBp8cQF1J+PNEkwoACNyjQt6y4FCl2l65MLZ
         +NHX9CZ5Y8VU2/YhjhzRsFlu6Z7oFiTmDeSuiFm4ipSBCs+y78gRNHuKiMTi5eb11+w3
         6G3O6bPW+OlQqHbJq+0F8O8M5dzX+0aOOF4gmlJ1Q8pZ2XBDer3kXEtg/CH2jYQG91vq
         /rNtV658s4wcJObWcrZB6Elm+bIrNu4ExPo3CTPBzJjMtRBtlotksd04xMHaPE1glGPc
         SReSWMGUOcz3wDHIkzKNbkFhc1eaTqcKFRrvXrGqxLUqTfzGIT+hzjMkxkw7Y/Ory5Ge
         J3Cg==
Content-Disposition: inline
In-Reply-To: <20171227030534.GA24828@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 07:05:34PM -0800, Matthew Wilcox wrote:
> On Tue, Dec 26, 2017 at 08:15:42PM +0300, Kirill A. Shutemov wrote:
> > >  28 files changed, 249 insertions(+), 240 deletions(-)
> > 
> > Everything looks fine to me after quick scan, but hat's a lot of changes for
> > one patch...
> 
> Yeah.  It's pretty mechanical though.
> 
> > > -			if (radix_tree_exceptional_entry(page)) {
> > > +			if (xa_is_value(page)) {
> > >  				if (!invalidate_exceptional_entry2(mapping,
> > >  								   index, page))
> > >  					ret = -EBUSY;
> > 
> > invalidate_exceptional_entry? Are we going to leave the terminology here as is?
> 
> That is a great question.  If the page cache wants to call its value
> entries exceptional entries, it can continue to do that.  I think there's
> a better name for them, but I'm not sure what it is.  Right now, the
> page cache uses value entries to store:
> 
> 1. Shadow entries (for workingset)
> 2. Swap entries (for shmem)
> 3. DAX entries
> 
> I can't come up with a good name for these three things.  'nonpage' is
> the only thing which hasn't immediately fallen off my ideas list.

Yeah, naming problem...

> But I think renaming exceptional entries in the page cache is a great idea,
> and I don't want to do it as part of this patch set ;-)

Fair enough.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
