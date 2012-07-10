From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Tue, 10 Jul 2012 14:38:55 +0400
Message-ID: <1341916735.1973.10.camel@slavad-ubuntu-11>
References: <51D5FCEA-7103-4D4A-BADA-99A9780D9B68@dubeyko.com>
	 <20120710.105315.33988123.konishi.ryusuke@lab.ntt.co.jp>
	 <1341904734.1980.17.camel@slavad-ubuntu-11>
	 <20120710.175131.21311203.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=s2fuMCM2OQGe2ij/XdHB+2QZPSjFxIk1SDeA9YrX3is=;
	b=U4MQ1iIgYqV9VN/yBCNvgh5aJ4sfIJGoeHnvY9iOOYMbkbUOHb2tcjgAKHV8z/neXOOvDrum4PYoo8fOZPcQCoSCfdMfQ/pPUTs3b3ELeOz6CGLgcO937TcXBdPWiELB;
In-Reply-To: <20120710.175131.21311203.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Tue, 2012-07-10 at 17:51 +0900, Ryusuke Konishi wrote:
> Ok, this looks a different problem.
>=20
> How is CONFIG_POSIX_MQEUEU ?
> Is it enabled in your kernel ?
>=20
Yes, in my kernel CONFIG_POSIX_MQEUEU option was not enabled. Now, afte=
r
recompilation of kernel with enabled CONFIG_POSIX_MQEUEU option the
nilfs_cleanerd started successfully and working.

I think after analysis of strace output that Piotr Szymaniak has the
same problem. But maybe I wrong.=20

Thanks,
Vyacheslav Dubeyko.

> Regards,
> Ryusuke Konishi
>=20
> > With the best regards,
> > Vyacheslav Dubeyko.
> >=20
> > On Tue, 2012-07-10 at 10:53 +0900, Ryusuke Konishi wrote:
> > > Hi Vyacheslav,
> > > On Mon, 9 Jul 2012 22:55:40 +0400, Vyacheslav Dubeyko wrote:
> > > > Hi Piotr,
> > > >=20
> > > > You are right. I can reproduce this issue very simply. The nilf=
s_cleanerd doesn't started during mount really.
> > > >=20
> > > > I can detect some suspicious output of strace during mount and =
next trying to start of nilfs_cleanerd:
> > > >=20
> > > > ....
> > > > set_tid_address(0xb76a0768)             =3D 21036
> > > > set_robust_list(0xb76a0770, 0xc)        =3D 0
> > > > futex(0xbfdd4f90, FUTEX_WAKE_PRIVATE, 1) =3D 0
> > > > futex(0xbfdd4f90, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIM=
E, 1, NULL, bfdd4fa0) =3D -1 EAGAIN (Resource temporarily unavailable)
> > > >=20
> > > > ....
> > > > mq_open("nilfs-cleanerq-2066", O_RDONLY|O_CREAT, 0600, {mq_maxm=
sg=3D6, mq_msgsize=3D4096}) =3D -1 ENOSYS (Function not implemented)
> > > >=20
> > > > But maybe it is not reason of the problem. It needs to investig=
ate the issue more deeply.
> > >=20
> > > Your problem looks that of FAQ #8 on http://www.nilfs.org/en/faq.=
html
> > >=20
> > > >  8. cleanerd (or chcp/mkcp command) fails with an error: ``cann=
ot open
> > > >     nilfs on /dev/xxx: Function not implemented''.
> > > >
> > > >  Confirm whether tmpfs (former shm fs) is mounted on /dev/shm. =
POSIX
> > > >  semaphores do not work if the filesystem on /dev/shm is wrong,
> > > >  which causes the above failure.
> > > >
> > > >  Some systems are using ramfs instead of tmpfs. You may need to
> > > >  change kernel configuration and rebuild kernel to enable tmpfs=
=2E
> > >=20
> > > Please confirm if tmpfs is mounted on /dev/shm.
> > >=20
> > > The same issue is reported on the following thread:
> > >=20
> > >   http://marc.info/?t=3D133190016900003&r=3D1&w=3D2
> > >=20
> > >=20
> > > Regards,
> > > Ryusuke Konishi
> > >=20
> > > > Thanks,
> > > > Vyacheslav Dubeyko.
> > > >=20
> > > > On Jul 9, 2012, at 8:56 PM, Piotr Szymaniak wrote:
> > > >=20
> > > > > On Mon, Jul 09, 2012 at 01:28:32PM +0400, Vyacheslav Dubeyko =
wrote:
> > > > >> Hi Piotr,
> > > > >>=20
> > > > >> Does system journals on your machines contain any interested=
 details
> > > > >> about reported issue? Could you try to extract some error or=
 warning
> > > > >> messages from system journal?
> > > > >=20
> > > > > (resend as I replied only to Vyacheslav)
> > > > >=20
> > > > > If by journals you mean logs then no. I'm only able to find s=
ome like
> > > > > this:
> > > > > Jul  3 10:32:45 wloczykij nilfs_cleanerd[1434]: resume (clean=
 check)
