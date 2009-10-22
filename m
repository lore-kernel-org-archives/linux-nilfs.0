From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: Deadlock with nilfs on 2.6.31.4
Date: Thu, 22 Oct 2009 22:19:39 +0200
Message-ID: <20091022221939.61c832c2@neptune.home>
References: <20091021203847.26acab0a@neptune.home>
	<20091023.025129.71910838.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20091023.025129.71910838.ryusuke@osrg.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: users@nilfs.org, linux-fsdevel@vger.kernel.org, ryusuke@osrg.net

On Fri, 23 October 2009 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>=
 wrote:
> Thank you for reporting the issue.
>=20
> According to the log, the log-writer of nilfs looks to be idle even
> though it has some requests waiting.
>=20
> Could you try the following patch to narrow down the issue ?
>=20
> I'll dig into this issue next week since I'm now away from my office
> to attend the Linux symposium in Tokyo.
>=20
> Thank you,
> Ryusuke Konishi
>=20
>=20
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 51ff3d0..0932571 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c

I tried the patch, below is full dmesg output from system start-up to
frozen syslog-ng (and collectd thread). (with echo t > /proc/sysrq-trig=
ger)

Hard to tell at what time syslog-ng did freeze, but chances are big it'=
s
somewhere between 435.x and 591.x when nilfs stops sending/getting even=
ts.

The collectd instance in D-state is most probably the one that wants to
write data to RRD file.

At least it looks very easy to reproduce! Just restarting collectd a fe=
w
times and enabling its rrdtool plugin. (syslog-ng writing to one nilfs
partition, collectd to another one, both on the same SD card)

Bruno



[    0.000000] Linux version 2.6.31.4 (kbuild@neptune) (gcc version 4.3=
=2E2 (Gentoo 4.3.2-r4 p1.7, pie-10.1.5) ) #4 PREEMPT Fri Oct 16 11:38:5=
4 CEST 2009
[    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), c=
r=3D00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Marvell SheevaPlug Reference Board
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 131072
[    0.000000] free_area_init_node: node 0, pgdat c03cbe70, node_mem_ma=
p c0473000
[    0.000000]   Normal zone: 1024 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 130048 pages, LIFO batch:31
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  =
Total pages: 130048
[    0.000000] Kernel command line: console=3DttyS0,115200 rw root=3D/d=
ev/mtdblock2 rootfstype=3Djffs2
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144=
 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 =
bytes)
[    0.000000] Memory: 256MB 256MB =3D 512MB total
[    0.000000] Memory: 515072KB available (3516K code, 786K data, 104K =
init, 0K highmem)
[    0.000000] SLUB: Genslabs=3D11, HWalign=3D32, Order=3D0-3, MinObjec=
ts=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:114
[   21.474936] Console: colour dummy device 80x30
[   21.474962] Calibrating delay loop... 1192.75 BogoMIPS (lpj=3D596377=
6)
[   21.714926] Mount-cache hash table entries: 512
[   21.715205] CPU: Testing write buffer coherency: ok
[   21.717409] NET: Registered protocol family 16
[   21.719394] Kirkwood: MV88F6281-A0, TCLK=3D200000000.
[   21.719406] Feroceon L2: Enabling L2
[   21.719439] Feroceon L2: Cache support initialised.
[   21.720481] initial MPP regs: 01111111 11113322 00001111 00100000 00=
000000 00000000 00000000
[   21.720502]   final MPP regs: 01111111 11113322 00001111 00000000 00=
000000 00000000 00000000
[   21.728206] bio: create slab <bio-0> at 0
[   21.728983] SCSI subsystem initialized
[   21.729578] usbcore: registered new interface driver usbfs
[   21.729698] usbcore: registered new interface driver hub
[   21.729857] usbcore: registered new device driver usb
[   21.732153] NET: Registered protocol family 2
[   21.732389] IP route cache hash table entries: 16384 (order: 4, 6553=
6 bytes)
[   21.733107] TCP established hash table entries: 65536 (order: 7, 524=
288 bytes)
[   21.734472] TCP bind hash table entries: 65536 (order: 6, 262144 byt=
es)
[   21.734880] Switched to high resolution mode on CPU 0
[   21.735205] TCP: Hash tables configured (established 65536 bind 6553=
6)
[   21.735214] TCP reno registered
[   21.735357] NET: Registered protocol family 1
[   21.747264] JFFS2 version 2.2. (NAND) =C2=A9 2001-2006 Red Hat, Inc.
[   21.748189] msgmni has been set to 1006
[   21.748297] io scheduler noop registered
[   21.748305] io scheduler deadline registered
[   21.748558] io scheduler cfq registered (default)
[   21.758617] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[   21.759320] serial8250.0: ttyS0 at MMIO 0xf1012000 (irq =3D 33) is a=
 16550A
