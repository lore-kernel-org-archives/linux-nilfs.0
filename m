From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 1/4] lib/vsprintf: Allow to override date and time
 separator
Date: Tue, 11 May 2021 16:14:56 +0200
Message-ID: <YJqRYNlAu0SfWpb5@alley>
References: <20210510150413.59356-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620742497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K/INbdoVMnVmSuC17hTHtZF9dvmPCdhexs0UvUqBKdU=;
        b=ZZwWnWCNMaCOX6VuJYsh6oDMSznOuCqE3OHNdSQVV9/C2i0EXmlVIOuh76zDI23pRGvYVq
        EdiYKyL07Upk0ornxhN4Gi2nyy4RC7SRHE8PQ9BMhtJqB0xiBEOX6bKgzrgn7jH38dTUrN
        WPMatuYcPOyjzG1cFGyFyLMWper17QY=
Content-Disposition: inline
In-Reply-To: <20210510150413.59356-1-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: JC Kuo <jckuo-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sumit Garg <sumit.garg-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Douglas Anderson <diand>

On Mon 2021-05-10 18:04:10, Andy Shevchenko wrote:
> ISO 8601 defines 'T' as a separator between date and time. Though,
> some ABIs use time and date with ' ' separator instead.
> 
> Add a flavour to the %pt specifier to override default separator.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  Documentation/core-api/printk-formats.rst |  6 +++++-
>  lib/test_printf.c                         |  5 +++++
>  lib/vsprintf.c                            | 19 ++++++++++++++++---
>  3 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index f063a384c7c8..bc85fd4685e7 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -514,9 +514,10 @@ Time and date
>  ::
>  
>  	%pt[RT]			YYYY-mm-ddTHH:MM:SS
> +	%pt[RT]s		YYYY-mm-dd HH:MM:SS
>  	%pt[RT]d		YYYY-mm-dd
>  	%pt[RT]t		HH:MM:SS
> -	%pt[RT][dt][r]
> +	%pt[RT][dt][rs]

Sigh, we do not have clear rules what [xy] means. It might be:

      + always use one of them
      + optionally use one of them
      + always use any of them
      + optionally use any of them

%pt[RT][dt][rs] is a great mix:

      + R or T is required, the rest is optional
      + 'd' or 't' can be used but both together are not supported 
      + any variant of 'r' and 's' is supported including various ordering

Honestly, I do not know about any magic solution that might make it
easier to understand these monster modifiers.

Well, what about using the following at least in this case:

	%pt[RT][dt][r][s]

It might help to understand that both 'r' and 's' can be used at the
same time.

An attempt to distinguishing all the possibilities might be:

	%pt{RT}[{dt}][r][s]

where [] means that it is optional and {} means one of them must be
chosen. But I am not sure if it really makes the life easier. Anyway,
this would be for another patch that updates the entire printk-formats.rst.

>  
>  For printing date and time as represented by::
>  
> @@ -528,6 +529,9 @@ in human readable format.
>  By default year will be incremented by 1900 and month by 1.
>  Use %pt[RT]r (raw) to suppress this behaviour.
>  
> +The %pt[RT]s (space) will override ISO 8601 by using ' ' instead of 'T'
> +between date and time. It won't have any effect when date or time is omitted.
> +
>  Passed by reference.
>  
>  struct clk
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index f0c35d9b65bf..5f36c7a43cdc 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1834,7 +1834,8 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
>  	      struct printf_spec spec, const char *fmt)
>  {
>  	bool have_t = true, have_d = true;
> -	bool raw = false;
> +	bool raw = false, space = false;
> +	bool found = true;
>  	int count = 2;
>  
>  	if (check_pointer(&buf, end, tm, spec))
> @@ -1851,14 +1852,26 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
>  		break;
>  	}
>  
> -	raw = fmt[count] == 'r';
> +	do {
> +		switch (fmt[count++]) {
> +		case 'r':
> +			raw = true;
> +			break;
> +		case 's':
> +			space = true;
> +			break;
> +		default:
> +			found = false;
> +			break;
> +		}
> +	} while (found);
>  
>  	if (have_d)
>  		buf = date_str(buf, end, tm, raw);
>  	if (have_d && have_t) {
>  		/* Respect ISO 8601 */

The comment is slightly misleding now. What about something like?

		/* 'T' by ISO 8601. */

Or maybe call the variable: iso_8601, remove the comment, and
invert the logic:


		bool iso_8601 = true;

		case 's':
			iso_8601 = false;
			break;

		*buf = iso_8601 ? 'T' : ' ';

>  		if (buf < end)
> -			*buf = 'T';
> +			*buf = space ? ' ' : 'T';
>  		buf++;
>  	}
>  	if (have_t)

Best Regards,
Petr
