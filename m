From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: few patches from Debian
Date: Sat, 19 Apr 2014 19:58:16 +0900 (JST)
Message-ID: <20140419.195816.57462893.konishi.ryusuke@lab.ntt.co.jp>
References: <2256155.lyPQvkPv8r@debstor>
	<20140414.063654.356443912.konishi.ryusuke@lab.ntt.co.jp>
	<6284364.q7fsBQ3iYY@debstor>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6284364.q7fsBQ3iYY@debstor>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 16 Apr 2014 11:22:48 +1000, Dmitry Smirnov wrote:
> On Mon, 14 Apr 2014 06:36:54 Ryusuke Konishi wrote:
>> fhs.patch introduced the following error:
>> 
>>  $ ./autogen.sh
>>  $ ./configure
>>  $ make
>>  $ sudo make install
>>  ...
>>  make[2]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>>  make[3]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>>   /bin/mkdir -p '/etc'
>>   /usr/bin/install -c -m 644 nilfs_cleanerd.conf '/etc'
>>   /bin/mkdir -p 'NONE/sbin'
>>    /bin/sh ../../libtool   --mode=install /usr/bin/install -c nilfs_cleanerd
>> 'NONE/sbin' libtool: install: `NONE/sbin' must be an absolute directory
>> name
>>  libtool: install: Try `libtool --help --mode=install' for more information.
>> make[3]: *** [install-sbinPROGRAMS] Error 1
>>  make[3]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>>  make[2]: *** [install-am] Error 2
>>  make[2]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>>  make[1]: *** [install-recursive] Error 1
>>  make[1]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin'
>>  make: *** [install-recursive] Error 1
>> 
>> Can you fix this error ?
> 
> O, my bad, sorry...
> Strangely enough I did not hit this error because I was explicitly passing
> "--prefix=/usr" to "./configure".
> 
> Please find updated patch attached. It should be fine but there might be more 
> elegant way to implement this with autotools.

This patch breaks mount program; mount.nilfs2 fails to find cleanerd
since it was moved to /usr/sbin:

  # mount -t nilfs2 /dev/sdb1 /test
  mount.nilfs2: Error: nilfs_cleanerd not found
  nilfs_cleanerd aborted

I think nilfs_cleanerd should be installed to /sbin.

> By the way it's pretty scary to do 
> 
>     sudo make install
> 
> I'd rather invoke as (for example) as:
> 
>     make install DESTDIR=/tmp/nilfs-tools.test
> 
> Thank you.
> 
> -- 
> Regards,
>  Dmitry Smirnov.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
