From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] nilfs2: do not use unexported
 cpu_to_le32()/le32_to_cpu() in uapi header
Date: Sat, 6 Jul 2019 20:37:45 -0700
Message-ID: <20190706203745.af0bf9bd5dd46e94fa5e1ff9@linux-foundation.org>
References: <20190605053006.14332-1-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562470666;
        bh=NSUhT03/N1dAomU6Y1lmRVJq8O8g6qPmcXLaYh8VDWA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XjyayPdPoyHC8PvLyHFWTlMsNu5kqeAU7JgVQGm/FtWxLlmz4ps41cHsRprYaDNlj
         0qKmAc4F+5/rHdXFWZzR0ifJSi/WWxAGCPPA29bEaRxqq130WhKf2NtbJ8KWj4kriy
         QVFGNOS52WsfjqPK8mnsf0XX59oz5j2Nw0h2hnuM=
In-Reply-To: <20190605053006.14332-1-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org

On Wed,  5 Jun 2019 14:30:06 +0900 Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> cpu_to_le32/le32_to_cpu is defined in include/linux/byteorder/generic.h,
> which is not exported to user-space.
> 
> UAPI headers must use the ones prefixed with double-underscore.
> 
> Detected by compile-testing exported headers:
> 
> ./usr/include/linux/nilfs2_ondisk.h: In function ‘nilfs_checkpoint_set_snapshot’:
> ./usr/include/linux/nilfs2_ondisk.h:536:17: error: implicit declaration of function ‘cpu_to_le32’ [-Werror=implicit-function-declaration]
>   cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
>                  ^
> ./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro ‘NILFS_CHECKPOINT_FNS’
>  NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
>  ^~~~~~~~~~~~~~~~~~~~
> ./usr/include/linux/nilfs2_ondisk.h:536:29: error: implicit declaration of function ‘le32_to_cpu’ [-Werror=implicit-function-declaration]
>   cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
>                              ^
> ./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro ‘NILFS_CHECKPOINT_FNS’
>  NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
>  ^~~~~~~~~~~~~~~~~~~~
> ./usr/include/linux/nilfs2_ondisk.h: In function ‘nilfs_segment_usage_set_clean’:
> ./usr/include/linux/nilfs2_ondisk.h:622:19: error: implicit declaration of function ‘cpu_to_le64’ [-Werror=implicit-function-declaration]
>   su->su_lastmod = cpu_to_le64(0);
>                    ^~~~~~~~~~~

Seems fairly serious.  I'm thinking this needs a cc:stable?
