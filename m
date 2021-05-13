From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 1/4] lib/vsprintf: Allow to override ISO 8601 date and
 time separator
Date: Thu, 13 May 2021 11:34:17 +0200
Message-ID: <YJzymZ7m3R1ELjGD@alley>
References: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620898459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bOeXjgffhRk4ROYar2MNv8Jtg7kJ41kJ+qOqxZ43DeA=;
        b=JldI/5nRDymnQ0GD1tOj3C0xjFauFlRVsMq7TmtJAemWoVVsiaetI55P07F0ZtkXSTwqLp
        bYhVznRykaMlcfnF0XK5Dn/J/UlFgc2DRdxfnLReWlZIkgq7pVSzVhgV+TiQTkzz6j6td4
        SvRnqkcCxcQxm6oV+cuTFNRJC42t+YQ=
Content-Disposition: inline
In-Reply-To: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: JC Kuo <jckuo@nvidia.com>, Joe Perches <joe@perches.com>, Sumit Garg <sumit.garg@linaro.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org, linux-nilfs@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jonathan Corbet <corbet@lwn.net>, Mathias Nyman <mathias.nyman@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thierry Reding <thierry.reding@gmail.com>, Jonathan Hunter <jonathanh@nvidia.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Jason Wessel <jason.wessel@windriver.com>, Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <diand>

On Tue 2021-05-11 18:39:55, Andy Shevchenko wrote:
> ISO 8601 defines 'T' as a separator between date and time. Though,
> some ABIs use time and date with ' ' (space) separator instead.
> 
> Add a flavour to the %pt specifier to override default separator.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

I am going to queue the entire patchset for 5.14 via the printk tree
the following week unless anyone complains in the meantime.

Best Regards,
Petr
