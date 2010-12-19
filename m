From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: kernel panic (2.6.36) after file system corruption (?)
Date: Mon, 20 Dec 2010 02:04:12 +0900 (JST)
Message-ID: <20101220.020412.51927139.ryusuke@osrg.net>
References: <AANLkTim3dU2mZMr-BVP0JmSoD9y-UtGT=NTTLmSgiYsU@mail.gmail.com>
	<20101219.141304.213200153.ryusuke@osrg.net>
	<AANLkTika7SunjtX+eMq=22L97T=dHBs0_GFdL8KbKwQ3@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTika7SunjtX+eMq=22L97T=dHBs0_GFdL8KbKwQ3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: fijam7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 19 Dec 2010 13:04:23 +0100, Jan Misiak wrote:
> Thank you for your reply and suggestions. I have tried the following:
> 
> # mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir
>     Results in exactly the same kernel panic.

Two more questions here.

 1) Did the panic arise during mount?

 2) Did you see the following message just before this oops?
   "segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds"

> # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> # find /your-mount-dir -type f -exec cat {} > /dev/null \;
>     Doesn't trigger the oops. I was able to retrieve my data but
> haven't checked them for correctness yet.

I recommend you to backup your data with rsync or tar commands while
you can.

After that, try just a read-only mount without the norecovery option.

 # mount -t nilfs2 -o ro /dev/sdb1 /your-mount-dir

If this trigger the oops during mount, it seems that the recovery code
of nilfs made a violative access.  Nilfs will try the recovery even
for read-only mounts if "norecovery" is not specified.


Regards,
Ryusuke Konishi


On Sun, 19 Dec 2010 13:04:23 +0100, Jan Misiak wrote:
> On 19 December 2010 06:13, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> > Hi,
> > On Sat, 18 Dec 2010 15:08:45 +0100, Jan Misiak wrote:
> >> Hello,
> >>
> >> I am just a simple end-user but as nobody in my distribution has had
> >> the same problem I was forced to turn to the upstream. Please bear
> >> with me.
> >>
> >> I have been using nilfs2 on a 16GB usb-stick on a x86 thin client
> >> running Arch Linux. The box had been running 24/7 and had an uptime of
> >> about two weeks with kernel 2.6.36/nilfs-utils 2.0.20 when it
> >> panicked. Unfortunately nothing was to be seen in the logs (system
> >> partition was ext3). Now it panics every time I attempt to mount the
> >> volume.
> >>
> >> I tried to use netconsole to capture the panic message but it gets
> >> truncated so I had to resort to taking pictures.
> >>
> >> box #1 kernel 2.6.36.2/nilfs-utlis 2.0.20
> >>     http://fijam.eu.org/other/netconsole.log
> >>     http://fijam.eu.org/other/0000.jpg
> >>
> >> I tried to mount the usb-stick on a laptop with the same kernel
> >> (2.6.36.2) to capture more of the panic messages:
> >>
> >> box #2 kernel 2.6.36.2/nilfs-utlis 2.0.20
> >>     http://fijam.eu.org/other/0001.jpeg
> >>     http://fijam.eu.org/other/0002.jpeg
> >>
> >> It crashes when I try to mount with kernel 2.6.32.27 as well:
> >>
> >> box #2 kernel 2.6.32.27/nilfs-utlis 2.0.20
> >>     http://fijam.eu.org/other/0003.jpeg
> >>     http://fijam.eu.org/other/0004.jpeg
> >>
> >> I would be grateful for advice on how can I help with getting to the
> >> bottom of this.
> >>
> >> Regards,
> >> Jan
> >
> > It looks like these oopses were hit in the common block layer code
> > called from the usb mass storage driver.
> >
> > Could you do some tests to narrow down the issue ?
> >
> >  1) Use "nogc" mount option to see whether the oops depends on the
> >    context of garbage collection or not:
> >
> >   # mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir
> >
> >  2) Mount the partition read-only with "norecovery" option and make
> >    read accesses to the filesystem as below:
> >
> >   # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> >   # find /your-mount-dir -type f -exec cat {} > /dev/null \;
> >
> >  3) Try to read the block device directly with "dd":
> >
> >   # dd if=/dev/sdb1 bs=4k > /dev/null
> >
> >  4) Try lssu and lscp commands in the read-only mount to do quick
> >    sanity checks of meta data files.
> >
> >   # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> >   # lssu -a
> >   # lscp
> >
> >
> > Regards,
> > Ryusuke Konishi
> >
> 
> Thank you for your reply and suggestions. I have tried the following:
> 
> # mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir
>     Results in exactly the same kernel panic.
> 
> # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> # find /your-mount-dir -type f -exec cat {} > /dev/null \;
>     Doesn't trigger the oops. I was able to retrieve my data but
> haven't checked them for correctness yet.
> 
> # lssu -a
>     http://fijam.eu.org/other/lssu
> # lscp
>     http://fijam.eu.org/other/lscp
> 
> # dd if=/dev/sdb1 bs=4k > /dev/null
>     Likewise, it doesn't trigger the oops.
> 
> Is there anything else I could do to help?
> 
> Regards,
> Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
