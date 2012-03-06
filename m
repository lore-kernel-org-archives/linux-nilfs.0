From: Slicky Devil <slicky.dvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000048
Date: Wed, 7 Mar 2012 00:07:24 +0300
Message-ID: <CAMRzUtyoYPzCYhqaxughGOBWr_iUcFyOx5p1eBYJRa19xq8Xgg@mail.gmail.com>
References: <CAMRzUtxbOXWOyZ1wMRmxSsRs67FoDq_hf7Pg_UrAi4P=DnhqsA@mail.gmail.com>
	<20120305.233028.248350005.ryusuke@osrg.net>
	<CAMRzUtwpZQ_ZmZoGzOA0wkmTVQKVJRwA7OB3X_ktRXPj9MJoXA@mail.gmail.com>
	<20120306.235404.52180631.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=VXW+s/7qpisiAlNfGtJf8PSB2ZAKijs5gMc+hQtHGE4=;
        b=c/SAiWywZz8sUlzVIo27OW/bYD3uQVBe0PTchuNsjSiGOIGB6ciChAD5roYTKthWNS
         jwRsgZQY6R0KUPVvRzhkDL3SGzAhvS4ccjCLHa7TGwxWVpudemw/xedw8BkETl8mUIhJ
         tsk+1KzU5voWt7tHIDcmfU+0sbN93Vdg364HflmLuW0yqwO4VxJn7lo8Bd8L3aqWHIv/
         BioHrWDX6Mu7dwu+DFKa6QuLjF3CMTB5dyae8WqPz4vA3XeIDowBpFQkPatyxXscYDoz
         eAT4j6lsinjeGaMIudPtY2Ac0LtPdC8ioLv7wDsGk+r7K/tHyNM/yOQBE9o+FZEiSWZP
         sw4g==
In-Reply-To: <20120306.235404.52180631.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 6, 2012 at 5:54 PM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> Hmmm. =A0Did you shrink the filesystem with nilfs-resize tool
> before shrinking the partition ?
>
> This error (I/O error) also looks undesirable to me.

I couldn't shrink the filesystem, because I couldn't mount it because
of the bug. The filesystem was large and I was in desparate need of
some spare diskspace. At first, I was going to completely get rid of
it, but then I thought you might want to have a look at the
superblock, or some othe block, or whatever else to analyze the bug.
Since the bug was some sort of initialization issue, I finally decided
to keep the first 500 MB of the filesystem and reclaimed the rest of
it (by shrinking the partition).

And all that had happened *before* I posted the bug report on this mail=
ing list.

Luckily, when I tried to mount the "broken" filesystem today, the
nilfs driver exposed the very same oops again. I applied your
patch/recompiled the kernel and the oops disappeared.

So, no. I didn't use any nilfs-resize. And those IO error are pretty
much expected to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
