From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Is NILFS2 suitable for long term archival storage?
Date: Thu, 23 Jun 2022 12:46:48 +0900
Message-ID: <CAKFNMokCAegqoej8o2EK4QFVFeXoob1b1Zug+Lx+2jM8PeCe5Q@mail.gmail.com>
References: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA@mail.gmail.com>
 <YrMHJYobUpjv+KRj@kelsos> <CA+Tk8fywv3sL1wLcZioWACCBfMPpDCqrKEXnvuzH0q6GP9FCWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UHWe+AqQbXL1+Nmqri62sq/R0WS4/yHfHIvfHlvtoQA=;
        b=g0IEjL5wDRtNuTH559JoYvQy1yzpIX2+0e6zYC1NdtRVGcstYUB0GfBAgJfBZ1FAf8
         QkFZRgLk+RSHendi6Su8/HJT9gUZsivfWpjNLy8YlQUFUxNpmbUxuD4DMFgMS44uqC1C
         l264BPpp+7RON0ygyIoZqxVo5yTK3DeHOXVjTLs+a96I30ANb3fislxZNfzzVhwNnYh7
         z6hh/9I4uzdluj1KLbj3YjYsdT5nw7ERMocGWdiB240+wYfXrbEvLgY+euloMbNTb2Ea
         s4/igW3PP2ory4JIcJinzjsDFgBeprfWdUKkysCOjAIeY7bdFXxKscYefU7hQerqs0FY
         KDbA==
In-Reply-To: <CA+Tk8fywv3sL1wLcZioWACCBfMPpDCqrKEXnvuzH0q6GP9FCWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tommy Pettersson <ptp-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>

On Wed, Jun 22, 2022 at 11:39 PM Ciprian Craciun wrote:
> On 6/22/22 15:12, Tommy Pettersson wrote:
> > Yet another curiosity I have had to deal with is symlink
> > properties. The standard says that rwx properties of
> > symlinks may be set to anything but should be ignored. All
> > filesystems I have used sets them to 777, except for nilfs2,
> > which honors the current umask value. Now, rsync, which is
> > probably to blame here, tries to update the properties on
> > symlinks, and if it reads from nilfs2, and gets something
> > other than 777, it can not set this other value if the
> > target is not also nilfs2, and will think it has failed. The
> > only workaround I have come up with is to find all symlinks
> > on nilfs2 and update their permission to 777.
>
>
> I've seen this weird behaviour and doesn't bother me.

Ugh, this looks like a bug (or regression).
I will look into what's happening.

Ryusuke Konishi
