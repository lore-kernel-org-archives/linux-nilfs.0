From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: kernel panic (2.6.36) after file system corruption (?)
Date: Sun, 19 Dec 2010 14:13:04 +0900 (JST)
Message-ID: <20101219.141304.213200153.ryusuke@osrg.net>
References: <AANLkTim3dU2mZMr-BVP0JmSoD9y-UtGT=NTTLmSgiYsU@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim3dU2mZMr-BVP0JmSoD9y-UtGT=NTTLmSgiYsU-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: fijam7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Sat, 18 Dec 2010 15:08:45 +0100, Jan Misiak wrote:
> Hello,
> 
> I am just a simple end-user but as nobody in my distribution has had
> the same problem I was forced to turn to the upstream. Please bear
> with me.
> 
> I have been using nilfs2 on a 16GB usb-stick on a x86 thin client
> running Arch Linux. The box had been running 24/7 and had an uptime of
> about two weeks with kernel 2.6.36/nilfs-utils 2.0.20 when it
> panicked. Unfortunately nothing was to be seen in the logs (system
> partition was ext3). Now it panics every time I attempt to mount the
> volume.
> 
> I tried to use netconsole to capture the panic message but it gets
> truncated so I had to resort to taking pictures.
> 
> box #1 kernel 2.6.36.2/nilfs-utlis 2.0.20
>     http://fijam.eu.org/other/netconsole.log
>     http://fijam.eu.org/other/0000.jpg
> 
> I tried to mount the usb-stick on a laptop with the same kernel
> (2.6.36.2) to capture more of the panic messages:
> 
> box #2 kernel 2.6.36.2/nilfs-utlis 2.0.20
>     http://fijam.eu.org/other/0001.jpeg
>     http://fijam.eu.org/other/0002.jpeg
> 
> It crashes when I try to mount with kernel 2.6.32.27 as well:
> 
> box #2 kernel 2.6.32.27/nilfs-utlis 2.0.20
>     http://fijam.eu.org/other/0003.jpeg
>     http://fijam.eu.org/other/0004.jpeg
> 
> I would be grateful for advice on how can I help with getting to the
> bottom of this.
> 
> Regards,
> Jan

It looks like these oopses were hit in the common block layer code
called from the usb mass storage driver.

Could you do some tests to narrow down the issue ?

 1) Use "nogc" mount option to see whether the oops depends on the
    context of garbage collection or not:

   # mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir

 2) Mount the partition read-only with "norecovery" option and make
    read accesses to the filesystem as below:

   # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
   # find /your-mount-dir -type f -exec cat {} > /dev/null \;

 3) Try to read the block device directly with "dd":

   # dd if=/dev/sdb1 bs=4k > /dev/null

 4) Try lssu and lscp commands in the read-only mount to do quick
    sanity checks of meta data files.

   # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
   # lssu -a
   # lscp


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
