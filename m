From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Thu, 16 Jan 2014 13:41:53 -0500
Message-ID: <CAFvQSYQApxKaYuivoWPWD50xE_1KMQdoG_1+Q3MBCwtgWk3hsw@mail.gmail.com>
References: <W9375626839227141389894521@atl4webmail02>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=KU7/+FRB8bf6kTP2EbsuAPBNwsSxqId8l8UU2g0lbB0=;
        b=Xc+pk9PlGsrTwufy7bj5zrzYMUessI7vgMnoEpgwvbZNqRT+pSvNm7AQprCgnhou6s
         Rjc96Cp5T+cAyC+xw9rGLkEQoQwAlw6HRCUDKnyx0Ytg2hXZcFTey7tgDRseO9tOQCSa
         sc16pLCr+JLS5gf0cZbL6unXScZ9fS8kAn8acDqkkOO/oQx2m2EdKPQnLBmKAIUnNQns
         +/0lnWiHAzG5pqDcU+REK2axfCoYdryehRx95dn6YMsb1tzzCE/ZtkhUg5kipvBcTVpF
         Rp6g/er4v3ktOcFs2nZEGCHuK9UNf9OIZujQmYpPaVZYZQITiyj03HMGtmXMAC29J6Ee
         U2QQ==
In-Reply-To: <W9375626839227141389894521@atl4webmail02>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Mark,

> I am wondering what the impact of in-place writes of the
> superblock has on SSDs in terms of wear?

Typically SSDs have far more advanved static wear leveling algorithms
which keep the erease count for each erease block as well as a
sophisticated mapping table. Otherwise e.g. journaling file systems
would probably kill it quickly.

Regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
