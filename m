From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Response to a Write Error
Date: Fri, 16 Apr 2010 21:31:51 +0900 (JST)
Message-ID: <20100416.213151.77349735.ryusuke@osrg.net>
References: <t2kf2d3ba1f1004131638nb61e68cek1ecb43a86c316d35@mail.gmail.com>
	<20100415.015106.58888665.ryusuke@osrg.net>
	<j2kf2d3ba1f1004141746n9f914465q3e24d48bec7f990e@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <j2kf2d3ba1f1004141746n9f914465q3e24d48bec7f990e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: third07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi
On Wed, 14 Apr 2010 20:46:46 -0400, "Ed F." <third07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > The following are the steps to make&install a newer nilfs in the
> > 2.6.31 kernel.
> >
> >  $ sudo apt-get install linux-headers-`uname -r`
> >  $ cd /usr/src
> >  $ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.11.tar.bz2
> >  $ tar jxf linux-2.6.32.11.tar.bz2
> >  $ cd linux-2.6.32.11/fs/nilfs2
> >  $ make -C /lib/modules/`uname -r`/build SUBDIRS=$PWD BUILD_DIR=$PWD modules
> >  $ su
> >  # rmmod nilfs2
> >  # mv /lib/modules/`uname -r`/kernel/fs/nilfs2/nilfs2.ko{,.bak}
> >  # install -m 644 -c nilfs2.ko /lib/modules/`uname -r`/kernel/fs/nilfs2/
> >  # /sbin/depmod -A
> >  # mount -t nilfs2 <device> <mount-dir>
> 
> Thank you for clarifying that process.  It will be very useful in
> keeping the kernel module up-to-date.

Please note that this procedure is not guaranteed.  This may not work
for some version since internal implementation or semantics of the
kernel often changes.

> If my analysis is correct, I have a DVD-RAM disk that has no more
> sectors with which my DVD drive can correct defects.  Would you like
> for me to save that disk for future error handling experiments?

Thanks for the offer.
I have interests in what happens on the latest kernel.
If you have an opportunity to try it, please report the result.

Ideally, it is expected to skip erroneous segments.
In reality, something unexpected may happen ;)

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