[   21.759341] console [ttyS0] enabled
[   21.999285] loop: module loaded
[   22.003405] MV-643xx 10/100/1000 ethernet driver version 1.4
[   22.009717] mv643xx_eth smi: probed
[   22.015138] net eth0: port 0 with MAC address 00:50:43:01:c8:6d
[   22.021630] NAND device: Manufacturer ID: 0xad, Chip ID: 0xdc (Hynix=
 NAND 512MiB 3,3V 8-bit)
[   22.030136] Scanning device for bad blocks
[   22.045763] Bad eraseblock 309 at 0x0000026a0000
[   22.050436] Bad eraseblock 310 at 0x0000026c0000
[   22.095214] Bad eraseblock 1392 at 0x00000ae00000
[   22.127588] Bad eraseblock 2137 at 0x000010b20000
[   22.169929] Bad eraseblock 3151 at 0x0000189e0000
[   22.209673] Creating 3 MTD partitions on "orion_nand":
[   22.214835] 0x000000000000-0x000000100000 : "u-boot"
[   22.220580] 0x000000100000-0x000000500000 : "uImage"
[   22.226172] 0x000000500000-0x000020000000 : "root"
[   22.233100] aoe: AoE v47 initialised.
[   22.236835] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[   22.243422] orion-ehci orion-ehci.0: Marvell Orion EHCI
[   22.248704] orion-ehci orion-ehci.0: new USB bus registered, assigne=
d bus number 1
[   22.284887] orion-ehci orion-ehci.0: irq 19, io mem 0xf1050000
[   22.304878] orion-ehci orion-ehci.0: USB 2.0 started, EHCI 1.00
[   22.311162] usb usb1: configuration #1 chosen from 1 choice
[   22.316965] hub 1-0:1.0: USB hub found
[   22.320751] hub 1-0:1.0: 1 port detected
[   22.325069] Initializing USB Mass Storage driver...
[   22.330114] usbcore: registered new interface driver usb-storage
[   22.336172] USB Mass Storage support registered.
[   22.340919] usbcore: registered new interface driver ums-datafab
[   22.347095] usbcore: registered new interface driver ums-freecom
[   22.353240] usbcore: registered new interface driver ums-jumpshot
[   22.359490] usbcore: registered new interface driver ums-sddr09
[   22.365566] usbcore: registered new interface driver ums-sddr55
[   22.371813] mice: PS/2 mouse device common for all mice
[   22.377289] rtc-mv rtc-mv: rtc core: registered rtc-mv as rtc0
[   22.383250] i2c /dev entries driver
[   22.387276] Orion Watchdog Timer: Initial timeout 21 sec
[   22.392939] cpuidle: using governor ladder
[   22.397473] cpuidle: using governor menu
[   22.401630] sdhci: Secure Digital Host Controller Interface driver
[   22.407872] sdhci: Copyright(c) Pierre Ossman
[   22.412459] mmc0: mvsdio driver initialized, lacking card detect (fa=
ll back to polling)
[   22.420858] Registered led device: plug:green:health
[   22.426027] mv_xor_shared mv_xor_shared.0: Marvell shared XOR driver
[   22.432428] mv_xor_shared mv_xor_shared.1: Marvell shared XOR driver
[   22.474908] mv_xor mv_xor.0: Marvell XOR: ( xor cpy )
[   22.486307] mmc0: host does not support reading read-only switch. as=
suming write-enable.
[   22.494451] mmc0: new high speed SDHC card at address bc20
[   22.500478] mmcblk0: mmc0:bc20 SD08G 7.60 GiB=20
[   22.505090]  mmcblk0:
[   22.514915] mv_xor mv_xor.1: Marvell XOR: ( xor fill cpy )
[   22.520902]  p1 p2 p3
[   22.554899] mv_xor mv_xor.2: Marvell XOR: ( xor cpy )
[   22.594897] mv_xor mv_xor.3: Marvell XOR: ( xor fill cpy )
[   22.603945] usbcore: registered new interface driver usbhid
[   22.609578] usbhid: v2.6:USB HID core driver
[   22.614782] TCP cubic registered
[   22.619129] NET: Registered protocol family 10
[   22.626052] NET: Registered protocol family 17
[   22.631033] RPC: Registered udp transport module.
[   22.635841] RPC: Registered tcp transport module.
[   22.640569] Gating clock of unused units
[   22.640576] before: 0x00df03dd
[   22.640582]  after: 0x00c701d9
[   22.641264] rtc-mv rtc-mv: setting system clock to 2009-10-22 21:54:=
31 UTC (1256248471)
[   36.375182] JFFS2 notice: (1) jffs2_build_xattr_subsystem: complete =
building xattr subsystem, 4 of xdatum (0 unchecked, 0 orphan) and 14 of=
 xref (0 dead, 0 orphan) found.
