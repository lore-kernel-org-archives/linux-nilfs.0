From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 13 Nov 2012 16:28:56 +0100
Message-ID: <20121113152856.GP25100@wloczykij>
References: <50A159BC.9060600@li.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DfnuYBTqzt7sVGu3"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50A159BC.9060600-3TRaYzfGuuI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--DfnuYBTqzt7sVGu3
Content-Type: multipart/mixed; boundary="0FRtVia6Q6lt+M0P"
Content-Disposition: inline


--0FRtVia6Q6lt+M0P
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 12:19:08AM +0400, fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org wrote:
> Hello!
> Some time ago I've noticed, that "flush" kernel process associated with=
=20
> device running nilfs2 filesystem, generate huge amount of IO activity=20
> (using 100% CPU time). "iotop" utility show speeds about 5-15 GB\S on=20
> that "flush" process, but no actual disk activity happens.
> This condition lasts about 1-2 minutes, and then it stops for some time=
=20
> (usually 10-20 minutes).

I can confirm this (but never bothered to check what caused it). But I
saw some huge load (few days ago) on 1 CPU core that was stopped
immediately after runnig "sync". This could be the same as mentioned
here.

And I just checked that machine and it eats my CPU. ps ax attached.


Piotr Szymaniak.
--=20
 - You know nothing about woman!
 - Of course not, I'm a man, so how could I know?
  -- Berserk

--0FRtVia6Q6lt+M0P
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="ps.out"
Content-Transfer-Encoding: quoted-printable

  PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:00 init [3] =20
    2 ?        S      0:00 [kthreadd]
    3 ?        S      0:00 [ksoftirqd/0]
    4 ?        S      0:10 [kworker/0:0]
    5 ?        S<     0:00 [kworker/0:0H]
    7 ?        S<     0:00 [kworker/u:0H]
    8 ?        S      0:00 [migration/0]
    9 ?        S      0:00 [migration/1]
   11 ?        S<     0:00 [kworker/1:0H]
   12 ?        S      0:00 [ksoftirqd/1]
   13 ?        S<     0:00 [khelper]
   14 ?        S      0:00 [kdevtmpfs]
  149 ?        S      0:00 [bdi-default]
  151 ?        S<     0:00 [kblockd]
  274 ?        S<     0:00 [ata_sff]
  281 ?        S<     0:00 [md]
  397 ?        S      0:00 [kswapd0]
  398 ?        S      0:00 [fsnotify_mark]
  400 ?        S<     0:00 [crypto]
  441 ?        S<     0:00 [ttm_swap]
  472 ?        S      0:00 [scsi_eh_0]
  475 ?        S      0:00 [scsi_eh_1]
  478 ?        S      0:00 [scsi_eh_2]
  481 ?        S      0:00 [scsi_eh_3]
  484 ?        S      0:00 [scsi_eh_4]
  487 ?        S      0:00 [scsi_eh_5]
  491 ?        S      0:00 [kworker/u:3]
  492 ?        S      0:00 [kworker/u:4]
  508 ?        S<     0:00 [kpsmoused]
  522 ?        S<     0:00 [deferwq]
  567 ?        S      0:00 [md5_raid1]
  573 ?        S      0:00 [md1_raid1]
  577 ?        S      0:00 [md0_raid1]
  693 ?        Ss     0:00 /usr/lib/systemd/systemd-udevd --daemon
  757 ?        S      0:00 [scsi_eh_6]
  758 ?        S      0:00 [scsi_eh_7]
  760 ?        S      0:00 [khubd]
  767 ?        S<     0:00 [kworker/0:1H]
  793 ?        S<     0:00 [kworker/1:1H]
 1030 ?        S<     0:00 [iprt]
 1106 ?        S<     0:00 [hci0]
 1107 ?        S<     0:00 [kworker/u:1H]
 1130 ?        S      0:02 [segctord]
 1193 ?        S      0:00 [jbd2/md5-8]
 1194 ?        S<     0:00 [ext4-dio-unwrit]
 1195 ?        S<     0:00 [loop0]
 1202 ?        Ss     0:00 /usr/sbin/mount.ntfs-3g /dev/sdd1 /mnt/ce -o rw,=
locale=3Dpl_PL.utf8
 1205 ?        Ss     0:00 /usr/sbin/mount.ntfs-3g /dev/sdd5 /mnt/de -o rw,=
