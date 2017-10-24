From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix race condition that causes file system corruption
Date: Tue, 24 Oct 2017 05:18:29 +0200
Message-ID: <CAFvQSYR6vXuyGzGjeogKdg1Xzg=4QDE4TM7r4G-UnZ7hLniDkw@mail.gmail.com>
References: <20170711061907.19259-1-andreas.rohner@gmx.net> <CAKFNMonzhYBKkjotNiNY0x0DnWxzHYF8WvO7f7xjGwr-8a=aRQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=qIJjBtAdvrI7iTgvwP8Cc71jsfU5Urf5EzWzozyUwh4=;
        b=Qs64WXKxpv9ssV/Ls7XQtnO2U9Jyy96lygt49Zp3knbJTEpNrIkkb16rHEfIoWAsDu
         hxeItMTz9G8syR91fJROlSsRG0+lejCaeF9jbz3ACU+lfGcmLxjCcBXQ4SCID/JB4uHo
         bd8ahPgvEY7OPQPZWNgwqP6ukTwKd9oRlGLQTdpv0yw9jHUK/XiLGFrC2L8NFT8B6jhW
         8EcEEPhvihVlvy3Y6vkhyJzLRN5edQhS/9D7dXWMomHsG2Xr6lzY93CHY119wk+tkfXs
         7VDcWopaIWEHo9n2CstIOgM2D/upEjrdXfr/NUXRc+/bGIIxtgqlL+r7PDAxQy8efuzv
         J6qQ==
In-Reply-To: <CAKFNMonzhYBKkjotNiNY0x0DnWxzHYF8WvO7f7xjGwr-8a=aRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

>> As a result the bmap update can be lost, which leads to file system
>> corruption.
> Will review, please wait for a while.

Any chance to get this fix integrated any time soon?
As far as I understand it, nilfs currently ships with a reproduceable
corruption bug, although a fix is available.

Best regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