[   36.396916] VFS: Mounted root (jffs2 filesystem) on device 31:2.
[   36.403038] Freeing init memory: 104K
[   39.348950] udev: starting version 141
[   42.664233] segctord starting. Construction interval =3D 5 seconds, =
CP frequency < 30 seconds
[   42.664249] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   44.117775] segctord starting. Construction interval =3D 5 seconds, =
CP frequency < 30 seconds
[   44.117791] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   44.152167] segctord starting. Construction interval =3D 5 seconds, =
CP frequency < 30 seconds
[   44.152183] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   46.384346] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   48.047176] eth0: link up, 100 Mb/s, full duplex, flow control disab=
led
[   48.047670] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   49.764909] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   49.773540] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   49.773610] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D0
[   54.764886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   54.778199] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   54.778219] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   59.774888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   59.780404] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   59.780418] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   64.784887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   64.792656] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   64.792672] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   69.794886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   69.806849] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   69.806868] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   74.804887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   74.815413] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   74.815431] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   79.814881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   79.819755] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   79.819769] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   84.824887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   84.831692] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   84.831708] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   89.834881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   89.839619] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   89.839634] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   94.844884] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   94.851209] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   94.851225] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[   99.854879] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[   99.861902] nilfs_segctor_notify: completed request from=3D0 to=3D0
[   99.861917] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  104.864886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  104.872528] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  104.872544] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  109.874882] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  109.880275] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  109.880290] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  114.884890] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  114.893995] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  114.894011] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  119.894888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  119.899362] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  119.899377] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  124.904889] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  124.911686] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  124.911701] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  129.914887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  129.920117] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  129.920132] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  134.924886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  134.932741] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  134.932756] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  139.934887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  139.940469] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  139.940484] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  144.944888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  144.952811] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  144.952827] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  149.954882] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  149.960334] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  149.960350] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  154.964883] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  154.972784] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  154.972800] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  159.974886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  159.979847] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  159.979862] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  164.984890] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  164.991647] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  164.991662] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  169.994885] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  170.001930] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  170.001946] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  175.004888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  175.009267] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  175.009282] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  180.014887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  180.019487] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  180.019502] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  185.024882] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  185.029440] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  185.029455] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  190.034889] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  190.040785] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  190.040801] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  195.044887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  195.049440] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  195.049456] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  200.054881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  200.059330] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  200.059344] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  205.064886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  205.069514] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  205.069528] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  210.074881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  210.079706] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  210.079721] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  215.084880] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  215.090995] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  215.091010] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  220.094886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  220.103336] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  220.103352] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  225.104886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  225.113401] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  225.113416] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  230.114885] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  230.119557] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  230.119572] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  235.124886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  235.129868] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  235.129883] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  240.134887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  240.139681] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  240.139697] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  245.144887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  245.149965] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  245.149980] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  250.154882] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  250.159893] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  250.159908] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  255.164881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  255.170127] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  255.170142] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  260.174886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  260.180109] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  260.180124] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  265.184891] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  265.190234] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  265.190250] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  270.194887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  270.200385] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  270.200400] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  275.204883] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  275.210321] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  275.210336] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  280.214890] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  280.220521] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  280.220537] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  285.224880] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  285.229841] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  285.229855] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  290.234885] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  290.239923] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  290.239939] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  295.244887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  295.250140] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  295.250155] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  300.254887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  300.260324] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  300.260340] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  305.264882] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  305.270189] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  305.270204] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  310.274880] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  310.279312] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  310.279327] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  315.284890] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  315.289479] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  315.289495] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  320.294887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  320.299408] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  320.299423] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  325.304889] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  325.309601] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  325.309616] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  330.314888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  330.319765] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  330.319780] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  335.324887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  335.329891] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  335.329906] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  340.334887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  340.339880] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  340.339895] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  345.344888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  345.350064] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  345.350079] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  350.354881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  350.360269] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  350.360285] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  355.364887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  355.370297] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  355.370313] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  360.374882] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  360.380317] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  360.380332] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  365.384887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  365.390516] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  365.390532] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  370.394881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  370.400472] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  370.400488] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  375.404887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  375.409780] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  375.409795] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  380.414888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  380.419791] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  380.419806] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  385.424887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  385.430078] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  385.430093] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  390.434888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  390.444359] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  390.444374] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  395.444886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  395.449035] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  395.449050] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  400.454887] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  400.459393] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  400.459409] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  405.464881] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  405.469459] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  405.469474] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  410.474896] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  410.479610] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  410.479625] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  415.484885] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  415.489786] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  415.489802] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  420.494883] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  420.499985] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  420.500000] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  425.504885] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  425.509909] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  425.509924] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  430.514886] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  430.520159] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  430.520175] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  435.524888] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D4, timeout=3D1
[  435.530061] nilfs_segctor_notify: completed request from=3D0 to=3D0
[  435.530075] nilfs_segctor_thread: sequence: req=3D0, done=3D0, state=
=3D0, timeout=3D0
[  591.025297] SysRq : Show State
[  591.028379]   task                PC stack   pid father
[  591.028387] init          S c02c8610     0     1      0 0x00000000
[  591.028404] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c98c4>] (s=
chedule_hrtimeout_range+0x114/0x188)
[  591.028436] [<c02c98c4>] (schedule_hrtimeout_range+0x114/0x188) from=
 [<c00a65b8>] (poll_schedule_timeout+0x38/0x58)
