From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 08/73] xarray: Add documentation
Date: Thu, 14 Dec 2017 20:22:14 -0800
Message-ID: <20171215042214.GA17444@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-9-willy@infradead.org>
 <66ad068b-1973-ca41-7bbf-8a0634cc488d@infradead.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nL6ozUd14JAJzSMAj7FEjESyJc+oi1IG83k7nEDhA+0=; b=G6VKtpYENxJBaOxKMW+DJhaFt
        GYVXwitwX+e71BheilB0FUXTCI6FSj98l6M2SaBQV24xN6q3m1tKkYoztbOrOgAE+YDgNr7qqj6H5
        jUb/C8ySO6hTZd+FNcqG/eoyLrgSLP/0vJYWfJbnoyZXtqqZWWywrwEDe6jP+UgvJAyDZZE6pphjE
        8wWzzZ97Msk2NS9tdGe6VZE4NfB0O4mCpUiKOXzhMFxMzCKAg8ImXUCC8jdk3LVDej0bgqxSW3m/y
        GAC/EUzLWGTmLu4aHMsFI3LQHCZI+HdSxaw5TYSADceWh6e9KiYC34gTr+E6owmUKF7x80CF+8caD
    
Content-Disposition: inline
In-Reply-To: <66ad068b-1973-ca41-7bbf-8a0634cc488d-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 11, 2017 at 03:10:22PM -0800, Randy Dunlap wrote:
> > +A freshly-initialised XArray contains a ``NULL`` pointer at every index.
> > +Each non-``NULL`` entry in the array has three bits associated with
> > +it called tags.  Each tag may be flipped on or off independently of
> > +the others.  You can search for entries with a given tag set.
> 
> Only tags that are set, or search for entries with some tag(s) cleared?
> Or is that like a mathematical set?

hmm ...

"Each tag may be set or cleared independently of the others.  You can
search for entries which have a particular tag set."

Doesn't completely remove the ambiguity, but I can't think of how to phrase
that better ...

> > +Normal pointers may be stored in the XArray directly.  They must be 4-byte
> > +aligned, which is true for any pointer returned from :c:func:`kmalloc` and
> > +:c:func:`alloc_page`.  It isn't true for arbitrary user-space pointers,
> > +nor for function pointers.  You can store pointers to statically allocated
> > +objects, as long as those objects have an alignment of at least 4.
> 
> This (above) is due to the internal usage of low bits for flags?

Sort of ... if bit 0 is set then we're storing an integer (see below),
and if bit 0 is clear and bit 1 is set, then it's an internal entry.

But I don't want the implementation details to leak into the user manual.
From the user's point of view, they can store a pointer to anything they
allocated with kmalloc.  If they want to store an arbitrary pointer,
they're out of luck.

> > +The XArray does not support storing :c:func:`IS_ERR` pointers; some
> > +conflict with data values and others conflict with entries the XArray
> > +uses for its own purposes.  If you need to store special values which
> > +cannot be confused with real kernel pointers, the values 4, 8, ... 4092
> > +are available.
> 
> or if I know that they values are errno-range values, I can just shift them
> left by 2 to store them and then shift them right by 2 to use them?

Yes, the values -4 to -4092 also make good error signals.

> oh, or use the following function?
> 
> > +You can also store integers between 0 and ``LONG_MAX`` in the XArray.
> > +You must first convert it into an entry using :c:func:`xa_mk_value`.
> > +When you retrieve an entry from the XArray, you can check whether it is
> > +a data value by calling :c:func:`xa_is_value`, and convert it back to
> > +an integer by calling :c:func:`xa_to_value`.

Yup, you could also store errors as integers, if you like.  Your choice :-)

> > +You can enquire whether a tag is set on an entry by using
> > +:c:func:`xa_get_tag`.  If the entry is not ``NULL``, you can set a tag
> > +on it by using :c:func:`xa_set_tag` and remove the tag from an entry by
> > +calling :c:func:`xa_clear_tag`.  You can ask whether any entry in the
> 
>                                                         an entry
> 
> > +XArray has a particular tag set by calling :c:func:`xa_tagged`.
> 
> or maybe I don't understand.  Does xa_tagged() test one entry and return its
> "tagged" result/status?  or does it test (potentially) the entire array to search
> for a particular tag value?

It asks the question "Does any entry in the array have tag N set?"

> > +If the xa_state is holding an %ENOMEM error, calling :c:func:`xas_nomem`
> > +will attempt to allocate more memory using the specified gfp flags and
> > +cache it in the xa_state for the next attempt.  The idea is that you take
> > +the xa_lock, attempt the operation and drop the lock.  The operation
> > +attempts to allocate memory while holding the lock, but it is more
> > +likely to fail.  Once you have dropped the lock, :c:func:`xas_nomem`
> > +can try harder to allocate more memory.  It will return ``true`` if it
> > +is worth retrying the operation (ie that there was a memory error *and*
> 
>                          usually    i.e.
> 
> > +more memory was allocated.  If it has previously allocated memory, and
> 
>                    allocated).

Thanks!

> > +If you need to move to a different index in the XArray, call
> > +:c:func:`xas_set`.  This reinitialises the cursor which will generally
> 
> I would put a comma .... here.......................^
> but consult your $editor.  :)

I'll ask her, but I think you're right :-)

> Nicely done.  Thanks.

Thanks for the review!  I think we're still struggling a little to
talk about tags in an unambiguous way, but apart from that it feels
pretty good.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
