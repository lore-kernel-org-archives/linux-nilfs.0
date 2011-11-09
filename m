From: Shingo TAKADA <takada-tMH8t/rmczD1BV07Z2N/PQ@public.gmane.org>
Subject: nilfs2 on Scientific Linux 6
Date: Wed, 09 Nov 2011 16:18:53 +0900
Message-ID: <4EBA295D.3060400@takezono2.tv>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-2022-jp"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hi.

I'm trying to use nilfs2 on Scientific Linux 6.1 with kernel
2.6.32-131.17.1.el6.x86_64.
currently, there's no official package for SL6.1 (and RHEL6),
so i tried to build rpm package using CentOS 5's srpm.

i installed nilfs-kmod-2.0.22-4.src.rpm, extract nilfs-2.0.22.tar.bz2 and
tried to make, but fails like:

$ pwd
/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs
$ make -C /usr/src/kernels/2.6.32-131.17.1.el6.x86_64 M=`pwd`
make: Entering directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'
  LD      /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/built-in.o
  CC [M]  /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.o
In file included from /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.c:28:
/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/nilfs.h: In function ‘nilfs_init_acl’:
/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/nilfs.h:234: error: dereferencing
pointer to incomplete type
make[1]: *** [/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.o] Error 1
make: *** [_module_/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs] Error 2
make: Leaving directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'


I installed SL6.1's kernel Source RPM(srpm) , try to make from the
sources in the srpm. i installed kernel-2.6.32-131.17.1.el6.src.rpm
using yumdownloader.

but fails like:
$ pwd
/tmp/sl6-srpm-nilfs2
$ make -C /usr/src/kernels/2.6.32-131.17.1.el6.x86_64 M=`pwd`
make: Entering directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'
  LD      /tmp/sl6-srpm-nilfs2/built-in.o
  CC [M]  /tmp/sl6-srpm-nilfs2/inode.o
  CC [M]  /tmp/sl6-srpm-nilfs2/file.o
  CC [M]  /tmp/sl6-srpm-nilfs2/dir.o
  CC [M]  /tmp/sl6-srpm-nilfs2/super.o
  CC [M]  /tmp/sl6-srpm-nilfs2/namei.o
  CC [M]  /tmp/sl6-srpm-nilfs2/page.o
  CC [M]  /tmp/sl6-srpm-nilfs2/mdt.o
  CC [M]  /tmp/sl6-srpm-nilfs2/btnode.o
  CC [M]  /tmp/sl6-srpm-nilfs2/bmap.o
  CC [M]  /tmp/sl6-srpm-nilfs2/btree.o
  CC [M]  /tmp/sl6-srpm-nilfs2/direct.o
  CC [M]  /tmp/sl6-srpm-nilfs2/dat.o
  CC [M]  /tmp/sl6-srpm-nilfs2/recovery.o
  CC [M]  /tmp/sl6-srpm-nilfs2/the_nilfs.o
  CC [M]  /tmp/sl6-srpm-nilfs2/segbuf.o
/tmp/sl6-srpm-nilfs2/segbuf.c: In function ‘nilfs_segbuf_write’:
/tmp/sl6-srpm-nilfs2/segbuf.c:396: error: ‘REQ_UNPLUG’ undeclared (first
use in this function)
/tmp/sl6-srpm-nilfs2/segbuf.c:396: error: (Each undeclared identifier is
reported only once
/tmp/sl6-srpm-nilfs2/segbuf.c:396: error: for each function it appears in.)
make[1]: *** [/tmp/sl6-srpm-nilfs2/segbuf.o] Error 1
make: *** [_module_/tmp/sl6-srpm-nilfs2] Error 2
make: Leaving directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'


then, i also tried with original kernel code from kernel.org,
linux-2.6.32.27.
in this case, make is done successfully and i got nilfs2.ko.

copy the .ko, modprobe it, and make nilfs2 partition following the guide
on the web.

after mounting the partition, dmesg reports:

segctord starting. Construction interval = 5 seconds, CP frequency < 30
seconds
------------[ cut here ]------------
WARNING: at block/blk-core.c:1244 __make_request+0x525/0x5a0() (Not tainted)
block: BARRIER is deprecated, use FLUSH/FUA instead
Modules linked in: nilfs2(U) autofs4 nfs lockd fscache nfs_acl
auth_rpcgss sunrpc xenfs ipv6 ipt_REJECT nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables dm_mirror
dm_region_hash dm_log microcode xen_netfront ext4 mbcache jbd2
xen_blkfront dm_mod [last unloaded: scsi_wait_scan]
Pid: 1649, comm: mount.nilfs2 Not tainted 2.6.32-131.17.1.el6.x86_64 #1
Call Trace:
 [<ffffffff810670f7>] ? warn_slowpath_common+0x87/0xc0
 [<ffffffff81007c4f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff810671e6>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff8124ad55>] ? __make_request+0x525/0x5a0
 [<ffffffff81007c62>] ? check_events+0x12/0x20
 [<ffffffff8124920e>] ? generic_make_request+0x21e/0x5b0
 [<ffffffff8124962f>] ? submit_bio+0x8f/0x120
 [<ffffffff811a2ab6>] ? submit_bh+0xf6/0x150
 [<ffffffff811a4df3>] ? __sync_dirty_buffer+0x53/0xf0
 [<ffffffff811a4ea3>] ? sync_dirty_buffer+0x13/0x20
 [<ffffffffa02367d5>] ? nilfs_commit_super+0x175/0x2e0 [nilfs2]
 [<ffffffffa0236b6e>] ? nilfs_setup_super+0x7e/0xc0 [nilfs2]
 [<ffffffffa0237518>] ? nilfs_get_sb+0x578/0x730 [nilfs2]
 [<ffffffff8115473a>] ? alloc_pages_current+0xaa/0x110
 [<ffffffff8117569b>] ? vfs_kern_mount+0x7b/0x1b0
 [<ffffffff81175842>] ? do_kern_mount+0x52/0x130
 [<ffffffff81193317>] ? do_mount+0x2e7/0x870
 [<ffffffff81190df2>] ? copy_mount_options+0xf2/0x1a0
 [<ffffffff81193930>] ? sys_mount+0x90/0xe0
 [<ffffffff8100b172>] ? system_call_fastpath+0x16/0x1b
---[ end trace 75b36a1725360299 ]---
NILFS warning (device xvdb1): nilfs_sync_super: barrier-based sync
failed. disabling barriers

file operations are working fine. i can write and read files.
but i tried to unmount the partition, kernel panics.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000229
IP: [<ffffffff8112533e>] __remove_mapping+0x8e/0x160
(snip)
Call Trace:
remove_mapping, invalidate_inode_page, invalidate_mapping_pages,
__wait_on_buffer,
__sync_dirty_buffer, nilfs_mdt_clear, nilfs_detach_checkpoint,
nilfs_put_super,
generic_shutdown_super, kill_block_super, ...
---
Kernel panic - not syncing: Fatal exception
Pid: 1635, comm: umount.nilfs2 Tainted: G      D W


how should i do to use nilfs on SL6 environment?
or do you have any plan to release CentOS6 package of nilfs?

my environment: Scientific Linux 6.1 x64 on XenServer 5.6 SP2.

Shingo TAKADA
-- 
takada-tMH8t/rmczD1BV07Z2N/PQ@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
