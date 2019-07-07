From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH] nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu()
 in uapi header
Date: Sun, 7 Jul 2019 13:30:37 +0900
Message-ID: <CAK7LNARCjucs=0BD=00SD8Ljh+a0GtCUNHF4En=eSM1+VG0-4g@mail.gmail.com>
References: <20190605053006.14332-1-yamada.masahiro@socionext.com> <20190706203745.af0bf9bd5dd46e94fa5e1ff9@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x674VEU7017936
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1562473875;
        bh=IU0sI9lPOAmBhk7WYcj3uitcIXFJtoxBE1UAngMjX+k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wk3A769fxcaYr7FAEqIx5AV1FOC9WBk0yABfqa6o/GIn+keE7SkMR0w/p5R6oBPLf
         teh97OLt/FoxyUxFMYnqBgW5sCDNYv8mvc/qxKQJhv97nR9LLWfSDRPAl38AwG9+1H
         gcGQIpsvHlCBJi8NAsVx/9N+ijkstQNGMmEg/AYeGc0myr0gQUW56j/9BMIpTC1bpV
         9OP4PtjRSIJkwsWLBiyibDUj/WVmYUdVAISC5zsRAtWP4kY7pOR30NRl3IMKqQ7TUi
         R73NJCdri/Jr/J4rm+0f/Z4A7EunSS16TSqWwdJNQ0eqNgJ1ejS3wW/h2HpYqpHoFP
         XZgoV311I2oyw==
In-Reply-To: <20190706203745.af0bf9bd5dd46e94fa5e1ff9@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi Andrew,

On Sun, Jul 7, 2019 at 12:38 PM Andrew Morton <akpm@linux-foundation.org> wrote:

>
> Seems fairly serious.  I'm thinking this needs a cc:stable?


Ah, yes.


Cc: linux-stable <stable@vger.kernel.org> # 4.9
Fixes: e63e88bc53ba ("nilfs2: move ioctl interface and disk layout to
uapi separately")


Thanks.

-- 
Best Regards
Masahiro Yamada
