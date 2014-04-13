From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: few patches from Debian
Date: Mon, 14 Apr 2014 06:36:54 +0900 (JST)
Message-ID: <20140414.063654.356443912.konishi.ryusuke@lab.ntt.co.jp>
References: <2256155.lyPQvkPv8r@debstor>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2256155.lyPQvkPv8r@debstor>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dmitry,
On Fri, 11 Apr 2014 17:49:43 +1000, Dmitry Smirnov wrote:
> Dear NILFS team,
> 
> Thanks for your hard work and for new release of nilfs-tools.
> 
> I'd like to share two patches (attached) to fix some minor problems that I've 
> noticed:
> 
>  * man.patch (with minor man pages corrections)
>  * fhs.patch (to install nilfs-* executables to "/usr/sbin" instead of "/sbin"
>    due to library dependencies in "/usr").
> 
> Please review and apply (if appropriate).
> Also please CC to me as I'm not subscribed.

fhs.patch introduced the following error:

 $ ./autogen.sh
 $ ./configure
 $ make
 $ sudo make install
 ...
 make[2]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
 make[3]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
  /bin/mkdir -p '/etc'
  /usr/bin/install -c -m 644 nilfs_cleanerd.conf '/etc'
  /bin/mkdir -p 'NONE/sbin'
   /bin/sh ../../libtool   --mode=install /usr/bin/install -c nilfs_cleanerd 'NONE/sbin'
 libtool: install: `NONE/sbin' must be an absolute directory name
 libtool: install: Try `libtool --help --mode=install' for more information.
 make[3]: *** [install-sbinPROGRAMS] Error 1
 make[3]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
 make[2]: *** [install-am] Error 2
 make[2]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
 make[1]: *** [install-recursive] Error 1
 make[1]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin'
 make: *** [install-recursive] Error 1

Can you fix this error ?

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
