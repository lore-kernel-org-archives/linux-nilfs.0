From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Deadlock with nilfs on 2.6.31.4
Date: Wed, 21 Oct 2009 20:38:47 +0200
Message-ID: <20091021203847.26acab0a@neptune.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: users@nilfs.org
Cc: linux-fsdevel@vger.kernel.org

Hi,

nilfs seems to have some dead-locks that put processes in D-state (at
least on my arm system).
This time around it seems that syslog-ng has been hit first. The
previous times it most often was collectd/rrdtool.

Kernel is vanilla 2.6.31.4 + a patch for USB HID device. System is arm,
Feroceon 88FR131, SheevaPlug. nilfs is being used on a SD card
(mmcblk0: mmc0:bc20 SD08G 7.60 GiB, mvsdio driver)

Bruno



Extracts from dmesg (less attempting to read a logfile produced by syslog-ng):
INFO: task less:15839 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
less          D c02c8610     0 15839   1742 0x00000001
[<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c9318>] (__mutex_lock_slowpath+0x88/0x140)
[<c02c9318>] (__mutex_lock_slowpath+0x88/0x140) from [<c009833c>] (generic_file_llseek+0x24/0x64)
[<c009833c>] (generic_file_llseek+0x24/0x64) from [<c0096d74>] (vfs_llseek+0x54/0x64)
[<c0096d74>] (vfs_llseek+0x54/0x64) from [<c00981c8>] (sys_llseek+0x74/0xcc)
[<c00981c8>] (sys_llseek+0x74/0xcc) from [<c0022f00>] (ret_fast_syscall+0x0/0x2c)


All stuck processes as listed by SysRq + T:
syslog-ng     D c02c8610     0  1698      1 0x00000000
[<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e60>] (schedule_timeout+0x14c/0x1e8)
[<c02c8e60>] (schedule_timeout+0x14c/0x1e8) from [<c02c8344>] (io_schedule_timeout+0x34/0x58)
[<c02c8344>] (io_schedule_timeout+0x34/0x58) from [<c007caf0>] (congestion_wait+0x5c/0x80)
[<c007caf0>] (congestion_wait+0x5c/0x80) from [<c0070fb0>] (balance_dirty_pages_ratelimited_nr+0xe8/0x290)
[<c0070fb0>] (balance_dirty_pages_ratelimited_nr+0xe8/0x290) from [<c0069f04>] (generic_file_buffered_write+0x10c/0x348)
[<c0069f04>] (generic_file_buffered_write+0x10c/0x348) from [<c006a64c>] (__generic_file_aio_write_nolock+0x264/0x4f4)
[<c006a64c>] (__generic_file_aio_write_nolock+0x264/0x4f4) from [<c006b3b8>] (generic_file_aio_write+0x74/0xe8)
[<c006b3b8>] (generic_file_aio_write+0x74/0xe8) from [<c0097228>] (do_sync_write+0xbc/0x100)
[<c0097228>] (do_sync_write+0xbc/0x100) from [<c0097d3c>] (vfs_write+0xb0/0x164)
[<c0097d3c>] (vfs_write+0xb0/0x164) from [<c0097ec0>] (sys_write+0x40/0x70)
[<c0097ec0>] (sys_write+0x40/0x70) from [<c0022f00>] (ret_fast_syscall+0x0/0x2c)
less          D c02c8610     0 15839   1742 0x00000001
[<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c9318>] (__mutex_lock_slowpath+0x88/0x140)
[<c02c9318>] (__mutex_lock_slowpath+0x88/0x140) from [<c009833c>] (generic_file_llseek+0x24/0x64)
[<c009833c>] (generic_file_llseek+0x24/0x64) from [<c0096d74>] (vfs_llseek+0x54/0x64)
[<c0096d74>] (vfs_llseek+0x54/0x64) from [<c00981c8>] (sys_llseek+0x74/0xcc)
[<c00981c8>] (sys_llseek+0x74/0xcc) from [<c0022f00>] (ret_fast_syscall+0x0/0x2c)
sshd          D c02c8610     0 15844  15842 0x00000001
[<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c8e60>] (schedule_timeout+0x14c/0x1e8)
[<c02c8e60>] (schedule_timeout+0x14c/0x1e8) from [<c02c8344>] (io_schedule_timeout+0x34/0x58)
[<c02c8344>] (io_schedule_timeout+0x34/0x58) from [<c007caf0>] (congestion_wait+0x5c/0x80)
[<c007caf0>] (congestion_wait+0x5c/0x80) from [<c0070fb0>] (balance_dirty_pages_ratelimited_nr+0xe8/0x290)
[<c0070fb0>] (balance_dirty_pages_ratelimited_nr+0xe8/0x290) from [<c0069f04>] (generic_file_buffered_write+0x10c/0x348)
[<c0069f04>] (generic_file_buffered_write+0x10c/0x348) from [<c006a64c>] (__generic_file_aio_write_nolock+0x264/0x4f4)
[<c006a64c>] (__generic_file_aio_write_nolock+0x264/0x4f4) from [<c006b3b8>] (generic_file_aio_write+0x74/0xe8)
[<c006b3b8>] (generic_file_aio_write+0x74/0xe8) from [<c0097228>] (do_sync_write+0xbc/0x100)
[<c0097228>] (do_sync_write+0xbc/0x100) from [<c0097d3c>] (vfs_write+0xb0/0x164)
[<c0097d3c>] (vfs_write+0xb0/0x164) from [<c0097ec0>] (sys_write+0x40/0x70)
[<c0097ec0>] (sys_write+0x40/0x70) from [<c0022f00>] (ret_fast_syscall+0x0/0x2c)

