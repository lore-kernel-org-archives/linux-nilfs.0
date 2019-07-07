From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu()
 in uapi header
Date: Sun, 7 Jul 2019 15:11:15 +0900
Message-ID: <CAKFNMonV+Bsyc6HGP3qSXjrKnQMjhUmQjajt1Dwp0ng7qJaVYA@mail.gmail.com>
References: <20190605053006.14332-1-yamada.masahiro@socionext.com>
 <20190706203745.af0bf9bd5dd46e94fa5e1ff9@linux-foundation.org> <CAK7LNARCjucs=0BD=00SD8Ljh+a0GtCUNHF4En=eSM1+VG0-4g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK7LNARCjucs=0BD=00SD8Ljh+a0GtCUNHF4En=eSM1+VG0-4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Yamada-san,

I'm sorry for not being able to follow.

Could you tell me how did you find the build error?
Still I cannot reproduce the error in my environment.

Or, if it's right that we should not use
cpu_to_le{16,32,64}/le{16,32,64}_to_cpu() in UAPI  header files,
I will acknowledge the change and modify nilfs utilities to comply
with the guideline.

Thanks,
Ryusuke Konishi

2019年7月7日(日) 13:31 Masahiro Yamada <yamada.masahiro@socionext.com>:
>
> Hi Andrew,
>
> On Sun, Jul 7, 2019 at 12:38 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> >
> > Seems fairly serious.  I'm thinking this needs a cc:stable?
>
>
> Ah, yes.
>
>
> Cc: linux-stable <stable@vger.kernel.org> # 4.9
> Fixes: e63e88bc53ba ("nilfs2: move ioctl interface and disk layout to
> uapi separately")
>
>
> Thanks.
>
> --
> Best Regards
> Masahiro Yamada