[  591.028462] [<c00a65b8>] (poll_schedule_timeout+0x38/0x58) from [<c0=
0a7110>] (do_select+0x52c/0x568)
[  591.028482] [<c00a7110>] (do_select+0x52c/0x568) from [<c00a72ac>] (=
core_sys_select+0x160/0x318)
[  591.028501] [<c00a72ac>] (core_sys_select+0x160/0x318) from [<c00a75=
58>] (sys_select+0xf4/0x1e0)
[  591.028521] [<c00a7558>] (sys_select+0xf4/0x1e0) from [<c0022f00>] (=
ret_fast_syscall+0x0/0x2c)
[  591.028543] kthreadd      S c02c8610     0     2      0 0x00000000
[  591.028556] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c004aa28>] (k=
threadd+0x150/0x16c)
[  591.028577] [<c004aa28>] (kthreadd+0x150/0x16c) from [<c0023940>] (k=
ernel_thread_exit+0x0/0x8)
[  591.028597] ksoftirqd/0   S c02c8610     0     3      2 0x00000000
[  591.028609] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c003a120>] (k=
softirqd+0xf4/0x170)
[  591.028632] [<c003a120>] (ksoftirqd+0xf4/0x170) from [<c004aac0>] (k=
thread+0x7c/0x84)
[  591.028650] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.028668] watchdog/0    S c02c8610     0     4      2 0x00000000
[  591.028681] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c00639a8>] (w=
atchdog+0x68/0xac)
[  591.028701] [<c00639a8>] (watchdog+0x68/0xac) from [<c004aac0>] (kth=
read+0x7c/0x84)
[  591.028718] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.028736] events/0      S c02c8610     0     5      2 0x00000000
[  591.028749] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.028772] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.028790] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.028808] khelper       S c02c8610     0     6      2 0x00000000
[  591.028821] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.028840] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.028858] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.028877] netns         S c02c8610     0     9      2 0x00000000
[  591.028889] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.028909] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.028927] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.028945] async/mgr     S c02c8610     0    10      2 0x00000000
[  591.028958] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c00517d0>] (a=
sync_manager_thread+0xb8/0x11c)
[  591.028984] [<c00517d0>] (async_manager_thread+0xb8/0x11c) from [<c0=
04aac0>] (kthread+0x7c/0x84)
[  591.029003] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029022] kblockd/0     S c02c8610     0   109      2 0x00000000
[  591.029035] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.029056] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.029074] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029092] ksuspend_usbd S c02c8610     0   117      2 0x00000000
[  591.029105] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.029125] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.029143] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029161] khubd         S c02c8610     0   121      2 0x00000000
[  591.029174] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c01be3b0>] (h=
ub_thread+0x1050/0x11a0)
[  591.029199] [<c01be3b0>] (hub_thread+0x1050/0x11a0) from [<c004aac0>=
] (kthread+0x7c/0x84)
[  591.029217] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029236] kmmcd         S c02c8610     0   125      2 0x00000000
[  591.029248] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.029269] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.029287] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029305] khungtaskd    S c02c8610     0   149      2 0x00000000
[  591.029318] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e60>] (s=
chedule_timeout+0x14c/0x1e8)
[  591.029339] [<c02c8e60>] (schedule_timeout+0x14c/0x1e8) from [<c0063=
c08>] (watchdog+0x38/0x284)
[  591.029359] [<c0063c08>] (watchdog+0x38/0x284) from [<c004aac0>] (kt=
hread+0x7c/0x84)
[  591.029376] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029394] pdflush       S c02c8610     0   150      2 0x00000000
[  591.029406] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c007179c>] (p=
dflush+0xec/0x2cc)
[  591.029426] [<c007179c>] (pdflush+0xec/0x2cc) from [<c004aac0>] (kth=
read+0x7c/0x84)
[  591.029443] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029461] pdflush       S c02c8610     0   151      2 0x00000000
[  591.029473] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c007179c>] (p=
dflush+0xec/0x2cc)
[  591.029492] [<c007179c>] (pdflush+0xec/0x2cc) from [<c004aac0>] (kth=
read+0x7c/0x84)
[  591.029509] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029527] kswapd0       S c02c8610     0   152      2 0x00000000
[  591.029539] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c00770c4>] (k=
swapd+0x534/0x55c)
[  591.029561] [<c00770c4>] (kswapd+0x534/0x55c) from [<c004aac0>] (kth=
read+0x7c/0x84)
[  591.029577] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029596] aio/0         S c02c8610     0   198      2 0x00000000
[  591.029608] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.029629] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.029647] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029665] nfsiod        S c02c8610     0   201      2 0x00000000
[  591.029678] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.029698] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.029716] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029734] mtdblockd     S c02c8610     0   319      2 0x00000000
[  591.029747] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c01accc8>] (m=
td_blktrans_thread+0x20c/0x37c)
[  591.029772] [<c01accc8>] (mtd_blktrans_thread+0x20c/0x37c) from [<c0=
04aac0>] (kthread+0x7c/0x84)
[  591.029791] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029810] orion_spi     S c02c8610     0   332      2 0x00000000
[  591.029822] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.029843] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.029862] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029880] mmcqd         S c02c8610     0   375      2 0x00000000
[  591.029893] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c01f09fc>] (m=
mc_queue_thread+0xe4/0x118)
[  591.029915] [<c01f09fc>] (mmc_queue_thread+0xe4/0x118) from [<c004aa=
c0>] (kthread+0x7c/0x84)
[  591.029932] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.029950] usbhid_resume S c02c8610     0   412      2 0x00000000
[  591.029963] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.029984] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.030002] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.030020] rpciod/0      S c02c8610     0   421      2 0x00000000
[  591.030033] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0046dd0>] (w=
orker_thread+0x200/0x218)
[  591.030053] [<c0046dd0>] (worker_thread+0x200/0x218) from [<c004aac0=
>] (kthread+0x7c/0x84)
[  591.030070] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.030088] jffs2_gcd_mtd S c02c8610     0   425      2 0x00000000
[  591.030101] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e60>] (s=
chedule_timeout+0x14c/0x1e8)
[  591.030122] [<c02c8e60>] (schedule_timeout+0x14c/0x1e8) from [<c0127=
830>] (jffs2_garbage_collect_thread+0xb8/0x1d0)
[  591.030146] [<c0127830>] (jffs2_garbage_collect_thread+0xb8/0x1d0) f=
rom [<c0023940>] (kernel_thread_exit+0x0/0x8)
[  591.030167] udevd         S c02c8610     0   535      1 0x00000000
[  591.030180] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c9914>] (s=
chedule_hrtimeout_range+0x164/0x188)
[  591.030202] [<c02c9914>] (schedule_hrtimeout_range+0x164/0x188) from=
 [<c00a65b8>] (poll_schedule_timeout+0x38/0x58)
