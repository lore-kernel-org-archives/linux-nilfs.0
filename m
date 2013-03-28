From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Thu, 28 Mar 2013 13:07:00 +0100
Message-ID: <20130328120700.GK1672@wloczykij>
References: <50A5737C.2040805@li.ru>
 <201211160313.AA04185@capsicum.lab.ntt.co.jp>
 <50A65588.3000205@li.ru>
 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
 <20121127151924.GW4028@wloczykij>
 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
 <20121128142116.GY4028@wloczykij>
 <1354113560.2017.11.camel@slavad-ubuntu>
 <20121128205943.GZ4028@wloczykij>
 <1354172459.2077.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ngshnjhd05HsCES+"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1354172459.2077.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--ngshnjhd05HsCES+
Content-Type: multipart/mixed; boundary="GviraxgP0A7vmYdC"
Content-Disposition: inline


--GviraxgP0A7vmYdC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 11:00:59AM +0400, Vyacheslav Dubeyko wrote:
> Thank you.

Got this issue again (sincerely, I'm a bit lost and don't remember if
there was a patch for this?)


> I think that it needs to use such tools for the issue investigation:
> 1. echo t > /proc/sysrq-trigger should tell us what the flusher is
> doing.

Attached.


> 2. The /proc/meminfo and /proc/sys/vm/dirty_ratio output for the issue
> time can be also helpful.

MemTotal:        2074936 kB
MemFree:          696664 kB
Buffers:             940 kB
Cached:          1036912 kB
SwapCached:            0 kB
Active:           758376 kB
Inactive:         448196 kB
Active(anon):     168788 kB
Inactive(anon):      452 kB
Active(file):     589588 kB
Inactive(file):   447744 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       1187784 kB
HighFree:         535312 kB
LowTotal:         887152 kB
LowFree:          161352 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                24 kB
Writeback:             0 kB
AnonPages:        168732 kB
Mapped:            44004 kB
Shmem:               520 kB
Slab:             164796 kB
SReclaimable:     143208 kB
SUnreclaim:        21588 kB
KernelStack:         912 kB
PageTables:         1380 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1037468 kB
Committed_AS:     273168 kB
VmallocTotal:     122880 kB
VmallocUsed:        1136 kB
VmallocChunk:      92356 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       12280 kB
DirectMap4M:      897024 kB


dirty_ratio is 20


> 3. It makes sense to use blktrace for getting I/O traces during
> flushing during sync command execution and near before issue was
> occurred. I/O traces can be useful for analysis but this output can
> contain huge info amount. So, I think first of all it needs to get
> info about what flusher doing during eating CPU time.

This seems to be "not fixed by sync", so if you can elaborate about this
I can test it.

