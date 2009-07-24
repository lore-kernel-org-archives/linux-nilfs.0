From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Hang on I/O error
Date: Fri, 24 Jul 2009 21:28:20 +0900 (JST)
Message-ID: <20090724.212820.06960708.ryusuke@osrg.net>
References: <20090724112943.GB7998@lh.kyla.fi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090724112943.GB7998-7bsdmvTMBDzHOG6cAo2yLw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org

Hi,
On Fri, 24 Jul 2009 14:29:43 +0300, Sami Liedes wrote:
> Hi!
> 
> I tried using nilfs on a broken disk just to see what happens. A hang
> happened.
>
> Dmesg output from kernel 2.6.30 attached.
> 
> 	Sami

The patch to fix the hang problem is merged in 2.6.31-rc3, but not yet
backported to 2.6.30.x stable series.

For older kernels, this bugfix is included in nilfs-2.0.15 standalone
package.

Anyway, these reports would be evidence in support of pushing it to
the stable series.

Thank you for the report.

Regards,
Ryusuke Konishi

> ------------------------------------------------------------
> [    0.000000] Linux version 2.6.30 (root@lh) (gcc version 4.3.3 (Debian 4.3.3-10) ) #1 SMP PREEMPT Wed Jun 10 19:23:20 EEST 2009
> [...]
> [989428.629463] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [...]
> [2717640.375419] NILFS: IO error writing segment
> [2717640.375636] NILFS warning (device dm-5): nilfs_clean_segments: segment construction failed. (err=1)
> [2717882.534155] INFO: task ud:5374 blocked for more than 120 seconds.
> [2717882.534159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2717882.534162] ud            D ffff8802201f5d98     0  5374      1
> [2717882.534167]  ffff8802201f5cf8 0000000000000082 ffff8802201f5c58 0000000000000246
> [2717882.534172]  ffff8802201f5c58 0000000000011040 000000000000c8a8 ffff88021ed81690
> [2717882.534176]  ffff8801985343b0 ffff88021ed81a10 00000002201f5cc8 ffffffff8053c52d
> [2717882.534181] Call Trace:
> [2717882.534190]  [<ffffffff8053c52d>] ? dm_table_unplug_all+0x4d/0xb0
> [2717882.534195]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2717882.534199]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2717882.534202]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2717882.534206]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2717882.534209]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2717882.534211]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2717882.534214]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2717882.534218]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2717882.534222]  [<ffffffff802b60f7>] ? pagevec_lookup_tag+0x27/0x40
> [2717882.534225]  [<ffffffff802ad6a6>] wait_on_page_writeback_range+0xc6/0x140
> [2717882.534228]  [<ffffffff802b4474>] ? generic_writepages+0x24/0x30
> [2717882.534231]  [<ffffffff802b44ad>] ? do_writepages+0x2d/0x50
> [2717882.534234]  [<ffffffff802ad7b6>] ? __filemap_fdatawrite_range+0x56/0x60
> [2717882.534237]  [<ffffffff802ad74e>] filemap_fdatawait+0x2e/0x40
> [2717882.534240]  [<ffffffff802ae92d>] filemap_write_and_wait+0x4d/0x60
> [2717882.534244]  [<ffffffff80312120>] sync_blockdev+0x20/0x30
> [2717882.534248]  [<ffffffff80305b8a>] __sync_inodes+0x7a/0xc0
> [2717882.534250]  [<ffffffff80305be7>] sync_inodes+0x17/0x30
> [2717882.534254]  [<ffffffff8030913f>] do_sync+0x1f/0x80
> [2717882.534256]  [<ffffffff803091e3>] sys_sync+0x13/0x20
> [2717882.534260]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2717882.534279] INFO: task nilfs_cleanerd:32262 blocked for more than 120 seconds.
> [2717882.534281] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2717882.534283] nilfs_cleaner D ffff88018426bb58     0 32262      1
> [2717882.534287]  ffff88018426bab8 0000000000000082 ffff880164abcd28 ffff880164abcd28
> [2717882.534292]  ffff88018426ba28 0000000000011040 000000000000c8a8 ffff88000146c3b0
> [2717882.534296]  ffff88022d3e2d20 ffff88000146c730 000000008426ba48 ffffffff805f8e71
> [2717882.534301] Call Trace:
> [2717882.534304]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2717882.534307]  [<ffffffff802b276f>] ? free_hot_cold_page+0x16f/0x2b0
> [2717882.534310]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2717882.534313]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2717882.534316]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2717882.534319]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2717882.534322]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2717882.534325]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2717882.534328]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2717882.534331]  [<ffffffff802b6134>] ? pagevec_lookup+0x24/0x30
> [2717882.534334]  [<ffffffff802b77e6>] truncate_inode_pages_range+0x2d6/0x430
> [2717882.534338]  [<ffffffff802b7955>] truncate_inode_pages+0x15/0x20
> [2717882.534351]  [<ffffffffa0421483>] nilfs_mdt_clear+0x43/0x70 [nilfs2]
> [2717882.534360]  [<ffffffffa0435d66>] nilfs_clear_gcinode+0x16/0x30 [nilfs2]
> [2717882.534368]  [<ffffffffa04311e4>] nilfs_clean_segments+0x194/0x220 [nilfs2]
> [2717882.534372]  [<ffffffff802d0dd1>] ? __vmalloc_node+0xa1/0xb0
> [2717882.534380]  [<ffffffffa0436b0f>] nilfs_ioctl+0x3cf/0x620 [nilfs2]
> [2717882.534384]  [<ffffffff802f3e36>] vfs_ioctl+0x36/0xb0
> [2717882.534387]  [<ffffffff802f3f40>] do_vfs_ioctl+0x90/0x550
> [2717882.534390]  [<ffffffff802f444f>] sys_ioctl+0x4f/0x80
> [2717882.534393]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718002.535153] INFO: task ud:5374 blocked for more than 120 seconds.
> [2718002.535158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718002.535162] ud            D ffff8802201f5d98     0  5374      1
> [2718002.535169]  ffff8802201f5cf8 0000000000000082 ffff8802201f5c58 0000000000000246
> [2718002.535176]  ffff8802201f5c58 0000000000011040 000000000000c8a8 ffff88021ed81690
> [2718002.535183]  ffff8801985343b0 ffff88021ed81a10 00000002201f5cc8 ffffffff8053c52d
> [2718002.535190] Call Trace:
> [2718002.535201]  [<ffffffff8053c52d>] ? dm_table_unplug_all+0x4d/0xb0
> [2718002.535207]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718002.535213]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718002.535217]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718002.535223]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718002.535227]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718002.535231]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718002.535235]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718002.535241]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718002.535246]  [<ffffffff802b60f7>] ? pagevec_lookup_tag+0x27/0x40
> [2718002.535250]  [<ffffffff802ad6a6>] wait_on_page_writeback_range+0xc6/0x140
> [2718002.535255]  [<ffffffff802b4474>] ? generic_writepages+0x24/0x30
> [2718002.535260]  [<ffffffff802b44ad>] ? do_writepages+0x2d/0x50
> [2718002.535264]  [<ffffffff802ad7b6>] ? __filemap_fdatawrite_range+0x56/0x60
> [2718002.535268]  [<ffffffff802ad74e>] filemap_fdatawait+0x2e/0x40
> [2718002.535272]  [<ffffffff802ae92d>] filemap_write_and_wait+0x4d/0x60
> [2718002.535278]  [<ffffffff80312120>] sync_blockdev+0x20/0x30
> [2718002.535283]  [<ffffffff80305b8a>] __sync_inodes+0x7a/0xc0
> [2718002.535287]  [<ffffffff80305be7>] sync_inodes+0x17/0x30
> [2718002.535292]  [<ffffffff8030913f>] do_sync+0x1f/0x80
> [2718002.535296]  [<ffffffff803091e3>] sys_sync+0x13/0x20
> [2718002.535302]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718002.535321] INFO: task nilfs_cleanerd:32262 blocked for more than 120 seconds.
> [2718002.535324] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718002.535327] nilfs_cleaner D ffff88018426bb58     0 32262      1
> [2718002.535334]  ffff88018426bab8 0000000000000082 ffff880164abcd28 ffff880164abcd28
> [2718002.535340]  ffff88018426ba28 0000000000011040 000000000000c8a8 ffff88000146c3b0
> [2718002.535347]  ffff88022d3e2d20 ffff88000146c730 000000008426ba48 ffffffff805f8e71
> [2718002.535354] Call Trace:
> [2718002.535358]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718002.535363]  [<ffffffff802b276f>] ? free_hot_cold_page+0x16f/0x2b0
> [2718002.535368]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718002.535372]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718002.535377]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718002.535381]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718002.535385]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718002.535389]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718002.535394]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718002.535398]  [<ffffffff802b6134>] ? pagevec_lookup+0x24/0x30
> [2718002.535403]  [<ffffffff802b77e6>] truncate_inode_pages_range+0x2d6/0x430
> [2718002.535409]  [<ffffffff802b7955>] truncate_inode_pages+0x15/0x20
> [2718002.535424]  [<ffffffffa0421483>] nilfs_mdt_clear+0x43/0x70 [nilfs2]
> [2718002.535436]  [<ffffffffa0435d66>] nilfs_clear_gcinode+0x16/0x30 [nilfs2]
> [2718002.535449]  [<ffffffffa04311e4>] nilfs_clean_segments+0x194/0x220 [nilfs2]
> [2718002.535454]  [<ffffffff802d0dd1>] ? __vmalloc_node+0xa1/0xb0
> [2718002.535466]  [<ffffffffa0436b0f>] nilfs_ioctl+0x3cf/0x620 [nilfs2]
> [2718002.535472]  [<ffffffff802f3e36>] vfs_ioctl+0x36/0xb0
> [2718002.535476]  [<ffffffff802f3f40>] do_vfs_ioctl+0x90/0x550
> [2718002.535480]  [<ffffffff802f444f>] sys_ioctl+0x4f/0x80
> [2718002.535485]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718122.535149] INFO: task ud:5374 blocked for more than 120 seconds.
> [2718122.535153] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718122.535156] ud            D ffff8802201f5d98     0  5374      1
> [2718122.535161]  ffff8802201f5cf8 0000000000000082 ffff8802201f5c58 0000000000000246
> [2718122.535166]  ffff8802201f5c58 0000000000011040 000000000000c8a8 ffff88021ed81690
> [2718122.535171]  ffff8801985343b0 ffff88021ed81a10 00000002201f5cc8 ffffffff8053c52d
> [2718122.535175] Call Trace:
> [2718122.535184]  [<ffffffff8053c52d>] ? dm_table_unplug_all+0x4d/0xb0
> [2718122.535188]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718122.535192]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718122.535195]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718122.535199]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718122.535202]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718122.535205]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718122.535208]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718122.535212]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718122.535215]  [<ffffffff802b60f7>] ? pagevec_lookup_tag+0x27/0x40
> [2718122.535218]  [<ffffffff802ad6a6>] wait_on_page_writeback_range+0xc6/0x140
> [2718122.535221]  [<ffffffff802b4474>] ? generic_writepages+0x24/0x30
> [2718122.535224]  [<ffffffff802b44ad>] ? do_writepages+0x2d/0x50
> [2718122.535227]  [<ffffffff802ad7b6>] ? __filemap_fdatawrite_range+0x56/0x60
> [2718122.535230]  [<ffffffff802ad74e>] filemap_fdatawait+0x2e/0x40
> [2718122.535233]  [<ffffffff802ae92d>] filemap_write_and_wait+0x4d/0x60
> [2718122.535237]  [<ffffffff80312120>] sync_blockdev+0x20/0x30
> [2718122.535240]  [<ffffffff80305b8a>] __sync_inodes+0x7a/0xc0
> [2718122.535243]  [<ffffffff80305be7>] sync_inodes+0x17/0x30
> [2718122.535246]  [<ffffffff8030913f>] do_sync+0x1f/0x80
> [2718122.535249]  [<ffffffff803091e3>] sys_sync+0x13/0x20
> [2718122.535253]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718122.535270] INFO: task nilfs_cleanerd:32262 blocked for more than 120 seconds.
> [2718122.535272] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718122.535274] nilfs_cleaner D ffff88018426bb58     0 32262      1
> [2718122.535278]  ffff88018426bab8 0000000000000082 ffff880164abcd28 ffff880164abcd28
> [2718122.535283]  ffff88018426ba28 0000000000011040 000000000000c8a8 ffff88000146c3b0
> [2718122.535287]  ffff88022d3e2d20 ffff88000146c730 000000008426ba48 ffffffff805f8e71
> [2718122.535291] Call Trace:
> [2718122.535294]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718122.535298]  [<ffffffff802b276f>] ? free_hot_cold_page+0x16f/0x2b0
> [2718122.535301]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718122.535304]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718122.535307]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718122.535310]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718122.535313]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718122.535316]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718122.535319]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718122.535322]  [<ffffffff802b6134>] ? pagevec_lookup+0x24/0x30
> [2718122.535326]  [<ffffffff802b77e6>] truncate_inode_pages_range+0x2d6/0x430
> [2718122.535329]  [<ffffffff802b7955>] truncate_inode_pages+0x15/0x20
> [2718122.535341]  [<ffffffffa0421483>] nilfs_mdt_clear+0x43/0x70 [nilfs2]
> [2718122.535350]  [<ffffffffa0435d66>] nilfs_clear_gcinode+0x16/0x30 [nilfs2]
> [2718122.535358]  [<ffffffffa04311e4>] nilfs_clean_segments+0x194/0x220 [nilfs2]
> [2718122.535362]  [<ffffffff802d0dd1>] ? __vmalloc_node+0xa1/0xb0
> [2718122.535370]  [<ffffffffa0436b0f>] nilfs_ioctl+0x3cf/0x620 [nilfs2]
> [2718122.535375]  [<ffffffff802f3e36>] vfs_ioctl+0x36/0xb0
> [2718122.535377]  [<ffffffff802f3f40>] do_vfs_ioctl+0x90/0x550
> [2718122.535380]  [<ffffffff802f444f>] sys_ioctl+0x4f/0x80
> [2718122.535384]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718242.536159] INFO: task ud:5374 blocked for more than 120 seconds.
> [2718242.536165] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718242.536169] ud            D ffff8802201f5d98     0  5374      1
> [2718242.536176]  ffff8802201f5cf8 0000000000000082 ffff8802201f5c58 0000000000000246
> [2718242.536184]  ffff8802201f5c58 0000000000011040 000000000000c8a8 ffff88021ed81690
> [2718242.536190]  ffff8801985343b0 ffff88021ed81a10 00000002201f5cc8 ffffffff8053c52d
> [2718242.536197] Call Trace:
> [2718242.536209]  [<ffffffff8053c52d>] ? dm_table_unplug_all+0x4d/0xb0
> [2718242.536215]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718242.536222]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718242.536226]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718242.536232]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718242.536236]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718242.536240]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718242.536245]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718242.536250]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718242.536256]  [<ffffffff802b60f7>] ? pagevec_lookup_tag+0x27/0x40
> [2718242.536260]  [<ffffffff802ad6a6>] wait_on_page_writeback_range+0xc6/0x140
> [2718242.536265]  [<ffffffff802b4474>] ? generic_writepages+0x24/0x30
> [2718242.536269]  [<ffffffff802b44ad>] ? do_writepages+0x2d/0x50
> [2718242.536273]  [<ffffffff802ad7b6>] ? __filemap_fdatawrite_range+0x56/0x60
> [2718242.536278]  [<ffffffff802ad74e>] filemap_fdatawait+0x2e/0x40
> [2718242.536282]  [<ffffffff802ae92d>] filemap_write_and_wait+0x4d/0x60
> [2718242.536288]  [<ffffffff80312120>] sync_blockdev+0x20/0x30
> [2718242.536293]  [<ffffffff80305b8a>] __sync_inodes+0x7a/0xc0
> [2718242.536297]  [<ffffffff80305be7>] sync_inodes+0x17/0x30
> [2718242.536302]  [<ffffffff8030913f>] do_sync+0x1f/0x80
> [2718242.536306]  [<ffffffff803091e3>] sys_sync+0x13/0x20
> [2718242.536312]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718242.536335] INFO: task nilfs_cleanerd:32262 blocked for more than 120 seconds.
> [2718242.536338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718242.536341] nilfs_cleaner D ffff88018426bb58     0 32262      1
> [2718242.536347]  ffff88018426bab8 0000000000000082 ffff880164abcd28 ffff880164abcd28
> [2718242.536354]  ffff88018426ba28 0000000000011040 000000000000c8a8 ffff88000146c3b0
> [2718242.536361]  ffff88022d3e2d20 ffff88000146c730 000000008426ba48 ffffffff805f8e71
> [2718242.536367] Call Trace:
> [2718242.536372]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718242.536377]  [<ffffffff802b276f>] ? free_hot_cold_page+0x16f/0x2b0
> [2718242.536382]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718242.536386]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718242.536390]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718242.536395]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718242.536399]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718242.536403]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718242.536407]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718242.536412]  [<ffffffff802b6134>] ? pagevec_lookup+0x24/0x30
> [2718242.536417]  [<ffffffff802b77e6>] truncate_inode_pages_range+0x2d6/0x430
> [2718242.536423]  [<ffffffff802b7955>] truncate_inode_pages+0x15/0x20
> [2718242.536440]  [<ffffffffa0421483>] nilfs_mdt_clear+0x43/0x70 [nilfs2]
> [2718242.536453]  [<ffffffffa0435d66>] nilfs_clear_gcinode+0x16/0x30 [nilfs2]
> [2718242.536465]  [<ffffffffa04311e4>] nilfs_clean_segments+0x194/0x220 [nilfs2]
> [2718242.536471]  [<ffffffff802d0dd1>] ? __vmalloc_node+0xa1/0xb0
> [2718242.536483]  [<ffffffffa0436b0f>] nilfs_ioctl+0x3cf/0x620 [nilfs2]
> [2718242.536489]  [<ffffffff802f3e36>] vfs_ioctl+0x36/0xb0
> [2718242.536493]  [<ffffffff802f3f40>] do_vfs_ioctl+0x90/0x550
> [2718242.536497]  [<ffffffff802f444f>] sys_ioctl+0x4f/0x80
> [2718242.536502]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718362.536150] INFO: task ud:5374 blocked for more than 120 seconds.
> [2718362.536154] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718362.536157] ud            D ffff8802201f5d98     0  5374      1
> [2718362.536162]  ffff8802201f5cf8 0000000000000082 ffff8802201f5c58 0000000000000246
> [2718362.536167]  ffff8802201f5c58 0000000000011040 000000000000c8a8 ffff88021ed81690
> [2718362.536172]  ffff8801985343b0 ffff88021ed81a10 00000002201f5cc8 ffffffff8053c52d
> [2718362.536176] Call Trace:
> [2718362.536185]  [<ffffffff8053c52d>] ? dm_table_unplug_all+0x4d/0xb0
> [2718362.536190]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718362.536194]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718362.536197]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718362.536201]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718362.536204]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718362.536206]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718362.536209]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718362.536213]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718362.536217]  [<ffffffff802b60f7>] ? pagevec_lookup_tag+0x27/0x40
> [2718362.536220]  [<ffffffff802ad6a6>] wait_on_page_writeback_range+0xc6/0x140
> [2718362.536223]  [<ffffffff802b4474>] ? generic_writepages+0x24/0x30
> [2718362.536226]  [<ffffffff802b44ad>] ? do_writepages+0x2d/0x50
> [2718362.536229]  [<ffffffff802ad7b6>] ? __filemap_fdatawrite_range+0x56/0x60
> [2718362.536232]  [<ffffffff802ad74e>] filemap_fdatawait+0x2e/0x40
> [2718362.536234]  [<ffffffff802ae92d>] filemap_write_and_wait+0x4d/0x60
> [2718362.536239]  [<ffffffff80312120>] sync_blockdev+0x20/0x30
> [2718362.536242]  [<ffffffff80305b8a>] __sync_inodes+0x7a/0xc0
> [2718362.536245]  [<ffffffff80305be7>] sync_inodes+0x17/0x30
> [2718362.536248]  [<ffffffff8030913f>] do_sync+0x1f/0x80
> [2718362.536251]  [<ffffffff803091e3>] sys_sync+0x13/0x20
> [2718362.536255]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> [2718362.536274] INFO: task nilfs_cleanerd:32262 blocked for more than 120 seconds.
> [2718362.536276] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2718362.536278] nilfs_cleaner D ffff88018426bb58     0 32262      1
> [2718362.536282]  ffff88018426bab8 0000000000000082 ffff880164abcd28 ffff880164abcd28
> [2718362.536286]  ffff88018426ba28 0000000000011040 000000000000c8a8 ffff88000146c3b0
> [2718362.536291]  ffff88022d3e2d20 ffff88000146c730 000000008426ba48 ffffffff805f8e71
> [2718362.536295] Call Trace:
> [2718362.536298]  [<ffffffff805f8e71>] ? sub_preempt_count+0x51/0x60
> [2718362.536301]  [<ffffffff802b276f>] ? free_hot_cold_page+0x16f/0x2b0
> [2718362.536305]  [<ffffffff805f3708>] schedule+0x18/0x40
> [2718362.536307]  [<ffffffff805f3798>] io_schedule+0x68/0xb0
> [2718362.536310]  [<ffffffff802ac88d>] sync_page+0x3d/0x70
> [2718362.536313]  [<ffffffff805f3cd2>] __wait_on_bit+0x62/0x90
> [2718362.536316]  [<ffffffff802ac850>] ? sync_page+0x0/0x70
> [2718362.536319]  [<ffffffff802acaf4>] wait_on_page_bit+0x74/0x80
> [2718362.536322]  [<ffffffff8025fe30>] ? wake_bit_function+0x0/0x50
> [2718362.536325]  [<ffffffff802b6134>] ? pagevec_lookup+0x24/0x30
> [2718362.536328]  [<ffffffff802b77e6>] truncate_inode_pages_range+0x2d6/0x430
> [2718362.536332]  [<ffffffff802b7955>] truncate_inode_pages+0x15/0x20
> [2718362.536344]  [<ffffffffa0421483>] nilfs_mdt_clear+0x43/0x70 [nilfs2]
> [2718362.536352]  [<ffffffffa0435d66>] nilfs_clear_gcinode+0x16/0x30 [nilfs2]
> [2718362.536360]  [<ffffffffa04311e4>] nilfs_clean_segments+0x194/0x220 [nilfs2]
> [2718362.536364]  [<ffffffff802d0dd1>] ? __vmalloc_node+0xa1/0xb0
> [2718362.536372]  [<ffffffffa0436b0f>] nilfs_ioctl+0x3cf/0x620 [nilfs2]
> [2718362.536376]  [<ffffffff802f3e36>] vfs_ioctl+0x36/0xb0
> [2718362.536379]  [<ffffffff802f3f40>] do_vfs_ioctl+0x90/0x550
> [2718362.536382]  [<ffffffff802f444f>] sys_ioctl+0x4f/0x80
> [2718362.536385]  [<ffffffff8020c11b>] system_call_fastpath+0x16/0x1b
> ------------------------------------------------------------