[  591.030225] [<c00a65b8>] (poll_schedule_timeout+0x38/0x58) from [<c0=
0a69b0>] (do_sys_poll+0x334/0x440)
[  591.030245] [<c00a69b0>] (do_sys_poll+0x334/0x440) from [<c00a6b1c>]=
 (sys_poll+0x60/0xcc)
[  591.030263] [<c00a6b1c>] (sys_poll+0x60/0xcc) from [<c0022f00>] (ret=
_fast_syscall+0x0/0x2c)
[  591.030283] segctord      S c02c8610     0   858      2 0x00000000
[  591.030296] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<bf015518>] (n=
ilfs_segctor_thread+0x2f4/0x330 [nilfs2])
[  591.030400] [<bf015518>] (nilfs_segctor_thread+0x2f4/0x330 [nilfs2])=
 from [<c004aac0>] (kthread+0x7c/0x84)
[  591.030481] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.030501] nilfs_cleaner S c02c8610     0   859      1 0x00000000
[  591.030514] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c99f4>] (d=
o_nanosleep+0xb0/0x110)
[  591.030537] [<c02c99f4>] (do_nanosleep+0xb0/0x110) from [<c004eed0>]=
 (hrtimer_nanosleep+0xa4/0x12c)
[  591.030560] [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c) from [<c004e=
ff4>] (sys_nanosleep+0x9c/0xa4)
[  591.030580] [<c004eff4>] (sys_nanosleep+0x9c/0xa4) from [<c0022f00>]=
 (ret_fast_syscall+0x0/0x2c)
[  591.030599] segctord      S c02c8610     0   861      2 0x00000000
[  591.030612] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<bf015518>] (n=
ilfs_segctor_thread+0x2f4/0x330 [nilfs2])
[  591.030696] [<bf015518>] (nilfs_segctor_thread+0x2f4/0x330 [nilfs2])=
 from [<c004aac0>] (kthread+0x7c/0x84)
