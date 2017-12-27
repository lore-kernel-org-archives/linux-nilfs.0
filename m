From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 06/78] xarray: Change definition of sibling entries
Date: Wed, 27 Dec 2017 13:26:00 +0300
Message-ID: <20171227102600.vruihaqugwxa25sp@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-7-willy@infradead.org>
 <20171226172153.pylgdefajcrthe3b@node.shutemov.name>
 <20171227031326.GB24828@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PZH5TQ2/7HBM8N4iE7VHd6xbysYl/EWDNZQD90PfO44=;
        b=g8iyhvvUjs9zSnSYO4lsQS7LHj0qc/FasLQa18pNLttAR0mamYnLqxUDpjvIU3/zSk
         X2KVeyERPm9NrgnIi5RaENfn+O+nJhjzA1tOPwPxOHw9VhWl50zDQ/JUuwjP6coUQYe+
         s9wiC0CnXtkx93jzlBBNizNbBXyJZ/Eob+PLZ0NF9LwimMJq04J6BGhWZlnEP5qaP/6T
         sZKh32P8P5eFVw9h9JIRwZ/QB928tcD9RuqGfJ5WwdiQcm19CIqezPmTOrWzC1tIzpnB
         ycmNE6HqMic0EYBa4MP/xdDLU4s/kLzoAmz4kIXtlGWwpoLTu8rDWHDIiFINFxWxiAxh
         22fg==
Content-Disposition: inline
In-Reply-To: <20171227031326.GB24828@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 07:13:26PM -0800, Matthew Wilcox wrote:
> On Tue, Dec 26, 2017 at 08:21:53PM +0300, Kirill A. Shutemov wrote:
> > > +/**
> > > + * xa_is_internal() - Is the entry an internal entry?
> > > + * @entry: Entry retrieved from the XArray
> > > + *
> > > + * Return: %true if the entry is an internal entry.
> > > + */
> > 
> > What does it mean "internal entry"? Is it just a term for non-value and
> > non-data pointer entry? Do we allow anybody besides xarray implementation to
> > use internal entires?
> > 
> > Do we have it documented?
> 
> We do!  include/linux/radix-tree.h has it documented right now:

Looks good. Thanks.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