locale=3Dpl_PL.utf8
 1208 ?        Ss     0:00 /usr/sbin/mount.ntfs-3g /dev/sde1 /mnt/ef -o rw,=
locale=3Dpl_PL.utf8
 1607 ?        Ss     0:00 /usr/bin/dbus-daemon --system
 1621 ?        Ss     0:00 metalog [MASTER]                                =
           =20
 1622 ?        S      0:00 metalog [KERNEL]                                =
           =20
 1637 ?        Ssl    0:00 /usr/sbin/console-kit-daemon
 1712 ?        Sl     0:01 /usr/lib/polkit-1/polkitd --no-debug
 1920 ?        Ss     0:00 /usr/bin/kdm
 1924 ?        R    111:40 [flush-8:0]
 1926 tty7     Ss+    8:59 /usr/bin/X -br -novtswitch -quiet :0 vt7 -nolist=
en tcp -auth /var/run/xauth/A:0-c2i4Cb
 1950 ?        S      0:00 -:0        =20
 1973 ?        SNs    0:00 /usr/bin/distccd --daemon --pid-file /var/run/di=
stccd/distccd.pid --port 3632 --log-file /var/log/distccd.log --log-level c=
ritical --allow 192.168.1.1 --allow 10.0.0.0/24 -N 15
 1975 ?        SN     0:00 /usr/bin/distccd --daemon --pid-file /var/run/di=
stccd/distccd.pid --port 3632 --log-file /var/log/distccd.log --log-level c=
ritical --allow 192.168.1.1 --allow 10.0.0.0/24 -N 15
 2025 ?        Ss     0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid
 2109 ?        Ss     0:00 //usr/libexec/postfix/master
 2114 ?        S      0:00 qmgr -l -t fifo -u
 2125 ?        Ss     0:01 /usr/sbin/privoxy --pidfile /var/run/privoxy.pid=
 --user privoxy.privoxy /etc/privoxy/config
 2126 ?        SN     0:00 /usr/bin/distccd --daemon --pid-file /var/run/di=
stccd/distccd.pid --port 3632 --log-file /var/log/distccd.log --log-level c=
ritical --allow 192.168.1.1 --allow 10.0.0.0/24 -N 15
 2140 ?        SN     0:00 /usr/bin/distccd --daemon --pid-file /var/run/di=
stccd/distccd.pid --port 3632 --log-file /var/log/distccd.log --log-level c=
ritical --allow 192.168.1.1 --allow 10.0.0.0/24 -N 15
 2141 ?        SN     0:00 /usr/bin/distccd --daemon --pid-file /var/run/di=
stccd/distccd.pid --port 3632 --log-file /var/log/distccd.log --log-level c=
ritical --allow 192.168.1.1 --allow 10.0.0.0/24 -N 15
 2143 ?        S      0:00 /usr/sbin/smartd -p /var/run/smartd.pid
 2159 ?        Ss     0:00 /usr/sbin/sshd
 2175 ?        Ss     0:00 /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd_root=
fs.conf /dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7
 2183 tty1     Ss+    0:00 /sbin/agetty 38400 tty1 linux
 2184 tty2     Ss+    0:00 /sbin/agetty 38400 tty2 linux
 2185 tty3     Ss+    0:00 /sbin/agetty 38400 tty3 linux
 2186 tty4     Ss+    0:00 /sbin/agetty 38400 tty4 linux
 2187 tty5     Ss+    0:00 /sbin/agetty 38400 tty5 linux
 2188 tty6     Ss+    0:00 /sbin/agetty 38400 tty6 linux
 2198 ?        Ss     0:00 /bin/sh /usr/bin/startkde
 2210 ?        S      0:00 /usr/bin/dbus-launch --sh-syntax --exit-with-ses=
sion
 2211 ?        Ss     0:00 /usr/bin/dbus-daemon --fork --print-pid 5 --prin=