[  591.030775] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.030795] nilfs_cleaner S c02c8610     0   862      1 0x00000000
[  591.030808] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c99f4>] (d=
o_nanosleep+0xb0/0x110)
[  591.030831] [<c02c99f4>] (do_nanosleep+0xb0/0x110) from [<c004eed0>]=
 (hrtimer_nanosleep+0xa4/0x12c)
[  591.030853] [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c) from [<c004e=
ff4>] (sys_nanosleep+0x9c/0xa4)
[  591.030872] [<c004eff4>] (sys_nanosleep+0x9c/0xa4) from [<c0022f00>]=
 (ret_fast_syscall+0x0/0x2c)
[  591.030893] segctord      S c02c8610     0   864      2 0x00000000
[  591.030905] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<bf015518>] (n=
ilfs_segctor_thread+0x2f4/0x330 [nilfs2])
[  591.030988] [<bf015518>] (nilfs_segctor_thread+0x2f4/0x330 [nilfs2])=
 from [<c004aac0>] (kthread+0x7c/0x84)
[  591.031067] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kern=
el_thread_exit+0x0/0x8)
[  591.031087] nilfs_cleaner S c02c8610     0   865      1 0x00000000
[  591.031100] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c99f4>] (d=
o_nanosleep+0xb0/0x110)
[  591.031122] [<c02c99f4>] (do_nanosleep+0xb0/0x110) from [<c004eed0>]=
 (hrtimer_nanosleep+0xa4/0x12c)
[  591.031144] [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c) from [<c004e=
ff4>] (sys_nanosleep+0x9c/0xa4)
[  591.031163] [<c004eff4>] (sys_nanosleep+0x9c/0xa4) from [<c0022f00>]=
 (ret_fast_syscall+0x0/0x2c)
[  591.031184] syslog-ng     D c02c8610     0  1956      1 0x00000000
[  591.031196] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e60>] (s=
chedule_timeout+0x14c/0x1e8)
[  591.031217] [<c02c8e60>] (schedule_timeout+0x14c/0x1e8) from [<c02c8=
344>] (io_schedule_timeout+0x34/0x58)
[  591.031238] [<c02c8344>] (io_schedule_timeout+0x34/0x58) from [<c007=
caf0>] (congestion_wait+0x5c/0x80)
[  591.031261] [<c007caf0>] (congestion_wait+0x5c/0x80) from [<c0070fb0=
>] (balance_dirty_pages_ratelimited_nr+0xe8/0x290)
[  591.031283] [<c0070fb0>] (balance_dirty_pages_ratelimited_nr+0xe8/0x=
290) from [<c0069f04>] (generic_file_buffered_write+0x10c/0x348)
[  591.031308] [<c0069f04>] (generic_file_buffered_write+0x10c/0x348) f=
rom [<c006a64c>] (__generic_file_aio_write_nolock+0x264/0x4f4)
[  591.031331] [<c006a64c>] (__generic_file_aio_write_nolock+0x264/0x4f=
4) from [<c006b3b8>] (generic_file_aio_write+0x74/0xe8)
[  591.031353] [<c006b3b8>] (generic_file_aio_write+0x74/0xe8) from [<c=
0097228>] (do_sync_write+0xbc/0x100)
[  591.031376] [<c0097228>] (do_sync_write+0xbc/0x100) from [<c0097d3c>=
] (vfs_write+0xb0/0x164)
[  591.031394] [<c0097d3c>] (vfs_write+0xb0/0x164) from [<c0097ec0>] (s=
ys_write+0x40/0x70)
[  591.031412] [<c0097ec0>] (sys_write+0x40/0x70) from [<c0022f00>] (re=
t_fast_syscall+0x0/0x2c)
[  591.031432] ntpd          S c02c8610     0  1986      1 0x00000000
[  591.031445] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c98c4>] (s=
chedule_hrtimeout_range+0x114/0x188)
[  591.031467] [<c02c98c4>] (schedule_hrtimeout_range+0x114/0x188) from=
 [<c00a65b8>] (poll_schedule_timeout+0x38/0x58)
[  591.031491] [<c00a65b8>] (poll_schedule_timeout+0x38/0x58) from [<c0=
0a69b0>] (do_sys_poll+0x334/0x440)
[  591.031511] [<c00a69b0>] (do_sys_poll+0x334/0x440) from [<c00a6b1c>]=
 (sys_poll+0x60/0xcc)
[  591.031529] [<c00a6b1c>] (sys_poll+0x60/0xcc) from [<c0022f00>] (ret=
_fast_syscall+0x0/0x2c)
[  591.031548] sshd          S c02c8610     0  1990      1 0x00000000
[  591.031561] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c9914>] (s=
chedule_hrtimeout_range+0x164/0x188)
[  591.031582] [<c02c9914>] (schedule_hrtimeout_range+0x164/0x188) from=
 [<c00a65b8>] (poll_schedule_timeout+0x38/0x58)
