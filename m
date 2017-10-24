From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix race condition that causes file system corruption
Date: Tue, 24 Oct 2017 21:29:31 +0200
Message-ID: <CAFvQSYT86rbcPCCAYxfALOcDTcUYNrUuhuheVfv=5Twx17C-pg@mail.gmail.com>
References: <20170711061907.19259-1-andreas.rohner@gmx.net>
 <CAKFNMonzhYBKkjotNiNY0x0DnWxzHYF8WvO7f7xjGwr-8a=aRQ@mail.gmail.com>
 <CAFvQSYR6vXuyGzGjeogKdg1Xzg=4QDE4TM7r4G-UnZ7hLniDkw@mail.gmail.com> <1508864769.501.5.camel@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=3IguKZt/9uZ2coFePpdl23DWFXdPxyV44mUrgYAhzt0=;
        b=KFEPCQ0U4V49/h1S2lSmLNr8ubQXtI/Eu4Yi1dDsvP1NrQ8Ej4lAIkPV2bdIJCBu9s
         d10mLRVoiagVktP+7+rDY/CFsKAU7wFavfJqJ4T2LY2Tw+6MTkhjlUokqeTYwpt0KR7s
         NFof9Zk4J4rDIOxJgVNy9KnWuSy0Iva4kBJ4mNf4YwE1QVBbvfXo5oiry/CAqJArworZ
         X4H0L24VWaCTQYi9l9o8Q8c+OeLkGte15xpH4JrqgU5ofj+It9+XlR3aZvt4xpZYWsP4
         B+q5qPGwg59kUWMJgpFjaVSsIFBAoVFw8GRHVKVqC1xwH5UiKFraMx5Q7jbYS1I+N12g
         9kyA==
In-Reply-To: <1508864769.501.5.camel-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

HI Vyacheslav,

>> > > As a result the bmap update can be lost, which leads to file
>> > > system
>> > > corruption.
>> > Will review, please wait for a while.
>> Any chance to get this fix integrated any time soon?
>> As far as I understand it, nilfs currently ships with a reproduceable
>> corruption bug, although a fix is available.
>
>
> What the patch do you mean? It's pretty impossible to follow your
> message.

Sorry for the confusion, I guess I am mollycoddled by gmail's thread view.

I was referring to a patch sent by Andreas Rohner on 11.7. which fixes
a race that can lead to filesystem corruption.

Best regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
