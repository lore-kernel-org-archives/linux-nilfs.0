From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sat, 18 Jan 2014 04:44:16 -0500
Message-ID: <CAFvQSYQZtf0fsfX_7zNHdw4hVo9VHggN9F0TYEi1Fwo2ZvS4Ng@mail.gmail.com>
References: <W9375626839227141389894521@atl4webmail02>
	<1389940315.2731.16.camel@slavad-ubuntu>
	<20140118.104703.356941870.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=4HgqAIK9Cjbu2JZtiKY9sH8/zxPwGUMJ0krfFmzinGk=;
        b=jP/7s/f6Pn8bL3opxuZi4DKESqSAxnQYiD/obmVq1EKcMAp/xm02mszh1hxTJU+QBU
         vJ6lgY7SAQddX7jPnhBkcj1f8uPHNR3AHVl/QsGHcbQMiYDw1ZcLPpJR42uHl1Afzh7F
         mDOZ3HwFH+gkjivYLOaaSOLoxtLvXnObprfbdbRo2lufWgX0n5cu6RqbUMHGU1R1MBuv
         og6t/XeDcABijx6Hk4K1hYl9RoJkqlWqVy8QyEcSrFpfuzHD9nen0EDI55/2t5uuUiZr
         6CItAWq5Je0Wf7IlseIpynkqMdKtfFyTymkbEJBHvWdt6Pxavjcsqmuz0W64d0B/qr5j
         P99w==
In-Reply-To: <20140118.104703.356941870.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi again,

> Rather, the issue on the flash devices may come from the current
> immature garbage collection algorithm.  The current cleanerd only
> supports the timestamp-based GC policy which always tries to move the
> oldest segment first and even moves segments full of live blocks,
> thereby shortens the lifetime of flash devices. :-(

It depends - for SSDs the timestamp policy is not optimal as it leads
to unnecessary writes.

On the other hand, most cards only implement dynamic wear leveling
(wear leveling takes only place for areas that are written to, which
leads to very uneven wear distribution when there is mostly static
data) and also don't have read-disturb handling.
So for cards it is actually helpful to have the writes spread out
evenly and as a bonus there is no need to worry about read-disturb
effects =)

Regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