[  591.031604] [<c00a65b8>] (poll_schedule_timeout+0x38/0x58) from [<c0=
0a7110>] (do_select+0x52c/0x568)
[  591.031624] [<c00a7110>] (do_select+0x52c/0x568) from [<c00a72ac>] (=
core_sys_select+0x160/0x318)
[  591.031643] [<c00a72ac>] (core_sys_select+0x160/0x318) from [<c00a74=
90>] (sys_select+0x2c/0x1e0)
[  591.031662] [<c00a7490>] (sys_select+0x2c/0x1e0) from [<c0022f00>] (=
ret_fast_syscall+0x0/0x2c)
[  591.031681] ntpd          S c02c8610     0  1993      1 0x00000000
[  591.031694] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c98c4>] (s=
chedule_hrtimeout_range+0x114/0x188)
[  591.031715] [<c02c98c4>] (schedule_hrtimeout_range+0x114/0x188) from=
 [<c00a65b8>] (poll_schedule_timeout+0x38/0x58)
[  591.031738] [<c00a65b8>] (poll_schedule_timeout+0x38/0x58) from [<c0=
0a69b0>] (do_sys_poll+0x334/0x440)
[  591.031757] [<c00a69b0>] (do_sys_poll+0x334/0x440) from [<c00a6b1c>]=
 (sys_poll+0x60/0xcc)
[  591.031776] [<c00a6b1c>] (sys_poll+0x60/0xcc) from [<c0022f00>] (ret=
_fast_syscall+0x0/0x2c)
[  591.031795] agetty        S c02c8610     0  2005      1 0x00000000
[  591.031807] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e98>] (s=
chedule_timeout+0x184/0x1e8)
[  591.031827] [<c02c8e98>] (schedule_timeout+0x184/0x1e8) from [<c016d=
cdc>] (n_tty_read+0x4f0/0x748)
[  591.031848] [<c016dcdc>] (n_tty_read+0x4f0/0x748) from [<c0169044>] =
(tty_read+0x8c/0xd0)
[  591.031869] [<c0169044>] (tty_read+0x8c/0xd0) from [<c0097fa0>] (vfs=
_read+0xb0/0x164)
[  591.031888] [<c0097fa0>] (vfs_read+0xb0/0x164) from [<c0098124>] (sy=
s_read+0x40/0x70)
[  591.031907] [<c0098124>] (sys_read+0x40/0x70) from [<c0022f00>] (ret=
_fast_syscall+0x0/0x2c)
[  591.031926] sshd          S c02c8610     0  2006   1990 0x00000000
[  591.031938] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c9914>] (s=
chedule_hrtimeout_range+0x164/0x188)
[  591.031960] [<c02c9914>] (schedule_hrtimeout_range+0x164/0x188) from=
 [<c00a65b8>] (poll_schedule_timeout+0x38/0x58)
[  591.031983] [<c00a65b8>] (poll_schedule_timeout+0x38/0x58) from [<c0=
0a7110>] (do_select+0x52c/0x568)
[  591.032002] [<c00a7110>] (do_select+0x52c/0x568) from [<c00a72ac>] (=
core_sys_select+0x160/0x318)
[  591.032021] [<c00a72ac>] (core_sys_select+0x160/0x318) from [<c00a74=
90>] (sys_select+0x2c/0x1e0)
[  591.032040] [<c00a7490>] (sys_select+0x2c/0x1e0) from [<c0022f00>] (=
ret_fast_syscall+0x0/0x2c)
[  591.032059] bash          R running      0  2008   2006 0x00000000
[  591.032071] [<c00280f8>] (unwind_backtrace+0x0/0xe4) from [<c0026b8c=
>] (show_stack+0x14/0x1c)
[  591.032094] [<c0026b8c>] (show_stack+0x14/0x1c) from [<c002fc00>] (s=
how_state_filter+0x68/0xc4)
[  591.032118] [<c002fc00>] (show_state_filter+0x68/0xc4) from [<c01802=
ec>] (__handle_sysrq+0xbc/0x1b8)
[  591.032139] [<c01802ec>] (__handle_sysrq+0xbc/0x1b8) from [<c0180420=
>] (write_sysrq_trigger+0x38/0x3c)
[  591.032158] [<c0180420>] (write_sysrq_trigger+0x38/0x3c) from [<c00d=
a040>] (proc_reg_write+0x88/0xcc)
[  591.032183] [<c00da040>] (proc_reg_write+0x88/0xcc) from [<c0097d3c>=
] (vfs_write+0xb0/0x164)
[  591.032203] [<c0097d3c>] (vfs_write+0xb0/0x164) from [<c0097ec0>] (s=
ys_write+0x40/0x70)
[  591.032221] [<c0097ec0>] (sys_write+0x40/0x70) from [<c0022f00>] (re=
t_fast_syscall+0x0/0x2c)
[  591.032240] sshd          S c02c8610     0  2013   1990 0x00000000
[  591.032252] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c9914>] (s=
chedule_hrtimeout_range+0x164/0x188)
[  591.032275] [<c02c9914>] (schedule_hrtimeout_range+0x164/0x188) from=
 [<c00a65b8>] (poll_schedule_timeout+0x38/0x58)
