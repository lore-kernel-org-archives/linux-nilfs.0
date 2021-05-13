From: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/4] kdb: Switch to use %ptTs
Date: Thu, 13 May 2021 10:31:30 +0100
Message-ID: <20210513093130.qzbh6tm7lbclgayh@maple.lan>
References: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
 <20210511153958.34527-2-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K2KX3N3qEtXhLRhml3Iacue6w4dhQzMo6cc0mTtnvQM=;
        b=r0pHg9wLk+EkYR5JCrgzCwvxfLOJCEKZ7rlImrKtZJl/RFxusIlb/dHrHqumPtHekw
         TuV6M6W+5C+88MZcMWoYC03FLTQRmP+HZMlOaDrQZ05FPxs039l9uS8pmlV0dKcHMLz5
         CUqwLbiwuftKZoH8oiGOepbGAFDSG4Xu5+/lPafGcdhEnhzFZdCxQq3GbaAARfd4JsuT
         kHeqskEgSV555dWibYEfk/fmA7mMm6ZrQ1QRkSy9E8MD6r3u6nR2yInb8/OXA+SqhpjS
         pZLrEoh296DZ+mareJMyQNItfC2RAfn4QvCt91FAO4gpzmeg8UIwAnQk+eaJMz+vsqlG
         BA4w==
Content-Disposition: inline
In-Reply-To: <20210511153958.34527-2-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, JC Kuo <jckuo-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sumit Garg <sumit.garg-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Douglas Anderson <dianders@chromium.o>

On Tue, May 11, 2021 at 06:39:56PM +0300, Andy Shevchenko wrote:
> Use %ptTs instead of open-coded variant to print contents
> of time64_t type in human readable form.
> 
> Cc: Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> Cc: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Reviewed-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
> Reviewed-by: Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Reviewed-by: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Any clue what route this will take into the kernel? I'm certainly happy
for someone else to take the kdb bits alongside the vsprintf stuff
(so here's an acked-by too in case they are fussy about that sort of
thing ;-) ):
Acked-by: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>


Daniel.

> ---
> v2: collected tags
>  kernel/debug/kdb/kdb_main.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> index 1baa96a2ecb8..622410c45da1 100644
> --- a/kernel/debug/kdb/kdb_main.c
> +++ b/kernel/debug/kdb/kdb_main.c
> @@ -2488,7 +2488,6 @@ static void kdb_sysinfo(struct sysinfo *val)
>  static int kdb_summary(int argc, const char **argv)
>  {
>  	time64_t now;
> -	struct tm tm;
>  	struct sysinfo val;
>  
>  	if (argc)
> @@ -2502,13 +2501,7 @@ static int kdb_summary(int argc, const char **argv)
>  	kdb_printf("domainname %s\n", init_uts_ns.name.domainname);
>  
>  	now = __ktime_get_real_seconds();
> -	time64_to_tm(now, 0, &tm);
> -	kdb_printf("date       %04ld-%02d-%02d %02d:%02d:%02d "
> -		   "tz_minuteswest %d\n",
> -		1900+tm.tm_year, tm.tm_mon+1, tm.tm_mday,
> -		tm.tm_hour, tm.tm_min, tm.tm_sec,
> -		sys_tz.tz_minuteswest);
> -
> +	kdb_printf("date       %ptTs tz_minuteswest %d\n", &now, sys_tz.tz_minuteswest);
>  	kdb_sysinfo(&val);
>  	kdb_printf("uptime     ");
>  	if (val.uptime > (24*60*60)) {
> -- 
> 2.30.2
> 
