From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: searching checkpoints contaning an inode (or a filename)
Date: Fri, 5 Jul 2013 17:48:10 -0400
Message-ID: <CALJXSJrLo_5=e-M41vXyuS9SbRyeZ=zjLYv2Hs3a8Dt+BwS6ig@mail.gmail.com>
References: <20130705201701.GE23851@taesoo.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=1TTkhhT+Sf4b1GYCNDcjOUazhS8lg30/F2jr0OCVhmQ=;
        b=xvoCzSREDQSrwmtJShBo9cTGnpfRcyL0I7AVDaR9B+EGKb4gxlr2yJNsVzllDnxlFY
         r0JFdrN2DVRI4PJiiw+qRInqoMdKE2zUEVqiaqeAjFABz9R3JFqIYMkvAwHTrGfpnTJj
         pCcCnaBANOwqspledL1pSBUKFtnY2wR1Bx8XekW7THyZsFHYLVFyeFjdOQRR4J13Yhih
         nkET1qDOJkIOxcyMyqSmS0DSCEOAJvOJKrfjFe63rwii6VVEg8BiW9j10tnHIPaMUz2H
         7DOjEPclMG+VrRQgn7Qb74OJLPn2pSnPlORvWNhGXNirLJPKWWhYZb+WKdwrHqplKhtP
         EShA==
In-Reply-To: <20130705201701.GE23851-Q1ymHw66ZoYdnm+yROfE0A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jul 5, 2013 at 4:17 PM, Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org> wrote:
>
> q3. using nilfs as rootfs?
>  (I couldn't find any people using nilfs for rootfs. Are there any
>  issue on that? or just matter of performance? on updates for
>  example)

I'm using NILFS as root filesystem on my work laptop for a total of 4
years. I switched to BTRFS for a year in between but looking at how
fast it kills SSD, it wass not worthwhile.

Stability wise, I only had 2 problems with NILFS, the first, which was
fixed promptly, caused a total data lost because of how the cleaner
scrub the disk (using the time), it scrubbed data from the future
after time ran backward. Then the other problem was a kernel OOPS
about a file from the debian APT cache, I deleted it and it runs just
fine now, I couldn't take the backtrace.

Performance wise, on SSD the filesystem is really fast and snappy,
while on HDD, reads are really slow, booting takes 2 minutes instead
of less than 10 seconds, however, once booted and everything is in
cache, it is quite fast. Database loads, especially reads on HDD is
the worst for NILFS.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