[  591.032298] [<c00a65b8>] (poll_schedule_timeout+0x38/0x58) from [<c0=
0a7110>] (do_select+0x52c/0x568)
[  591.032318] [<c00a7110>] (do_select+0x52c/0x568) from [<c00a72ac>] (=
core_sys_select+0x160/0x318)
[  591.032337] [<c00a72ac>] (core_sys_select+0x160/0x318) from [<c00a74=
90>] (sys_select+0x2c/0x1e0)
[  591.032356] [<c00a7490>] (sys_select+0x2c/0x1e0) from [<c0022f00>] (=
ret_fast_syscall+0x0/0x2c)
[  591.032376] bash          S c02c8610     0  2015   2013 0x00000000
[  591.032388] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e98>] (s=
chedule_timeout+0x184/0x1e8)
[  591.032409] [<c02c8e98>] (schedule_timeout+0x184/0x1e8) from [<c016d=
cdc>] (n_tty_read+0x4f0/0x748)
[  591.032429] [<c016dcdc>] (n_tty_read+0x4f0/0x748) from [<c0169044>] =
(tty_read+0x8c/0xd0)
[  591.032448] [<c0169044>] (tty_read+0x8c/0xd0) from [<c0097fa0>] (vfs=
_read+0xb0/0x164)
[  591.032467] [<c0097fa0>] (vfs_read+0xb0/0x164) from [<c0098124>] (sy=
s_read+0x40/0x70)
[  591.032485] [<c0098124>] (sys_read+0x40/0x70) from [<c0022f00>] (ret=
_fast_syscall+0x0/0x2c)
[  591.032504] collectd      ? c02c8610     0  2114      1 0x00000001
[  591.032517] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c0038028>] (d=
o_exit+0x494/0x708)
[  591.032539] [<c0038028>] (do_exit+0x494/0x708) from [<c00382d4>] (do=
_group_exit+0x38/0xe8)
[  591.032556] [<c00382d4>] (do_group_exit+0x38/0xe8) from [<c0043bf0>]=
 (get_signal_to_deliver+0x1dc/0x464)
[  591.032578] [<c0043bf0>] (get_signal_to_deliver+0x1dc/0x464) from [<=
c00250cc>] (do_signal+0x50/0x50c)
[  591.032599] [<c00250cc>] (do_signal+0x50/0x50c) from [<c0022f4c>] (w=
ork_pending+0x1c/0x20)
[  591.032617] collectd      D c02c8610     0  2115      1 0x00000001
[  591.032630] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e60>] (s=
chedule_timeout+0x14c/0x1e8)
[  591.032651] [<c02c8e60>] (schedule_timeout+0x14c/0x1e8) from [<c02c8=
344>] (io_schedule_timeout+0x34/0x58)
[  591.032672] [<c02c8344>] (io_schedule_timeout+0x34/0x58) from [<c007=
caf0>] (congestion_wait+0x5c/0x80)
[  591.032694] [<c007caf0>] (congestion_wait+0x5c/0x80) from [<c0070fb0=
>] (balance_dirty_pages_ratelimited_nr+0xe8/0x290)
[  591.032715] [<c0070fb0>] (balance_dirty_pages_ratelimited_nr+0xe8/0x=
290) from [<c007e6bc>] (do_wp_page+0x294/0x868)
[  591.032737] [<c007e6bc>] (do_wp_page+0x294/0x868) from [<c007f2ec>] =
(handle_mm_fault+0x1e8/0x6e8)
[  591.032758] [<c007f2ec>] (handle_mm_fault+0x1e8/0x6e8) from [<c00293=
10>] (do_page_fault+0x1a4/0x24c)
[  591.032778] [<c0029310>] (do_page_fault+0x1a4/0x24c) from [<c0022294=
>] (do_DataAbort+0x30/0x94)
[  591.032797] [<c0022294>] (do_DataAbort+0x30/0x94) from [<c0022e9c>] =
(ret_from_exception+0x0/0x10)
[  591.032816] Exception stack(0xdf2c9fb0 to 0xdf2c9ff8)
[  591.032822] 9fa0:                                     437cb788 401c5=
378 00000007 00000055=20
[  591.032839] 9fc0: 0000001d 437cb788 00000000 00000000 40fc9d40 00000=
000 00000000 00000000=20
[  591.032857] 9fe0: 437cb788 40fc9b38 401a7718 400c1f64 20000010 fffff=
fff                  =20
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
