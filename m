From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 07/26] gfs2; Convert gfs2_getjdatabuf to use a folio
Date: Wed, 20 Sep 2023 04:11:11 +0100
Message-ID: <ZQpizwzZ/J+2CUfj@casper.infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
 <20230919045135.3635437-8-willy@infradead.org>
 <CAHc6FU4-RSAsc-LWw2OuLDecofapd30OZhxyjVKLXzJNwh-ZoA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uE+UAnC9YgmNAUhKoTWIdxRk/FdOddBgLymLwlPaqnk=; b=ekNfgmFwoHu8gIoYFOjAVApvtB
        3IXO/kDTQVK7eWR0y6nYylINvIk4NtmEm3kQODEPrUFwrj5dXTYcXamT6rwoq/2nvLl5fEGFiXvrd
        qGejySTQ2pAFXZBOhqsyHwndRN62Ily6nVv64jjObtM6K2L7dmD/rDOmehFEm5JknDqooHYchnJLb
        YI/tCYH/CrK1gcaARvorBnRcZOqw+jUnC5gKxqrYuQkFKyzuOj4PSUCgORs7pW00BJ/+8vty/M8I/
        5YP4CSRdEi8Ax4LZNa3piEYfC9C6VrjU/6PZSNvOYis9wkJzK92YeqJ4CXWiya1PLUT44i/m0R7WO
        mKrrt6Uw==;
Content-Disposition: inline
In-Reply-To: <CAHc6FU4-RSAsc-LWw2OuLDecofapd30OZhxyjVKLXzJNwh-ZoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Wed, Sep 20, 2023 at 12:27:08AM +0200, Andreas Gruenbacher wrote:
> Thanks,
> 
> but this patch has an unwanted semicolon in the subject.

Thanks.  My laptop has a dodgy shift key, so this sometimes happens.
The build quality on HP Spectre laptops has gone downhill in the last
few years.

> > -       page = find_get_page_flags(mapping, index, FGP_LOCK|FGP_ACCESSED);
> > -       if (!page)
> > -               return NULL;
> > -       if (!page_has_buffers(page)) {
> > -               unlock_page(page);
> > -               put_page(page);
> > +       folio = __filemap_get_folio(mapping, index, FGP_LOCK | FGP_ACCESSED, 0);
> > +       if (IS_ERR(folio))
> >                 return NULL;
> > -       }
> > -       /* Locate header for our buffer within our page */
> > -       for (bh = page_buffers(page); bufnum--; bh = bh->b_this_page)
> > -               /* Do nothing */;
> > -       get_bh(bh);
> > -       unlock_page(page);
> > -       put_page(page);
> > +       bh = folio_buffers(folio);
> > +       if (bh)
> > +               get_nth_bh(bh, bufnum);
> 
> And we need this here:
> 
>     bh = get_nth_bh(bh, bufnum);

Oof.  I should make that __must_check so the compiler tells me I'm being
an idiot.

Thanks!
