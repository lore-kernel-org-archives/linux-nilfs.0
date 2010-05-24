From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: gentoo amd64 based bootable cd with latest kernel and nilfs2
 utils
Date: Tue, 25 May 2010 03:30:32 +0900 (JST)
Message-ID: <20100525.033032.179933266.ryusuke@osrg.net>
References: <4BFA9737.5090402@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFA9737.5090402-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 24 May 2010 17:11:51 +0200, David Arendt wrote:
> Hi,
> 
> In order to facilate problem solving for the case my system using nilfs2
> as root filesystem is not booting correctly, I created a gentoo amd64
> based boot cd using latest kernel and nilfs2 utilities. If you think it
> could be usefull for other people too, I could either create an own
> webpage to host the iso image or you could add it to the main nilfs2
> site. What do you think ?

Yes, I think this kind of rescue drives are helpful transiently.
Quite similaly, I have a usb pendrive with nilfs-utils and nilfs kmod
to maintain my nilfs root debian system just in case.

We can afford to put the iso image that you kindly collected up for
people on nilfs.org, but it seems better that you have your own site
because organizing information how to use that, looks more important
to me.  Can't say as I do.  Anyone have any ideas ?

Thanks,
Ryusuke Konishi

> Here the list of packages currently included:
> 
> [I--] [  ] app-admin/eselect-1.2.9 (0)
> [I--] [  ] app-admin/eselect-ctags-1.10 (0)
> [I--] [  ] app-admin/eselect-python-20091230 (0)
> [I--] [  ] app-admin/eselect-vi-1.1.5 (0)
> [I--] [  ] app-admin/localepurge-0.5.2 (0)
> [I--] [  ] app-admin/perl-cleaner-1.05 (0)
> [I--] [  ] app-admin/python-updater-0.8 (0)
> [I--] [  ] app-admin/syslog-ng-3.0.6 (0)
> [I--] [  ] app-arch/bzip2-1.0.5-r1 (0)
> [I--] [  ] app-arch/cpio-2.10-r1 (0)
> [I--] [  ] app-arch/gzip-1.4 (0)
> [I--] [  ] app-arch/tar-1.20 (0)
> [I--] [  ] app-arch/xz-utils-4.999.9_beta (0)
> [I--] [  ] app-editors/nano-2.2.4 (0)
> [I--] [  ] app-editors/vim-7.2.303 (0)
> [I--] [  ] app-editors/vim-core-7.2.303 (0)
> [I--] [  ] app-emulation/emul-linux-x86-baselibs-20100220 (0)
> [I--] [  ] app-misc/ca-certificates-20090709 (0)
> [I--] [  ] app-misc/livecd-tools-1.0.42 (0)
> [I--] [  ] app-misc/mime-types-8 (0)
> [I--] [  ] app-misc/pax-utils-0.1.19 (0)
> [I--] [  ] app-misc/realpath-1.15 (0)
> [I--] [  ] app-portage/gentoolkit-0.2.4.6.1-r1 (0)
> [I--] [  ] app-portage/portage-utils-0.2.1 (0)
> [I--] [  ] app-shells/bash-4.0_p37 (0)
> [I--] [  ] dev-lang/perl-5.8.8-r8 (0)
> [I--] [  ] dev-lang/python-2.6.5-r2 (2.6)
> [I--] [  ] dev-libs/eventlog-0.2.10 (0)
> [I--] [  ] dev-libs/expat-2.0.1-r3 (0)
> [I--] [  ] dev-libs/glib-2.22.5 (2)
> [I--] [  ] dev-libs/gmp-4.3.2 (0)
> [I--] [  ] dev-libs/libffi-3.0.9 (0)
> [I--] [  ] dev-libs/libpcre-7.9-r1 (3)
> [I--] [  ] dev-libs/libxml2-2.7.7 (2)
> [I--] [  ] dev-libs/mpfr-2.4.1_p5 (0)
> [I--] [  ] dev-libs/openssl-0.9.8n (0)
> [I--] [  ] dev-libs/popt-1.15 (0)
> [I--] [  ] dev-perl/Locale-gettext-1.05-r1 (0)
> [I--] [  ] dev-util/ctags-5.7 (0)
> [I--] [  ] dev-util/dialog-1.1.20080819 (0)
> [I--] [  ] dev-util/pkgconfig-0.23 (0)
> [I--] [  ] net-dialup/mingetty-1.08 (0)
> [I--] [  ] net-misc/iputils-20071127 (0)
> [I--] [  ] net-misc/openssh-5.3_p1-r1 (0)
> [I--] [  ] net-misc/rsync-3.0.6 (0)
> [I--] [  ] net-misc/wget-1.12 (0)
> [I--] [  ] sys-apps/acl-2.2.49 (0)
> [I--] [  ] sys-apps/attr-2.4.43 (0)
> [I--] [  ] sys-apps/baselayout-1.12.13 (0)
> [I--] [  ] sys-apps/busybox-1.15.3 (0)
> [I--] [  ] sys-apps/coreutils-8.4 (0)
> [I--] [  ] sys-apps/debianutils-3.1.3 (0)
> [I--] [  ] sys-apps/diffutils-2.8.7-r2 (0)
> [I--] [  ] sys-apps/file-5.03 (0)
> [I--] [  ] sys-apps/findutils-4.4.2 (0)
> [I--] [  ] sys-apps/gawk-3.1.6 (0)
> [I--] [  ] sys-apps/grep-2.5.4-r1 (0)
> [I--] [  ] sys-apps/groff-1.20.1-r1 (0)
> [I--] [  ] sys-apps/help2man-1.36.4-r1 (0)
> [I--] [  ] sys-apps/kbd-1.15 (0)
> [I--] [  ] sys-apps/less-436 (0)
> [I--] [  ] sys-apps/man-1.6f-r3 (0)
> [I--] [  ] sys-apps/man-pages-3.24 (0)
> [I--] [  ] sys-apps/man-pages-posix-2003a (0)
> [I--] [  ] sys-apps/memtest86+-2.01 (0)
> [I--] [  ] sys-apps/module-init-tools-3.5 (0)
> [I--] [  ] sys-apps/net-tools-1.60_p20090728014017-r1 (0)
> [I--] [  ] sys-apps/pciutils-3.1.4 (0)
> [I--] [  ] sys-apps/portage-2.1.8.3 (0)
> [I--] [  ] sys-apps/sandbox-1.6-r2 (0)
> [I--] [  ] sys-apps/sed-4.2 (0)
> [I--] [  ] sys-apps/shadow-4.1.2.2 (0)
> [I--] [  ] sys-apps/slocate-3.1-r1 (0)
> [I--] [  ] sys-apps/smartmontools-5.38 (0)
> [I--] [  ] sys-apps/sysvinit-2.87-r3 (0)
> [I--] [  ] sys-apps/tcp-wrappers-7.6-r8 (0)
> [I--] [  ] sys-apps/texinfo-4.13 (0)
> [I--] [  ] sys-apps/util-linux-2.16.2 (0)
> [I--] [  ] sys-apps/which-2.20 (0)
> [I--] [  ] sys-auth/pambase-20100310 (0)
> [I--] [  ] sys-boot/grub-0.97-r9 (0)
> [I--] [  ] sys-devel/autoconf-2.63-r1 (2.5)
> [I--] [  ] sys-devel/autoconf-wrapper-7 (0)
> [I--] [  ] sys-devel/automake-1.11.1 (1.11)
> [I--] [  ] sys-devel/automake-wrapper-4 (0)
> [I--] [  ] sys-devel/bc-1.06.95 (0)
> [I--] [  ] sys-devel/binutils-2.18-r3 (0)
> [I--] [  ] sys-devel/binutils-config-1.9-r4 (0)
> [I--] [  ] sys-devel/bison-2.4.1 (0)
> [I--] [  ] sys-devel/flex-2.5.35 (0)
> [I--] [  ] sys-devel/gcc-4.3.4 (4.3)
> [I--] [  ] sys-devel/gcc-config-1.4.1 (0)
> [I--] [  ] sys-devel/gettext-0.17-r1 (0)
> [I--] [  ] sys-devel/gnuconfig-20100122 (0)
> [I--] [  ] sys-devel/libperl-5.8.8-r2 (1)
> [I--] [  ] sys-devel/libtool-2.2.6b (1.5)
> [I--] [  ] sys-devel/m4-1.4.12 (0)
> [I--] [  ] sys-devel/make-3.81 (0)
> [I--] [  ] sys-devel/patch-2.5.9 (0)
> [I--] [  ] sys-fs/dosfstools-3.0.2 (0)
> [I--] [  ] sys-fs/e2fsprogs-1.41.9 (0)
> [I--] [  ] sys-fs/fuse-2.8.1 (0)
> [I--] [ ~] sys-fs/nilfs-utils-2.0.18 (0)
> [I--] [  ] sys-fs/ntfs3g-2010.1.16 (0)
> [I--] [  ] sys-fs/udev-149 (0)
> [I--] [  ] sys-fs/xfsprogs-3.0.3 (0)
> [I--] [  ] sys-kernel/genkernel-3.4.10.906 (0)
> [I--] [  ] sys-kernel/linux-headers-2.6.30-r1 (0)
> [I--] [  ] sys-libs/cracklib-2.8.15 (0)
> [I--] [  ] sys-libs/db-4.7.25_p4 (4.7)
> [I--] [  ] sys-libs/e2fsprogs-libs-1.41.9 (0)
> [I--] [  ] sys-libs/gdbm-1.8.3-r4 (0)
> [I--] [  ] sys-libs/glibc-2.10.1-r1 (2.2)
> [I--] [  ] sys-libs/gpm-1.20.5 (0)
> [I--] [  ] sys-libs/ncurses-5.7-r3 (5)
> [I--] [  ] sys-libs/pam-1.1.0 (0)
> [I--] [  ] sys-libs/readline-6.1 (0)
> [I--] [  ] sys-libs/timezone-data-2010i (0)
> [I--] [  ] sys-libs/zlib-1.2.3-r1 (0)
> [I--] [  ] sys-process/procps-3.2.8 (0)
> [I--] [  ] sys-process/psmisc-22.10 (0)
> [I--] [  ] virtual/acl-0 (0)
> [I--] [  ] virtual/editor-0 (0)
> [I--] [  ] virtual/init-0 (0)
> [I--] [  ] virtual/libffi-0 (0)
> [I--] [  ] virtual/libiconv-0 (0)
> [I--] [  ] virtual/libintl-0 (0)
> [I--] [  ] virtual/pager-0 (0)
> 
> 
> Bye,
> David Arendt
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