nilfs related processes:
[40049.761881] segctord      S c02c8610     0   859      2 0x00000000
[40049.761894] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<bf0154ec>] (nilfs_segctor_thread+0x2d4/0x328 [nilfs2])
[40049.761999] [<bf0154ec>] (nilfs_segctor_thread+0x2d4/0x328 [nilfs2]) from [<c004aac0>] (kthread+0x7c/0x84)
[40049.762081] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kernel_thread_exit+0x0/0x8)
[40049.762101] nilfs_cleaner S c02c8610     0   860      1 0x00000000
[40049.762115] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c99f4>] (do_nanosleep+0xb0/0x110)
[40049.762137] [<c02c99f4>] (do_nanosleep+0xb0/0x110) from [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c)
[40049.762161] [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c) from [<c004eff4>] (sys_nanosleep+0x9c/0xa4)
[40049.762181] [<c004eff4>] (sys_nanosleep+0x9c/0xa4) from [<c0022f00>] (ret_fast_syscall+0x0/0x2c)
[40049.762201] segctord      S c02c8610     0   862      2 0x00000000
[40049.762214] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<bf0154ec>] (nilfs_segctor_thread+0x2d4/0x328 [nilfs2])
[40049.762298] [<bf0154ec>] (nilfs_segctor_thread+0x2d4/0x328 [nilfs2]) from [<c004aac0>] (kthread+0x7c/0x84)
[40049.762377] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kernel_thread_exit+0x0/0x8)
[40049.762397] nilfs_cleaner S c02c8610     0   863      1 0x00000000
[40049.762411] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c99f4>] (do_nanosleep+0xb0/0x110)
[40049.762433] [<c02c99f4>] (do_nanosleep+0xb0/0x110) from [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c)
[40049.762455] [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c) from [<c004eff4>] (sys_nanosleep+0x9c/0xa4)
[40049.762475] [<c004eff4>] (sys_nanosleep+0x9c/0xa4) from [<c0022f00>] (ret_fast_syscall+0x0/0x2c)
[40049.762495] segctord      S c02c8610     0   865      2 0x00000000
[40049.762507] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<bf0154ec>] (nilfs_segctor_thread+0x2d4/0x328 [nilfs2])
[40049.762591] [<bf0154ec>] (nilfs_segctor_thread+0x2d4/0x328 [nilfs2]) from [<c004aac0>] (kthread+0x7c/0x84)
[40049.762670] [<c004aac0>] (kthread+0x7c/0x84) from [<c0023940>] (kernel_thread_exit+0x0/0x8)
[40049.762690] nilfs_cleaner S c02c8610     0   866      1 0x00000000
[40049.762703] [<c02c8610>] (schedule+0x2a8/0x3b0) from [<c02c99f4>] (do_nanosleep+0xb0/0x110)
[40049.762726] [<c02c99f4>] (do_nanosleep+0xb0/0x110) from [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c)
[40049.762748] [<c004eed0>] (hrtimer_nanosleep+0xa4/0x12c) from [<c004eff4>] (sys_nanosleep+0x9c/0xa4)
[40049.762768] [<c004eff4>] (sys_nanosleep+0x9c/0xa4) from [<c0022f00>] (ret_fast_syscall+0x0/0x2c)