> > > > > Jul  3 10:41:37 wloczykij nilfs_cleanerd[1434]: pause (clean =
check)
> > > > >=20
> > > > > That's all about nilfs in the last week and current log has o=
nly manual
> > > > > runs related to those operation described before.
> > > > >=20
> > > > > Piotr Szymaniak.
> > > > >=20
> > > > >=20
> > > > >> On Mon, 2012-07-09 at 09:33 +0200, Piotr Szymaniak wrote:
> > > > >>> Hi.
> > > > >>>=20
> > > > >>> I've upgraded nilfs-utils (running Gentoo) on 29 july. Toda=
y I ran out
> > > > >>> of space on my / and found that nilfs_cleanerd isn't workin=
g. When I
> > > > >>> start it from the command line it exits instantly. Also, al=
l previous
> > > > >>> checkpoints on / (also on two other mountpoints on differen=
t machine)
> > > > >>> are gone.
> > > > >>>=20
> > > > >>> What I did? Downgraded nilfs-utils to 2.1.1, remounted moun=
tpoints. On
> > > > >>> the second machine it's runnig fine (cleaned _all_ checkpoi=
nts), on the
> > > > >>> first one with disk space issue it exits just like 2.1.3.
> > > > >>>=20
> > > > >>> Here are some fs details. Machine with disk space issues, r=
ootfs:
> > > > >>>    CNO        DATE     TIME  MODE  FLG     NBLKINC       IC=
NT
> > > > >>> 147688  2012-07-09 08:38:14   cp    -        11075     2429=
15
> > > > >>> 147689  2012-07-09 08:38:14   cp    -           60     2428=
95
> > > > >>> (=E2=80=A6)
> > > > >>> 148999  2012-07-09 09:13:46   cp    -           60     2428=
88
> > > > >>> 149000  2012-07-09 09:19:45   cp    -           44     2428=
88
> > > > >>>=20
> > > > >>> Filesystem      Size  Used Avail Use% Mounted on
> > > > >>> rootfs           24G   13G   11G  56% /
> > > > >>>=20
> > > > >>> mount shows:
> > > > >>> /dev/sda2 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D1=
5356)
> > > > >>>=20
> > > > >>> There's no nilfs_cleanerd with pid 15356.
> > > > >>>=20
> > > > >>>=20
> > > > >>> Second machine rootfs:
> > > > >>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICN=
T
> > > > >>> 92246  2012-07-09 08:16:58   cp    -          118      4466=
9
> > > > >>> (=E2=80=A6)
> > > > >>> 92439  2012-07-09 09:19:14   cp    -           29      4466=
8
> > > > >>> 92440  2012-07-09 09:19:46   cp    -           33      4466=
8
> > > > >>>=20
> > > > >>> Filesystem         Size  Used Avail Use% Mounted on
> > > > >>> rootfs             3.7G  888M  2.6G  26% /
> > > > >>>=20
> > > > >>> (it should be around 3G used)
> > > > >>>=20
> > > > >>> Second machine second mountpoint:
> > > > >>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICN=
T
> > > > >>>  1496  2012-07-09 03:31:23   cp    -         8837     13276=
6
> > > > >>>  1497  2012-07-09 03:31:26   cp    -          468     13276=
6
> > > > >>>  1498  2012-07-09 03:41:27   cp    -         1474     13276=
5
> > > > >>>=20
> > > > >>> (this fs should containt *all* 1498 checkpoints)
> > > > >>>=20
> > > > >>> Filesystem         Size  Used Avail Use% Mounted on
> > > > >>> /dev/dm-2          117G   58G   54G  76% /mnt/home_backup
> > > > >>>=20
> > > > >>> (in this one it should be around 100G of used space)
> > > > >>>=20
> > > > >>> mount:
> > > > >>> /dev/dm-2 on /mnt/home_backup type nilfs2 (rw,gcpid=3D13135=
)
> > > > >>> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D1=
363)
> > > > >>>=20
> > > > >>> Both cleaners running (the second mountpoint - /mnt/home_ba=
ckup - is under
> > > > >>> heavy load and I suppose it will end with around 20G used s=
pace).
> > > > >>>=20
> > > > >>> Where to go from this point? How to debug nilfs_cleanerd is=
sue?
> > > > >>>=20
> > > > >>>=20
> > > > >>> Piotr Szymaniak.
> > > > >>=20
> > > > >>=20
> > > > >> --
> > > > >> To unsubscribe from this list: send the line "unsubscribe li=
nux-nilfs" in
> > > > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > >> More majordomo info at  http://vger.kernel.org/majordomo-inf=
o.html
> > > > >=20
> > > > > --=20
> > > > > Marriage is like a coffin and each kid is like another nail.
> > > > >  -- Homer Simpson
> > > >=20
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux=
-nilfs" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
