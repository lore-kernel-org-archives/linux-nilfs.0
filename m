From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 4/4] usb: host: xhci-tegra: Switch to use %ptTs
Date: Tue, 11 May 2021 16:16:55 +0200
Message-ID: <YJqR11LtIoPiDBSl@alley>
References: <20210510150413.59356-1-andriy.shevchenko@linux.intel.com>
 <20210510150413.59356-4-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620742615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rSjMZQsPrsPF/ua9LWX6ZnQ0hSbJwsZWpSXRVeSGoc4=;
        b=VNg+YXHAB3GGKG1mZy4l4l4pSKCKxUJ6xN3mOewccCaPWoqKGuEMvltW5WPcOq7RBg/BNl
        7a7OBTuHGRodbx+ktQM9IeDOMVJNrK/AGO5mLH9ZQYv+LD9f0gdKjCoAOWSwiHnlGTNV6Y
        Y6plfj5QLr/rIQf2ZaGJuuHWkx+LQR8=
Content-Disposition: inline
In-Reply-To: <20210510150413.59356-4-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: JC Kuo <jckuo-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sumit Garg <sumit.garg-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Douglas Anderson <diand>

On Mon 2021-05-10 18:04:13, Andy Shevchenko wrote:
> Use %ptTs instead of open coded variant to print contents
> of time64_t type in human readable form.
> 
> Cc: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Reviewed-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>

Best Regards,
Petr
