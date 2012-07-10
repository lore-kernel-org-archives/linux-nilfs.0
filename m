From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Tue, 10 Jul 2012 17:51:31 +0900 (JST)
Message-ID: <20120710.175131.21311203.konishi.ryusuke@lab.ntt.co.jp>
References: <51D5FCEA-7103-4D4A-BADA-99A9780D9B68@dubeyko.com>
	<20120710.105315.33988123.konishi.ryusuke@lab.ntt.co.jp>
	<1341904734.1980.17.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341904734.1980.17.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 10 Jul 2012 11:18:54 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> Unfortunately, my kernel is compiled with enabled CONFIG_SHMEM and
> CONFIG_TMPFS options. Moreover, I can see that /dev/shm mounted with
> tmpfs type:
> 
> linux-2.6.34-gentoo-r6 # mount
> /dev/sda3 on / type xfs (rw,noatime)
> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> udev on /dev type tmpfs (rw,nosuid,relatime,size=10240k,mode=755)
> devpts on /dev/pts type devpts
> (rw,nosuid,noexec,relatime,gid=5,mode=620)
> shm on /dev/shm type tmpfs (rw,noexec,nosuid,nodev)
> usbfs on /proc/bus/usb type usbfs
> (rw,noexec,nosuid,devmode=0664,devgid=85)
> /dev/sdb2 on /mnt/nilfs2 type nilfs2 (rw,gcpid=6331)
> 
> And it is possible to see it from strace output also (tmpfs magic -
> 0x1021994):
> 
> statfs("/dev/shm", {f_type=0x1021994, f_bsize=4096, f_blocks=64251,
> f_bfree=64250, f_bavail=64250, f_files=64251, f_ffree=64249, f_fsid={0,
> 0}, f_namelen=255, f_frsize=4096}) = 0
> 
> However, I have not last stable kernel on its machine
> (2.6.34-gentoo-r6). Maybe, it can make some side effects.
> 
> I am going to continue investigation of the issue. I attach to the
> e-mail full strace output (10-07-2012-nilfs-cleanerd-issue.txt).

Ok, this looks a different problem.

How is CONFIG_POSIX_MQEUEU ?
Is it enabled in your kernel ?

Regards,
Ryusuke Konishi

