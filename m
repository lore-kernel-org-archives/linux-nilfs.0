From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Fwd: Re: Broken nilfs2 filesystem
Date: Fri, 26 Jul 2013 18:52:21 +0200
Message-ID: <51F2A945.6050909@antoneliasson.se>
References: <51F2A8A4.4020400@antoneliasson.se>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F2A8A4.4020400-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I forgot to send this to the list.

-------- Ursprungligt meddelande --------
=C3=84mne: 	Re: Broken nilfs2 filesystem
Datum: 	Fri, 26 Jul 2013 18:49:40 +0200
=46r=C3=A5n: 	Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Till: 	Vyacheslav Dubeyko <slava-2lV3ebY47BVBDgjK7y7TUQ@public.gmane.org>



Vyacheslav Dubeyko skrev 2013-07-26 14:37:
> Hi Anton,
>
> Do you ready to try to obtain debug output? I am really waiting your
> readiness because your opportunity to reproduce the issue is very
> important.
>
> I think that it needs to enable such configuration options:
> 1. CONFIG_NILFS2_DEBUG_SHOW_ERRORS
> 2. CONFIG_NILFS2_DEBUG_BASE_OPERATIONS
> 3. CONFIG_NILFS2_DEBUG_MDT_FILES
> 4. CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM
> 5. CONFIG_NILFS2_DEBUG_BLOCK_MAPPING
> 6. CONFIG_NILFS2_DEBUG_DUMP_STACK
>
> Thanks,
> Vyacheslav Dubeyko.

Hi,
Thanks for the reminder! I tried it out a few weeks ago. My plan then
was to restore the old root system (running Linux 3.9) and /home to the
mechanical hard drive, boot them up and use that system to build the
newer kernel with your kernel. This would make minimal changes to the
system I had experienced the bugs with, I thought.

Building the kernel took me some time but I eventually succeded. I
forgot those configuration options though so I suppose that build did
nothing out of the ordinary, even though it had the patches. I got it t=
o
boot but then ran in to the issue of incompatible video drivers. I've
been down that road before and I did not feel like going back.

My next plan was to wait until 3.10 got released into the core
repository which happened yesterday or so. I would then use my fully
updated system (currently running the 3.10 kernel on an ext4 root
filesystem) to build a kernel with the debug patches. It would be a
slightly different system with many updated packages, but at least the
root filesystem will be a healthy ext4. So that's what I did today.
Buildlogs excerpts are at the bottom of this message.

I got the kernel to boot and X to start. But as soon as anything tried
to read from /home (even just logging into a virtual terminal as a
regular user), that terminal froze. Logging in as root to a different V=
T
showed that syslog-ng and nilfs_cleanerd took 100% CPU each. After a
while the entire system froze. Pressing Alt+SysRq+R caused the kernel t=
o
spew out an endless stream of call traces to the terminal, leaving no
other way to reboot than a hard reset. After a reboot I found that the
running nilfs_cleanerd does not respond to either a SIGTERM or a SIGKIL=
L.

Changing the mount options of /home from rw,noatime,discard to
ro,norecovery,noatime,discard seems to work. No crashes during login to
a VT. Read-only is no fun though.

Next attempt is rw,nogc,noatime,discard. It seems to work also, though
there are a lot of call traces in dmesg. After just a few reboots and a
few minutes of uptime, /var/log/kernel.log, messages.log and
everything.log have grown to 3.5 GB each. My / is only 30 GB so I can't
sustain this for very long.

