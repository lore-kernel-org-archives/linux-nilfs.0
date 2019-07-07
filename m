From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH] nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu()
 in uapi header
Date: Sun, 7 Jul 2019 15:41:20 +0900
Message-ID: <CAK7LNATj1=eRJU_-0cz6rSD01CROvqUb+JVWjNpsKvKarvwA5w@mail.gmail.com>
References: <20190605053006.14332-1-yamada.masahiro@socionext.com>
 <20190706203745.af0bf9bd5dd46e94fa5e1ff9@linux-foundation.org>
 <CAK7LNARCjucs=0BD=00SD8Ljh+a0GtCUNHF4En=eSM1+VG0-4g@mail.gmail.com> <CAKFNMonV+Bsyc6HGP3qSXjrKnQMjhUmQjajt1Dwp0ng7qJaVYA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x676fv60005211
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1562481718;
        bh=LddZA2kZHpmw/iDNZuSU0U5CnFfMo3Z/xtH9eTXkW14=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H7dXqGjiqDI1P7iiUi7enEIEQQAiXFBp1yh27YuU+vgcvEz/VRdYIySA/t7dijNCb
         OIQOS0FWCzIO8RWwXZmWBDZbG80aUFGT/uNgRROCOOqJ2+4v4IAS9iWgDrpoSYEAPO
         q2OFUnrHQxM18EWPLSpY2iwXZg55RaeUwfphXJOxbTL3oXWUFQmtPszFUiaLiRmUwl
         2irpIy4wLZtyqL30FYprTmetKus+9JCTYd6Cii7nANOzc8KAaPeVx8DAV2FN7RRxGp
         xBse/VhPEwtj8ZMm9JECttShg/SxnoUsisesA4gw0h9YU854Cczvq8emWEjBrXoXAp
         tSdtqSG//Nmjw==
In-Reply-To: <CAKFNMonV+Bsyc6HGP3qSXjrKnQMjhUmQjajt1Dwp0ng7qJaVYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Konishi-san,


On Sun, Jul 7, 2019 at 3:11 PM Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:
>
> Yamada-san,
>
> I'm sorry for not being able to follow.
>
> Could you tell me how did you find the build error?
> Still I cannot reproduce the error in my environment.


"You can compile UAPI headers in kernel-space" does not necessarily mean
"you can compile them in user-space".

To make sure UAPI headers can be included from libc etc.
you must compile them after 'make headers_install',
but people often miss to test that.

To automate this testing, I will merge the following for 5.3-rc1:
https://patchwork.kernel.org/patch/11024715/

Once it lands in upstream, all the new breakage
will be caught by 0-day bot.

Currently, nilfs2_ondisk.h is excluded from the test coverage
since it is broken.

Thanks.
Masahiro Yamada



> Or, if it's right that we should not use
> cpu_to_le{16,32,64}/le{16,32,64}_to_cpu() in UAPI  header files,
> I will acknowledge the change and modify nilfs utilities to comply
> with the guideline.
>
> Thanks,
> Ryusuke Konishi
>
> 2019=E5=B9=B47=E6=9C=887=E6=97=A5(=E6=97=A5) 13:31 Masahiro Yamada <yamad=
a.masahiro@socionext.com>:
> >
> > Hi Andrew,
> >
> > On Sun, Jul 7, 2019 at 12:38 PM Andrew Morton <akpm@linux-foundation.or=
g> wrote:
> >
> > >
> > > Seems fairly serious.  I'm thinking this needs a cc:stable?
> >
> >
> > Ah, yes.
> >
> >
> > Cc: linux-stable <stable@vger.kernel.org> # 4.9
> > Fixes: e63e88bc53ba ("nilfs2: move ioctl interface and disk layout to
> > uapi separately")
> >
> >
> > Thanks.
> >
> > --
> > Best Regards
> > Masahiro Yamada



--=20
Best Regards
Masahiro Yamada
