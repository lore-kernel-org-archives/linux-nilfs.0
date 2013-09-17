From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Best way to shut down NILFS2? (umount hang issue)...
Date: Tue, 17 Sep 2013 18:42:32 -0400
Message-ID: <5238DAD8.3070804@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=dwoGqmqd1YgHPm/zNjULlfrEIu4TOW28QpUch2uRa+8=;
        b=R/ynBF47YA6TN7prXG0R8SRsOrluYPWBgk9MZgC52jeFzGshCJLm5eEJppRvC+NGMV
         AijE57GiuPizv+qcxmFdzb5bKIFqeRG2Yj0kQ3wBgdpoJEEBwa6nxa2N/t893ISrAk8k
         YohYHTzI4ZJTpfTIehK1cWbUKGlDxRLAZ43C2PwCgaYB9mW0QSEN7Tz67ZGcaA9m8rD4
         abCAG2TLaOFyPVyfHFVOcJBfLaM+3uaIiMLL0XcA0PoYoYUjO00XQ9B4u4KaLSMjj9RL
         ylaNqOW0favS2ggnoyBumpZ8bcZJFK9b9XQxcaopUzBeFyAwqFza4CH3MEuQVrXyC1hg
         dL3w==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi!  I have an old multi-boot x86 PC that I use for testing.
One of its root partitions is NILFS2, and it is booted via LILO and
a JFS-formatted /boot partition.  All seems fine, but the umount of /
can hang, especially when NILFS2 had to recover / on boot in read-only
mode due to a crash.  Using KDB to get stack traces, I wonder if 
segctord is waiting for an event that will not happen.

[Actually, the umount of NILFS2 partitons can hang in other cases, too.
This is a narrow case that I can repeat fairly often.]

Is there a guaranteed good way to shutdown nilfs_cleanerd and NILFS2
properly on system shutdown?  I tried to ensure that the killall5
program doesn't touch nilfs_cleanerd on shutdown, but that solution
has started to not work again.

The PC is an i686 Pentium 4 PC (32-bit), running a 3-day-old git Linux
3.11.0+ kernel.  The operating system is slackware-current.  It's set
up for activities like kdb/kgdb and crash dumps, but I'm not very
familiar with some of the programs I've installed here, especially gdb.

If NILFS2 is more durable when the hard drive's write cache has been 
shut off, let me know, and I'll start over using a fresh NILFS2 file 
system and try to get this error again.

Thanks!

Michael

# SCENARIO #1: umount.nilfs2 and segctord are part of a hung shutdown

# For this, /boot and /tmp are JFS, and / is NILFS2.  Once the non-NILFS2 
# filesystems have been unmounted, there's an attempt to remount / 
# read-only.  However, it hangs like this in 1 of 10 reboots for 
# clean mounts.  If NILFS2 had to recover from a crash on boot, then this 
# will be the case on 1 of every 2 reboots:

0xde343ea0       70        2  0    0   D  0xde344158  segctord
 de3eddb8 00000092 de3edd70 c1071975 00000000 de343ea0 4950d87b 000000a3
 de3ec000 de343ea0 00000000 c1554337 de343ea0 00000002 de3edd98 00000002
 dfeee220 00000282 de3442e8 00000046 00000282 dfeee220 de3edda0 c107306f
Call Trace:
 [<c1071975>] ? lock_release_holdtime.part.22+0xba/0xed
 [<c1554337>] ? _raw_spin_unlock_irqrestore+0x2f/0x56
 [<c107306f>] ? trace_hardirqs_on+0xb/0xd
 [<c1109c41>] ? inode_lru_list_del+0x27/0x27
 [<c15529cb>] schedule+0x22/0x4c
 [<c1109c4e>] inode_wait+0xd/0x11
 [<c154fd9e>] __wait_on_bit+0x4e/0x6b
 [<c1109c41>] ? inode_lru_list_del+0x27/0x27
 [<c11179ff>] __inode_wait_for_writeback+0x80/0x98
 [<c104c06d>] ? autoremove_wake_function+0x3d/0x3d
 [<c1119d13>] inode_wait_for_writeback+0x1d/0x28
 [<c110a7a3>] evict+0x83/0x15d
 [<c110b2a1>] iput+0xc3/0x137
 [<c12a74a2>] nilfs_dispose_list+0xfc/0x14b
 [<c12a7867>] nilfs_transaction_unlock+0x55/0x5e
 [<c12aa000>] nilfs_segctor_thread+0xd5/0x2ad
 [<c12a9f2b>] ? nilfs_segctor_construct+0x229/0x229
 [<c104b557>] kthread+0xa7/0xa9
 [<c15556b7>] ret_from_kernel_thread+0x1b/0x28
 [<c104b4b0>] ? insert_kthread_work+0x63/0x63

Stack traceback for pid 392
0xc01514e0      392      391  0    0   D  0xc0151798  umount.nilfs2
 dddd7de0 00000086 3c20b7bc 00000129 00000000 c01514e0 1d8dd8ca 000000a2
 dddd6000 c01514e0 000000a2 0003794c 00000000 1d8deaf9 000000a2 00000000
 c107308b 00000000 dddd7dcc c10587b4 df016580 00000086 c0151950 dddd7dcc