> With the best regards,
> Vyacheslav Dubeyko.
> 
> On Tue, 2012-07-10 at 10:53 +0900, Ryusuke Konishi wrote:
> > Hi Vyacheslav,
> > On Mon, 9 Jul 2012 22:55:40 +0400, Vyacheslav Dubeyko wrote:
> > > Hi Piotr,
> > > 
> > > You are right. I can reproduce this issue very simply. The nilfs_cleanerd doesn't started during mount really.
> > > 
> > > I can detect some suspicious output of strace during mount and next trying to start of nilfs_cleanerd:
> > > 
> > > ....
> > > set_tid_address(0xb76a0768)             = 21036
> > > set_robust_list(0xb76a0770, 0xc)        = 0
> > > futex(0xbfdd4f90, FUTEX_WAKE_PRIVATE, 1) = 0
> > > futex(0xbfdd4f90, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, bfdd4fa0) = -1 EAGAIN (Resource temporarily unavailable)
> > > 
> > > ....
> > > mq_open("nilfs-cleanerq-2066", O_RDONLY|O_CREAT, 0600, {mq_maxmsg=6, mq_msgsize=4096}) = -1 ENOSYS (Function not implemented)
> > > 
> > > But maybe it is not reason of the problem. It needs to investigate the issue more deeply.
> > 
> > Your problem looks that of FAQ #8 on http://www.nilfs.org/en/faq.html
> > 
> > >  8. cleanerd (or chcp/mkcp command) fails with an error: ``cannot open
> > >     nilfs on /dev/xxx: Function not implemented''.
> > >
> > >  Confirm whether tmpfs (former shm fs) is mounted on /dev/shm. POSIX
> > >  semaphores do not work if the filesystem on /dev/shm is wrong,
> > >  which causes the above failure.
> > >
> > >  Some systems are using ramfs instead of tmpfs. You may need to
> > >  change kernel configuration and rebuild kernel to enable tmpfs.
> > 
> > Please confirm if tmpfs is mounted on /dev/shm.
> > 
> > The same issue is reported on the following thread:
> > 
> >   http://marc.info/?t=133190016900003&r=1&w=2
> > 
> > 
> > Regards,
> > Ryusuke Konishi
> > 
> > > Thanks,
> > > Vyacheslav Dubeyko.
> > > 
> > > On Jul 9, 2012, at 8:56 PM, Piotr Szymaniak wrote:
> > > 
> > > > On Mon, Jul 09, 2012 at 01:28:32PM +0400, Vyacheslav Dubeyko wrote:
> > > >> Hi Piotr,
> > > >> 
> > > >> Does system journals on your machines contain any interested details
> > > >> about reported issue? Could you try to extract some error or warning
> > > >> messages from system journal?
> > > > 
> > > > (resend as I replied only to Vyacheslav)
> > > > 
> > > > If by journals you mean logs then no. I'm only able to find some like
> > > > this:
> > > > Jul  3 10:32:45 wloczykij nilfs_cleanerd[1434]: resume (clean check)
> > > > Jul  3 10:41:37 wloczykij nilfs_cleanerd[1434]: pause (clean check)
> > > > 
> > > > That's all about nilfs in the last week and current log has only manual
> > > > runs related to those operation described before.
> > > > 
> > > > Piotr Szymaniak.
> > > > 
> > > > 
> > > >> On Mon, 2012-07-09 at 09:33 +0200, Piotr Szymaniak wrote:
> > > >>> Hi.
> > > >>> 
> > > >>> I've upgraded nilfs-utils (running Gentoo) on 29 july. Today I ran out
> > > >>> of space on my / and found that nilfs_cleanerd isn't working. When I
> > > >>> start it from the command line it exits instantly. Also, all previous
> > > >>> checkpoints on / (also on two other mountpoints on different machine)
> > > >>> are gone.
> > > >>> 
> > > >>> What I did? Downgraded nilfs-utils to 2.1.1, remounted mountpoints. On
> > > >>> the second machine it's runnig fine (cleaned _all_ checkpoints), on the
> > > >>> first one with disk space issue it exits just like 2.1.3.
> > > >>> 
> > > >>> Here are some fs details. Machine with disk space issues, rootfs:
> > > >>>    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> > > >>> 147688  2012-07-09 08:38:14   cp    -        11075     242915
> > > >>> 147689  2012-07-09 08:38:14   cp    -           60     242895
> > > >>> (…)
> > > >>> 148999  2012-07-09 09:13:46   cp    -           60     242888
> > > >>> 149000  2012-07-09 09:19:45   cp    -           44     242888
> > > >>> 
> > > >>> Filesystem      Size  Used Avail Use% Mounted on
> > > >>> rootfs           24G   13G   11G  56% /
> > > >>> 
> > > >>> mount shows:
> > > >>> /dev/sda2 on / type nilfs2 (rw,noatime,nodiratime,gcpid=15356)
> > > >>> 
> > > >>> There's no nilfs_cleanerd with pid 15356.
> > > >>> 
> > > >>> 
> > > >>> Second machine rootfs:
> > > >>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> > > >>> 92246  2012-07-09 08:16:58   cp    -          118      44669
> > > >>> (…)
> > > >>> 92439  2012-07-09 09:19:14   cp    -           29      44668
> > > >>> 92440  2012-07-09 09:19:46   cp    -           33      44668
> > > >>> 
> > > >>> Filesystem         Size  Used Avail Use% Mounted on
> > > >>> rootfs             3.7G  888M  2.6G  26% /
> > > >>> 
> > > >>> (it should be around 3G used)
> > > >>> 
> > > >>> Second machine second mountpoint:
> > > >>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> > > >>>  1496  2012-07-09 03:31:23   cp    -         8837     132766
> > > >>>  1497  2012-07-09 03:31:26   cp    -          468     132766
> > > >>>  1498  2012-07-09 03:41:27   cp    -         1474     132765
> > > >>> 
> > > >>> (this fs should containt *all* 1498 checkpoints)
> > > >>> 
> > > >>> Filesystem         Size  Used Avail Use% Mounted on
> > > >>> /dev/dm-2          117G   58G   54G  76% /mnt/home_backup
> > > >>> 
> > > >>> (in this one it should be around 100G of used space)
> > > >>> 
> > > >>> mount:
> > > >>> /dev/dm-2 on /mnt/home_backup type nilfs2 (rw,gcpid=13135)
> > > >>> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=1363)
> > > >>> 
> > > >>> Both cleaners running (the second mountpoint - /mnt/home_backup - is under
> > > >>> heavy load and I suppose it will end with around 20G used space).
> > > >>> 
> > > >>> Where to go from this point? How to debug nilfs_cleanerd issue?
> > > >>> 
> > > >>> 
> > > >>> Piotr Szymaniak.
> > > >> 
> > > >> 
> > > >> --
> > > >> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > > -- 
> > > > Marriage is like a coffin and each kid is like another nail.
> > > >  -- Homer Simpson
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