I have aborted the experiments for today. kernel.log has 35 million
lines and compresses to 220 MB. I've uploaded it here
(http://antoneliasson.se/publicdump/kernel.log.20130726.gz). What shoul=
d
I do next?

Build logs
=3D=3D=3D=3D=3D=3D=3D

* Download kernel package build scripts and patches (from the Arch Buil=
d
System). Unpack and apply downstream patches:

     $ makepkg -o
     =3D=3D> Skapar paket: linux 3.10.2-1 (fre jul 26 17:08:16 CEST 201=
3)
     =3D=3D> Retrieving sources...
       -> Hittade linux-3.10.tar.xz
       -> Laddar ner patch-3.10.2.xz...
       % Total    % Received % Xferd  Average Speed   Time Time
Time  Current
                                      Dload  Upload   Total Spent
Left  Speed
     100   178  100   178    0     0    188      0 --:--:-- --:--:--
--:--:--   188
     100 27876  100 27876    0     0  13761      0  0:00:02  0:00:02
--:--:-- 37978
       -> Hittade config
       -> Hittade config.x86_64
       -> Hittade linux.preset
       -> Hittade change-default-console-loglevel.patch
     =3D=3D> Validerar k=C3=A4llfiler med md5sums...
         linux-3.10.tar.xz ... Godk=C3=A4nd
         patch-3.10.2.xz ... Godk=C3=A4nd
         config ... Godk=C3=A4nd
         config.x86_64 ... Godk=C3=A4nd
         linux.preset ... Godk=C3=A4nd
         change-default-console-loglevel.patch ... Godk=C3=A4nd
     =3D=3D> Extracting sources...
       -> Extraherar linux-3.10.tar.xz med bsdtar
       -> Extraherar patch-3.10.2.xz med xz
     =3D=3D> Startar prepare()...
     patching file Documentation/parisc/registers
     patching file MAINTAINERS
     patching file Makefile
     patching file arch/arm/boot/dts/imx23.dtsi
     patching file arch/arm/boot/dts/imx28.dtsi
     patching file arch/arm/boot/dts/imx6dl.dtsi
     patching file arch/arm/boot/dts/imx6q.dtsi
     patching file arch/arm/include/asm/mmu_context.h
     patching file arch/arm/kernel/perf_event.c
     [...]
     patching file mm/page_alloc.c
     patching file mm/slab.c
     patching file net/ceph/auth_none.c
     patching file kernel/printk.c
     Hunk #1 succeeded at 56 with fuzz 2 (offset -2 lines).
     =3D=3D> K=C3=A4llor =C3=A4r redo.
     $ ls -l
     -rw-r--r-- 1 anton anton 2,7K 26 jul 00.06
alsa-firmware-loading-3.8.8.patch
     -rw-r--r-- 1 anton anton  605 26 jul 00.06
change-default-console-loglevel.patch
     -rw-r--r-- 1 anton anton 142K 26 jul 17.13 config
     -rw-r--r-- 1 anton anton 142K 26 jul 00.06 config~
     -rw-r--r-- 1 anton anton 138K 26 jul 17.13 config.x86_64
     -rw-r--r-- 1 anton anton 138K 26 jul 00.06 config.x86_64~
     -rw-r--r-- 1 anton anton  926 26 jul 00.06 linux.install
     -rw-r--r-- 1 anton anton  376 26 jul 00.06 linux.preset
     drwxr-xr-x 2 anton anton 4,0K 26 jul 17.06
nilfs2-debug-output-patch-set-25-06-2013
     -rw-r--r-- 1 anton anton  13K 26 jul 00.06 PKGBUILD
     drwxr-xr-x 3 anton anton 4,0K 26 jul 17.08 src

* Apply nilfs2 debug patches:

     $ cd src/linux-3.10/
     $ for file in
=2E./../nilfs2-debug-output-patch-set-25-06-2013/*.patch; do patch -p1 =
<
"$file"; done
     patching file fs/nilfs2/Kconfig
     patching file fs/nilfs2/debug.h
     patching file fs/nilfs2/Kconfig
     patching file fs/nilfs2/debug.h
     patching file fs/nilfs2/dir.c
     patching file fs/nilfs2/file.c
     patching file fs/nilfs2/inode.c
     patching file fs/nilfs2/ioctl.c
     patching file fs/nilfs2/namei.c
     patching file fs/nilfs2/nilfs.h
     [...]
     patching file fs/nilfs2/segbuf.c
     patching file fs/nilfs2/segment.c
     patching file fs/nilfs2/sufile.c
     patching file fs/nilfs2/super.c
     patching file fs/nilfs2/the_nilfs.c
     patching file fs/nilfs2/Kconfig
     patching file fs/nilfs2/debug.h

* Append the following lines to config (just in case) and config.x86_64
(which I assume I will use):

     CONFIG_NILFS2_DEBUG_SHOW_ERRORS=3Dy
     CONFIG_NILFS2_DEBUG_BASE_OPERATIONS=3Dy
     CONFIG_NILFS2_DEBUG_MDT_FILES=3Dy
     CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM=3Dy
     CONFIG_NILFS2_DEBUG_BLOCK_MAPPING=3Dy
     CONFIG_NILFS2_DEBUG_DUMP_STACK=3Dy

* Build the kernel. There were some interactive configuration options
concerning nilfs2 that I responded yes to:

     $ makepkg -e
     =3D=3D> Skapar paket: linux 3.10.2-1 (fre jul 26 17:16:41 CEST 201=
3)
     =3D=3D> Checking runtime dependencies...
     =3D=3D> Checking buildtime dependencies...
     =3D=3D> VARNING:  Using existing src/ tree
     =3D=3D> Startar build()...
       HOSTCC  scripts/basic/fixdep
       HOSTCC  scripts/kconfig/conf.o
       SHIPPED scripts/kconfig/zconf.tab.c
       SHIPPED scripts/kconfig/zconf.lex.c
       SHIPPED scripts/kconfig/zconf.hash.c
       HOSTCC  scripts/kconfig/zconf.tab.o
       HOSTLD  scripts/kconfig/conf
     scripts/kconfig/conf --silentoldconfig Kconfig
     *
     * Restart config...
     *
     *
     * File systems
     *
     [...]
     NILFS2 file system support (NILFS2_FS) [M/n/y/?] m
       NILFS2 debugging (NILFS2_DEBUG) [N/y/?] (NEW) y
         Use pr_debug() instead of printk() (NILFS2_USE_PR_DEBUG)
[N/y/?] (NEW) y
         Show internal errors (NILFS2_DEBUG_SHOW_ERRORS) [N/y/?] (NEW) =
y
         Enable dump stack output (NILFS2_DEBUG_DUMP_STACK) [N/y/?] (NE=
W) y
     [...]
     #
     # configuration written to .config
     #
       SYSHDR arch/x86/syscalls/../include/generated/uapi/asm/unistd_32=
=2Eh
       SYSHDR arch/x86/syscalls/../include/generated/uapi/asm/unistd_64=
=2Eh
       SYSHDR arch/x86/syscalls/../include/generated/uapi/asm/unistd_x3=
2.h
       SYSTBL arch/x86/syscalls/../include/generated/asm/syscalls_32.h
       SYSHDR arch/x86/syscalls/../include/generated/asm/unistd_32_ia32=
=2Eh
       SYSHDR arch/x86/syscalls/../include/generated/asm/unistd_64_x32.=
h
       SYSTBL arch/x86/syscalls/../include/generated/asm/syscalls_64.h
       WRAP    arch/x86/include/generated/asm/clkdev.h
       CHK     include/generated/uapi/linux/version.h
       UPD     include/generated/uapi/linux/version.h
       CHK     include/generated/utsrelease.h
       UPD     include/generated/utsrelease.h
       HOSTCC  arch/x86/tools/relocs_32.o
     [...]
       INSTALL
/home/anton/build/linux/pkg/linux/lib/firmware/edgeport/down3.bin
       INSTALL
/home/anton/build/linux/pkg/linux/lib/firmware/keyspan_pda/keyspan_pda.=
fw
       INSTALL
/home/anton/build/linux/pkg/linux/lib/firmware/keyspan_pda/xircom_pgs.f=
w
       INSTALL
/home/anton/build/linux/pkg/linux/lib/firmware/cpia2/stv0672_vp4.bin
       INSTALL /home/anton/build/linux/pkg/linux/lib/firmware/yam/1200.=
bin
       INSTALL /home/anton/build/linux/pkg/linux/lib/firmware/yam/9600.=
bin
       DEPMOD  3.10.2-1-ARCH
     =3D=3D> St=C3=A4dar upp efter installationen...
       -> Rensar o=C3=B6nskade filer...
       -> Komprimerar man och info sidor...
     =3D=3D> Creating package "linux"...
       -> Skapar .PKGINFO fil...
       -> L=C3=A4gger till install fil...
       -> Generating .MTREE file...
       -> Komprimerar paket...
     =3D=3D> Startar package_linux-headers()...
     =3D=3D> St=C3=A4dar upp efter installationen...
       -> Rensar o=C3=B6nskade filer...
       -> Komprimerar man och info sidor...
     =3D=3D> Creating package "linux-headers"...
       -> Skapar .PKGINFO fil...
       -> Generating .MTREE file...
       -> Komprimerar paket...
     =3D=3D> Startar package_linux-docs()...
     =3D=3D> St=C3=A4dar upp efter installationen...
       -> Rensar o=C3=B6nskade filer...
       -> Komprimerar man och info sidor...
     =3D=3D> Creating package "linux-docs"...
       -> Skapar .PKGINFO fil...
       -> Generating .MTREE file...
       -> Komprimerar paket...
     =3D=3D> Leaving fakeroot environment.
     =3D=3D> Kompilering klar: linux 3.10.2-1 (fre jul 26 17:46:42 CEST=
 2013)

* Install over the stock 3.10 kernel, point /home to the old nilfs2
filesystem in /etc/fstab and reboot.

--=20
Best Regards,
Anton Eliasson



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