Call Trace:
 [<c107308b>] ? trace_hardirqs_off_caller+0x1a/0x116
 [<c10587b4>] ? sched_clock_cpu+0x8f/0xe2
 [<c15529cb>] schedule+0x22/0x4c
 [<c154fc08>] schedule_timeout+0xf8/0x1e8
 [<c1554385>] ? _raw_spin_unlock_irq+0x27/0x36
 [<c107306f>] ? trace_hardirqs_on+0xb/0xd
 [<c1552d66>] wait_for_completion+0x9e/0xce
 [<c1055d3f>] ? try_to_wake_up+0x138/0x138
 [<c111a986>] sync_inodes_sb+0xc3/0x1f2
 [<c1552cf3>] ? wait_for_completion+0x2b/0xce
 [<c111da6a>] sync_filesystem+0x51/0x88
 [<c10f623b>] do_remount_sb+0x43/0x168
 [<c155205a>] ? down_write+0x92/0x99
 [<c1110f72>] SyS_umount+0x2cf/0x2ff
 [<c1554f0b>] ? restore_all+0xf/0xf
 [<c1110fc0>] SyS_oldumount+0x1e/0x20
 [<c155573b>] sysenter_do_call+0x12/0x32

# SCENARIO #2: segctord and sync are part of a hung shutdown

# Shutdown, using NILFS2 for / and /tmp.  I tried to umount 
# the non-NILFS2 filesystems first, then run sync, then umount 
# the NILFS2 filesystems.  It stopped at sync, where sync and 
# segctord wait on the same things as do umount.nifs2 and 
# segctord.  In other words, the shutdown script might not had 
# a chance to umount the NILFS2 file systems.

Entering kdb (current=0xc171b620, pid 0) due to Keyboard Entry
kdb> ps
48 sleeping system daemon (state M) processes suppressed,
use 'ps A' to see all.
Task Addr       Pid   Parent [*] cpu State Thread     Command
0xc171b620        0        0  1    0   R  0xc171b8d8 *swapper

0xdf098000        1        0  0    0   S  0xdf0982b8  init
0xdde9a9c0       72        2  0    0   D  0xdde9ac78  segctord
0xdd44e860      102        1  0    0   S  0xdd44eb18  nilfs_cleanerd
0xdd44a9c0      108        1  0    0   S  0xdd44ac78  nilfs_cleanerd
0xdae329c0     2187        1  0    0   S  0xdae32c78  rc.6
0xdde9e860     2264     2187  0    0   D  0xdde9eb18  sync
kdb> btp 72
Stack traceback for pid 72
0xdde9a9c0       72        2  0    0   D  0xdde9ac78  segctord
 dd421db8 00000092 dd421d70 c1071975 00000000 dde9a9c0 8da9428a 0000001e
 dd420000 dde9a9c0 00000000 c153ab67 dde9a9c0 00000002 dd421d98 00000002
 dfeee7c0 00000282 dde9ae08 00000046 00000282 dfeee7c0 dd421da0 c107306f
Call Trace:
 [<c1071975>] ? lock_release_holdtime.part.22+0xba/0xed
 [<c153ab67>] ? _raw_spin_unlock_irqrestore+0x2f/0x56
 [<c107306f>] ? trace_hardirqs_on+0xb/0xd
 [<c1109c41>] ? inode_lru_list_del+0x27/0x27
 [<c15391fb>] schedule+0x22/0x4c
 [<c1109c4e>] inode_wait+0xd/0x11
 [<c15365ce>] __wait_on_bit+0x4e/0x6b
 [<c1109c41>] ? inode_lru_list_del+0x27/0x27
 [<c11179ff>] __inode_wait_for_writeback+0x80/0x98
 [<c104c06d>] ? autoremove_wake_function+0x3d/0x3d
 [<c1119d13>] inode_wait_for_writeback+0x1d/0x28
 [<c110a7a3>] evict+0x83/0x15d
 [<c110b2a1>] iput+0xc3/0x137
 [<c12a5672>] nilfs_dispose_list+0xfc/0x14b
 [<c12a5a37>] nilfs_transaction_unlock+0x55/0x5e
 [<c12a81d0>] nilfs_segctor_thread+0xd5/0x2ad
 [<c12a80fb>] ? nilfs_segctor_construct+0x229/0x229
 [<c104b557>] kthread+0xa7/0xa9
 [<c153bf37>] ret_from_kernel_thread+0x1b/0x28
 [<c104b4b0>] ? insert_kthread_work+0x63/0x63
kdb> btp 2264
Stack traceback for pid 2264
0xdde9e860     2264     2187  0    0   D  0xdde9eb18  sync
 dbf43e3c 00000096 16f4459c 0000003b 00000000 dde9e860 5d9bbbf5 0000001d
 dbf42000 dde9e860 0000001d 00163d3a 00000000 5d9ce464 0000001d 00000000
 c107308b 00000000 dbf43e28 c10587b4 df016580 00000086 dde9ecd0 dbf43e28
Call Trace:
 [<c107308b>] ? trace_hardirqs_off_caller+0x1a/0x116
 [<c10587b4>] ? sched_clock_cpu+0x8f/0xe2
 [<c15391fb>] schedule+0x22/0x4c
 [<c1536438>] schedule_timeout+0xf8/0x1e8
 [<c153abb5>] ? _raw_spin_unlock_irq+0x27/0x36
 [<c107306f>] ? trace_hardirqs_on+0xb/0xd
 [<c1539596>] wait_for_completion+0x9e/0xce
 [<c1055d3f>] ? try_to_wake_up+0x138/0x138
 [<c111a986>] sync_inodes_sb+0xc3/0x1f2
 [<c1539523>] ? wait_for_completion+0x2b/0xce
 [<c111d955>] sync_inodes_one_sb+0x15/0x17
 [<c10f5eb9>] iterate_supers+0xc5/0xc7
 [<c111d940>] ? SyS_tee+0x2c5/0x2c5
 [<c111dad2>] sys_sync+0x31/0x78
 [<c153bfbb>] sysenter_do_call+0x12/0x32
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