t-address 7 --session
 2260 ?        Ss     0:00 kdeinit4: kdeinit4 Running...    =20
 2261 ?        S      0:00 kdeinit4: klauncher [kdeinit] --fd=3D8
 2263 ?        Sl     0:01 kdeinit4: kded4 [kdeinit]        =20
 2265 ?        S      0:00 /usr/libexec/gam_server
 2269 ?        S      0:00 kdeinit4: kglobalaccel [kdeinit] =20
 2273 ?        Sl     0:00 /usr/libexec/upowerd
 2294 ?        Sl     0:02 /usr/libexec/udisks-daemon
 2299 ?        S      0:00 kwrapper4 ksmserver
 2301 ?        S      0:00 udisks-daemon: not polling any devices
 2302 ?        Sl     0:00 kdeinit4: ksmserver [kdeinit]    =20
 2323 ?        Sl     1:53 kwin -session 10e6cf737a000133274663900000025370=
000_1352712750_234757
 2327 ?        S      0:00 /usr/bin/kactivitymanagerd
 2342 ?        Sl     0:00 /usr/bin/knotify4
 2365 ?        Sl     4:05 kdeinit4: plasma-desktop [kdeinit]
 2370 ?        S      0:00 /usr/bin/kuiserver
 2385 ?        Sl     0:01 kdeinit4: krunner [kdeinit]      =20
 2391 ?        Sl     0:00 kdeinit4: kmix [kdeinit] -session 10e6cf737a0001=
33274664200000025370007_1352712749_218942
 2396 ?        Sl     7:28 /usr/lib/opera/opera -session 10e6cf737a00013527=
1066800000023000009_1352712749_219369 -sd /usr/share/opera/ -pd /home/fooba=
r/.opera/
 2403 ?        S      0:00 kdeinit4: klipper [kdeinit]      =20
 2404 ?        Sl     0:00 /usr/lib/kde4/libexec/polkit-kde-authentication-=
agent-1
 2406 ?        S      0:02 /usr/bin/urxvt
 2408 pts/1    Ss     0:00 -bash
 2429 pts/1    S+     0:00 ssh wloczykij
 4342 ?        S      0:00 [flush-9:5]
 4354 ?        Sl     0:26 /usr/lib/opera/pluginwrapper/operapluginwrapper-=
native -multiproc 2,0.1.659,10,75,97 -logfolder /home/foobar/.opera/logs/ -=
type native
 4432 ?        S      0:00 pickup -l -t fifo -u
 4806 ?        S      0:00 [kworker/0:1]
 5112 ?        S      0:00 [kworker/1:0]
 5171 ?        S      0:01 [kworker/1:1]
 5206 ?        Ss     0:00 sshd: foobar [priv]
 5215 ?        S      0:00 sshd: foobar@pts/2
 5216 pts/2    Ss     0:00 -bash
 5235 pts/2    R+     0:00 ps ax

--0FRtVia6Q6lt+M0P--

--DfnuYBTqzt7sVGu3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQomc4AAoJEEMpAov1cw9lRc4P/2cHtrWswfcqFcJPU6jDtD95
3bx4dkpXtFMXfigO0753Z9O9DslZHi3SO/2GFb489GvKnXe3j3qtVZ7jlwYbEnFR
oSdQlhkZPjd9IlMy/ebdaIRIk5F8rHXP8eXzIUi1BzkBSbXVgGIldliA3gvmOhx9
YxixJ5VsifIbeHH5pjuXeM9Qs8dtdEYRGZFL2vPNbfO7UUP2Gy5pECvTLDdowGv4
MIFg69NBobUHIOyQER0lvBOfCkhS5gD1iInMM0NZcZnxSbsMOiKz78NtqKI1MjiK
ITf16zP2dlpNlJWJD+aZEUJqdvF6tp+aVuZtcrNSCdHltVyJI4U5fr7Fa5Tfa8fj
j+oh68wH2KnxVFRkOJxf0XaxPi+5bSnfVTFGmJ4s2SYS4g+o4FNiCLk1gmX6ziag
HaMFOGgK9DD4HJwx9kliA8IRkDLaIj0wdalAd2AmPSeo6HarqBySBMnDDP0eud/V
//Z0WrNha6m+nb213ctL2xPKK3sLSvrOMtms2Opx2OvqNuaBkwzEczkL92i56SP4
d7PZE7dyA1ymMsnBCEHH8OO0wR2M8ytcMH/hVEcsv6CT+bHqm6ocs9103Pm0+t97
ICgWACZFWrBUQbAyRF0dWnEQNTPamynZ7VXzijqran0keEcxCP9mpHKO4DYzoZSc
fOQKf+q75eRSspNHj3qw
=bP3u
-----END PGP SIGNATURE-----

--DfnuYBTqzt7sVGu3--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
