From: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix race condition that causes file system
 corruption
Date: Tue, 24 Oct 2017 10:06:09 -0700
Message-ID: <1508864769.501.5.camel@dubeyko.com>
References: <20170711061907.19259-1-andreas.rohner@gmx.net>
         <CAKFNMonzhYBKkjotNiNY0x0DnWxzHYF8WvO7f7xjGwr-8a=aRQ@mail.gmail.com>
         <CAFvQSYR6vXuyGzGjeogKdg1Xzg=4QDE4TM7r4G-UnZ7hLniDkw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=L/A8w6hgert2zNoYnN5JZRLXyx58R+9/uVZolfsLXAU=;
        b=i/y+zNkktlnBBRmlYSPjBMjDQ8LDS2unPDaD8PEjJbTmUEUjzavi5R/PuPIDtyt69B
         +gLCStkw5/MG+UgCmSyx1bokoroiTZ7bBYeInVQMP3WJBpYDn3oHBStDs3Rg5Kj8LsMZ
         y37bjP2JrZ+ppa4I6vkw5E7itUbJ2XR52TMb/eCksbu2zVWBDbcsTprivxEMMQBE9HF6
         Gjj1LhljywgAZwuPKCv0HtBy9DIGoiDQCWf3usONHhb6kLhZhzqR5OTf0hX2mE12TbSV
         LLlCQNoRbAHvBU+CAsDTqeFgek9WLtw97IEAof14mHcLrbCLS7S39uM8R7v5wP9p4qJs
         Slbw==
In-Reply-To: <CAFvQSYR6vXuyGzGjeogKdg1Xzg=4QDE4TM7r4G-UnZ7hLniDkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2017-10-24 at 05:18 +0200, Clemens Eisserer wrote:
> Hi,
> 
> > 
> > > 
> > > As a result the bmap update can be lost, which leads to file
> > > system
> > > corruption.
> > Will review, please wait for a while.
> Any chance to get this fix integrated any time soon?
> As far as I understand it, nilfs currently ships with a reproduceable
> corruption bug, although a fix is available.


What the patch do you mean? It's pretty impossible to follow your
message.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
