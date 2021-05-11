From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1 1/4] lib/vsprintf: Allow to override date and time
 separator
Date: Tue, 11 May 2021 17:56:56 +0300
Message-ID: <YJqbONasNp9BXx9Q@smile.fi.intel.com>
References: <20210510150413.59356-1-andriy.shevchenko@linux.intel.com>
 <YJqRYNlAu0SfWpb5@alley>
Mime-Version: 1.0
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YJqRYNlAu0SfWpb5@alley>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: JC Kuo <jckuo-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sumit Garg <sumit.garg-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Douglas Anderson <diand>

On Tue, May 11, 2021 at 04:14:56PM +0200, Petr Mladek wrote:
> On Mon 2021-05-10 18:04:10, Andy Shevchenko wrote:
> > ISO 8601 defines 'T' as a separator between date and time. Though,
> > some ABIs use time and date with ' ' separator instead.
> > 
> > Add a flavour to the %pt specifier to override default separator.

...

> >  	%pt[RT]			YYYY-mm-ddTHH:MM:SS
> > +	%pt[RT]s		YYYY-mm-dd HH:MM:SS
> >  	%pt[RT]d		YYYY-mm-dd
> >  	%pt[RT]t		HH:MM:SS
> > -	%pt[RT][dt][r]
> > +	%pt[RT][dt][rs]
> 
> Sigh, we do not have clear rules what [xy] means. It might be:
> 
>       + always use one of them
>       + optionally use one of them
>       + always use any of them
>       + optionally use any of them
> 
> %pt[RT][dt][rs] is a great mix:
> 
>       + R or T is required, the rest is optional
>       + 'd' or 't' can be used but both together are not supported 
>       + any variant of 'r' and 's' is supported including various ordering
> 
> Honestly, I do not know about any magic solution that might make it
> easier to understand these monster modifiers.
> 
> Well, what about using the following at least in this case:
> 
> 	%pt[RT][dt][r][s]
> 
> It might help to understand that both 'r' and 's' can be used at the
> same time.

This is the case, yes, thanks for catching it.

> An attempt to distinguishing all the possibilities might be:
> 
> 	%pt{RT}[{dt}][r][s]
> 
> where [] means that it is optional and {} means one of them must be
> chosen. But I am not sure if it really makes the life easier. Anyway,
> this would be for another patch that updates the entire printk-formats.rst.

No, this is not the case, the d and t can go in any combinations: none, d, t,
dt, or td.

> 
> >  For printing date and time as represented by::
> >  
> > @@ -528,6 +529,9 @@ in human readable format.
> >  By default year will be incremented by 1900 and month by 1.
> >  Use %pt[RT]r (raw) to suppress this behaviour.
> >  
> > +The %pt[RT]s (space) will override ISO 8601 by using ' ' instead of 'T'
> > +between date and time. It won't have any effect when date or time is omitted.

...

> > +	do {
> > +		switch (fmt[count++]) {
> > +		case 'r':
> > +			raw = true;
> > +			break;
> > +		case 's':
> > +			space = true;
> > +			break;
> > +		default:
> > +			found = false;
> > +			break;
> > +		}
> > +	} while (found);
> >  
> >  	if (have_d)
> >  		buf = date_str(buf, end, tm, raw);
> >  	if (have_d && have_t) {
> >  		/* Respect ISO 8601 */
> 
> The comment is slightly misleding now. What about something like?
> 
> 		/* 'T' by ISO 8601. */
> 
> Or maybe call the variable: iso_8601, remove the comment, and
> invert the logic:

Okay, I will think how to improve, thanks!

> 		bool iso_8601 = true;
> 
> 		case 's':
> 			iso_8601 = false;
> 			break;
> 
> 		*buf = iso_8601 ? 'T' : ' ';
> 
> >  		if (buf < end)
> > -			*buf = 'T';
> > +			*buf = space ? ' ' : 'T';
> >  		buf++;
> >  	}

-- 
With Best Regards,
Andy Shevchenko