Extra info:
wloczykij ~ (: grep -vE '^(#|$)' /etc/nilfs_cleanerd.conf
protection_period       3600
min_clean_segments      12%
max_clean_segments      30%
clean_check_interval    10
selection_policy        timestamp       # timestamp in ascend order
nsegments_per_clean     2
mc_nsegments_per_clean  4
cleaning_interval       10
mc_cleaning_interval    1
retry_interval          60
use_mmap
log_priority            info

I'm using vanilla kernel 3.6.10.

Current snapshot and checkpoint state:
wloczykij ~ # lscp -s
                 CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
wloczykij ~ # lscp | head
                 CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
              140088  2013-03-18 11:38:03   cp    -          119      48230
              140089  2013-03-18 11:48:05   cp    -          106      48230
              140090  2013-03-18 11:58:07   cp    -           85      48230
              140091  2013-03-18 12:05:43   cp    -          119      48231
              140092  2013-03-18 12:05:45   cp    -           40      48226
              140093  2013-03-18 12:15:46   cp    -          320      48325
              140094  2013-03-18 12:17:11   cp    -          139      48225
              140095  2013-03-18 12:17:15   cp    -           42      48225
              140096  2013-03-18 12:17:17   cp    -           21      48225
wloczykij ~ # lscp | tail
              142148  2013-03-28 12:59:38   cp    -           29      49204
              142149  2013-03-28 12:59:44   cp    -           29      49204
              142150  2013-03-28 13:00:20   cp    -          138      49208
              142151  2013-03-28 13:01:50   cp    -           40      49205
              142152  2013-03-28 13:02:23   cp    -           29      49205
              142153  2013-03-28 13:02:23   cp    -           29      49205
              142154  2013-03-28 13:02:27   cp    -           29      49205
              142155  2013-03-28 13:02:32   cp    -           29      49205
              142156  2013-03-28 13:03:02   cp    -           58      49205
              142157  2013-03-28 13:03:02   cp    -           28      49205



Piotr Szymaniak.
--=20
I ten smr=C3=B3d. Diabli wiedz=C4=85, co tam gni=C5=82o, w tym mi=C4=99siwi=
e, ale Redowi
wyda=C5=82o si=C4=99, =C5=BCe sto tysi=C4=99cy rozbitych cuchn=C4=85cych ja=
j wylanych na sto
tysi=C4=99cy cuchn=C4=85cych rybich =C5=82b=C3=B3w i zdech=C5=82ych kot=C3=
=B3w nie mo=C5=BCe =C5=9Bmierdzie=C4=87
tak, jak =C5=9Bmierdzia=C5=82a ta ma=C5=BA.
 -- Arkadij i Borys Strugaccy, =E2=80=9EPiknik na skraju drogi=E2=80=9D

--GviraxgP0A7vmYdC
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=psax
Content-Transfer-Encoding: quoted-printable

  PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:31 init [3] =20
    2 ?        S      0:00 [kthreadd]
    3 ?        S      1:02 [ksoftirqd/0]
    5 ?        S<     0:00 [kworker/0:0H]
    6 ?        S      0:00 [kworker/u:0]
    7 ?        S<     0:00 [kworker/u:0H]
    8 ?        S<     0:00 [khelper]
    9 ?        S      0:00 [kdevtmpfs]
   10 ?        S      0:00 [kworker/u:1]
  158 ?        S      0:00 [bdi-default]
  160 ?        S<     0:00 [kblockd]
  239 ?        S<     0:00 [ata_sff]
  246 ?        S      0:00 [khubd]
  350 ?        S<     0:00 [rpciod]
  365 ?        S      0:32 [kswapd0]
  366 ?        S      0:00 [fsnotify_mark]
  368 ?        S<     0:00 [crypto]
  471 ?        S<     0:00 [deferwq]
  474 ?        S      0:00 [scsi_eh_0]
  475 ?        S      1:03 [usb-storage]
  488 ?        S<     0:24 [kworker/0:1H]
  497 ?        S      0:12 [segctord]
  589 ?        Ss     0:00 /sbin/udevd --daemon
  647 ?        S      0:00 [scsi_eh_1]
  657 ?        S      0:00 [scsi_eh_2]
  937 ?        S    49157:04 [flush-8:0]
 1046 ?        S<     0:00 [kdmflush]
 1066 ?        S<     0:00 [kcryptd_io]
 1067 ?        S<     0:00 [kcryptd]
 1094 ?        S<     0:00 [kdmflush]
 1095 ?        S<     0:00 [kcryptd_io]
 1096 ?        S<     0:00 [kcryptd]
 1225 ?        Ssl    2:42 /sbin/apcupsd -f /etc/apcupsd/apcupsd.conf -P /v=
ar/run/apcupsd.pid
 1240 ?        S      0:00 supervising syslog-ng                           =
                                           =20
 1241 ?        Ssl    0:30 /usr/sbin/syslog-ng --cfgfile /etc/syslog-ng/sys=
log-ng.conf --pidfile /var/run/syslog-ng.pid
 1255 ?        Ss     0:11 /usr/sbin/crond
 1342 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/ng=
inx/nginx.conf
 1344 ?        S      1:16 nginx: worker process                  =20
 1345 ?        S      2:18 nginx: worker process                  =20
 1346 ?        S      2:15 nginx: worker process                  =20
 1347 ?        S      2:10 nginx: worker process                  =20
 1359 ?        Ss     2:54 /usr/sbin/ntpd -p /var/run/ntpd.pid
 1442 ?        Ss     0:15 /usr/libexec/postfix/master -w
 1445 ?        S      0:02 qmgr -l -t unix -u
 1460 ?        Ss     0:00 /usr/bin/rsync --daemon
 1468 ?        S      0:00 tlsmgr -l -t unix -u
 1520 ?        Ss     0:25 /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd.conf=
 /dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
 1525 ?        S      0:00 [btrfs-genwork-1]
 1526 ?        S      0:19 [btrfs-submit-1]
 1527 ?        S      0:00 [btrfs-delalloc-]
 1528 ?        S      0:00 [btrfs-fixup-1]
 1531 ?        S      0:00 [btrfs-endio-met]
 1533 ?        S      0:00 [btrfs-freespace]
 1535 ?        S      0:01 [btrfs-cache-1]
 1536 ?        S      0:00 [btrfs-readahead]
 1537 ?        S      0:00 [btrfs-cleaner]
 1538 ?        S      3:45 [btrfs-transacti]
 1541 tty1     Ss+    0:00 /sbin/agetty 38400 tty1 linux
 1542 tty2     Ss+    0:00 /sbin/agetty 38400 tty2 linux
 1543 tty3     Ss+    0:00 /sbin/agetty 38400 tty3 linux
 1544 tty4     Ss+    0:00 /sbin/agetty 38400 tty4 linux
 1545 tty5     Ss+    0:00 /sbin/agetty 38400 tty5 linux
 1546 tty6     Ss+    0:00 /sbin/agetty 38400 tty6 linux
 1600 ?        Sl   3227:31 /usr/bin/tor -f /etc/tor/torrc --runasdaemon 1 =
--PidFile /var/run/tor/tor.pid
 1669 ?        Ss     5:37 SCREEN
 1670 pts/1    Ssl+  22:23 irssi
 1671 pts/2    Ss+   35:30 ekg2 -m
 1672 pts/3    Ss+   10:51 mutt -y
 1834 ?        Ss     2:30 SCREEN
 1835 pts/4    Ss     0:00 -/bin/bash
 1839 pts/4    T      1:01 ekg2 -m
 1843 pts/5    Ss     0:00 -/bin/bash
 1847 pts/5    Sl+   25:16 irssi
 2086 pts/8    Ss     0:00 -/bin/bash
 2094 pts/8    S      0:00 su -
 2097 pts/8    S      0:01 -su
 2130 ?        Ss     0:00 /usr/bin/svnserve --foreground --daemon --root=
=3D/home/services/svn
 5330 ?        Ss     0:00 /usr/sbin/sshd
 5360 ?        Sl     1:49 /usr/bin/monit
 8080 ?        Ss     0:00 /usr/sbin/privoxy --pidfile /var/run/privoxy.pid=
 --user privoxy.privoxy /etc/privoxy/config
12034 ?        S      0:00 [btrfs-endio-met]
12624 ?        Ss     0:19 /usr/sbin/unbound -c /etc/unbound/unbound.conf
14098 pts/4    S+    26:16 ekg2 -m
14977 ?        Ss     0:00 sshd: barbaz [priv]
14981 ?        S      0:00 sshd: barbaz@pts/0
14982 pts/0    Ss     0:00 -bash
14986 pts/0    S+     0:00 screen -r
15113 ?        S      0:00 [btrfs-worker-2]
15292 ?        S      0:00 [btrfs-endio-wri]
15754 ?        S      0:00 pickup -l -t unix -u
15980 ?        S      0:00 [kworker/0:2]
16006 ?        S      0:00 [kworker/0:0]
16022 ?        Ss     0:00 sshd: foobar [priv]
16025 ?        S      0:00 sshd: foobar@pts/6
16026 pts/6    Ss     0:00 -bash
16034 pts/6    S+     0:00 screen -r
16150 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/sda3 /
16160 ?        S      0:00 [kworker/0:1]
16164 ?        S      0:00 [btrfs-endio-wri]
16166 ?        S      0:00 smtpd -n smtp -t inet -u -o stress=3D -s 2
16168 ?        S      0:00 proxymap -t unix -u
16169 ?        S      0:00 trivial-rewrite -n rewrite -t unix -u
16170 ?        S      0:00 cleanup -z -t unix -u
16171 ?        S      0:00 smtp -t unix -u
16172 ?        S      0:00 bounce -z -n defer -t unix -u
16181 pts/8    R+     0:00 ps ax
19174 ?        Ss     0:00 ssh-agent
19200 ?        Ss     1:06 gpg-agent --daemon
21519 ?        S      0:07 [flush-btrfs-1]
27995 ?        S      0:07 [btrfs-endio-2]
29537 ?        S      0:00 [btrfs-delayed-m]

--GviraxgP0A7vmYdC
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="sysrq-trigger.bz2"
Content-Transfer-Encoding: base64

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

--GviraxgP0A7vmYdC--

--ngshnjhd05HsCES+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRVDJjAAoJEEMpAov1cw9lsUEP/1lh5nfLXLvFnxZh8QCcYdHQ
kpUhFikPtFXNAakyHxfuXtOrkcAPvX2La6TVrPmT9sp5FSfns3vl8G2ub6yY0mjG
4EfCghuSr8qbgMnZBR54riuZm3qYXYWucPWhlA2bXGblHD2LJNK6/zfqIYxunR2i
reZ29PG2ry9OSHpBCl5o+XwiiDA9u8+nilQKAxfUB77/FQX59HvrNDyXa9GZ8uS3
4Kik/z1BGGVPXnxGLMUeY8H+12vtX4v6ygBCrAOZhMN+RTaQuuCIedhaUB3nOO3r
32HQn3j/o+50PXoaAP3rsMKlX6qaVFZtoqm5w7vgZsaVmBDsf/i8DHNJEyH6WQ0o
OCi6OOWJ0TANTTAsPsMciPEWZ1zUnIuHyqkmKZsm3tIWyJeAl90vg3pWDds2kLkG
SeYGeDDUufbfZt5VDH+Psap5OPNbYDSyiPIAAcud4DfbOgBBjx5zdjLiXik7VImc
8hx5jRuDfMnf4qcxB1IPdum08NtS05UFhbQm+c5tGeflJEmCTd9be7jXM4ohNzp3
Ze/5+8pGJsGseCoGpKmz42+8aMmZqYjebadVgq/n35k9SQZth7DlQYNQU13uvEFZ
IqQZkK0GPb+IV6xlpz3aCICDuF9kKJS/zkK9Zy7O89cCFzVZT+edOzFtIdWKo3/h
58jxfL4nQJpBcdQ68xRy
=GJ09
-----END PGP SIGNATURE-----

--ngshnjhd05HsCES+--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
