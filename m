From: Andreas Beckmann <debian-qVUaBahCJu5n68oJJulU0Q@public.gmane.org>
Subject: nilfs_sufile_do_cancel_free: segment 0 must be clean
Date: Sat, 20 Mar 2010 23:04:39 +0100
Message-ID: <4BA54677.3090902@abeckmann.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080608070600030201050708"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------080608070600030201050708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

I just tried to benchmark nilfs and then the file system and benchmark
process got stuck. dmesg output is attached. The problems start with

nilfs_sufile_do_cancel_free: segment 0 must be clean
nilfs_sufile_do_cancel_free: segment 1 must be clean
NILFS warning (device sdb1): nilfs_clean_segments: segment construction
failed. (err=-28)

I'm using

Kernel 2.6.33 (Debian 2.6.33-1~experimental.2)
nilfs-tools 2.0.16 (Debian 2.0.16-1)

The processes are unkillable and the file system cannot be unmounted.
The machine will be reset when I get back in physical range on Wednesday
and the stuck file system will be removed. If there is anything I can do
remotely to help you debug that problem before the file system is gone,
let me know.

The file system got into this state after writing several times the
capacity of the file system, creating a single file until the file
cannot be extended any more.

# df -k /dev/sdb1
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1            136716284 136372220         0 100% /stxxl/sdb

Can't do a ls on the file systen, gets stuck as well.


Please keep me CCed, I'm not on the list.


Andreas

--------------080608070600030201050708
Content-Type: text/x-log;
 name="nilfs-lockup.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nilfs-lockup.log"

Mar 19 00:19:51 chili mount.nilfs2: WARNING! - The NILFS on-disk format may change at any time.
Mar 19 00:19:51 chili mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesystem.
Mar 19 00:19:51 chili kernel: [1484185.421051] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
Mar 19 01:22:19 chili kernel: [1487933.433420] nilfs_sufile_do_cancel_free: segment 0 must be clean
Mar 19 01:22:19 chili kernel: [1487933.439666] nilfs_sufile_do_cancel_free: segment 1 must be clean
Mar 19 01:22:19 chili kernel: [1487933.446146] NILFS warning (device sdb1): nilfs_clean_segments: segment construction failed. (err=-28)
Mar 19 01:22:25 chili kernel: [1487939.247754] nilfs_sufile_do_cancel_free: segment 0 must be clean
Mar 19 01:22:25 chili kernel: [1487939.254014] nilfs_sufile_do_cancel_free: segment 1 must be clean
Mar 19 01:22:25 chili kernel: [1487939.260261] NILFS warning (device sdb1): nilfs_clean_segments: segment construction failed. (err=-28)
Mar 19 01:22:31 chili kernel: [1487945.062508] nilfs_sufile_do_cancel_free: segment 0 must be clean
Mar 19 01:22:31 chili kernel: [1487945.068713] nilfs_sufile_do_cancel_free: segment 1 must be clean
Mar 19 01:22:31 chili kernel: [1487945.074973] NILFS warning (device sdb1): nilfs_clean_segments: segment construction failed. (err=-28)
Mar 19 01:22:37 chili kernel: [1487950.879316] nilfs_sufile_do_cancel_free: segment 0 must be clean
Mar 19 01:22:37 chili kernel: [1487950.885554] nilfs_sufile_do_cancel_free: segment 1 must be clean
Mar 19 01:22:37 chili kernel: [1487950.891797] NILFS warning (device sdb1): nilfs_clean_segments: segment construction failed. (err=-28)
Mar 19 01:25:27 chili kernel: [1488121.532503] nilfs_cleaner D ffff880008e15680     0 31278      1 0x00000008
Mar 19 01:25:27 chili kernel: [1488121.539603]  ffff88021c43f700 0000000000000086 ffff8801e9d99a98 ffff8801e9d99a94
Mar 19 01:25:27 chili kernel: [1488121.547263]  0000000000000002 000000000000f8e0 ffff8801e9d99fd8 0000000000015680
Mar 19 01:25:27 chili kernel: [1488121.554923]  0000000000015680 ffff88021c43f000 ffff88021c43f2f0 0000000000000000
Mar 19 01:25:27 chili kernel: [1488121.562591] Call Trace:
Mar 19 01:25:27 chili kernel: [1488121.565229]  [<ffffffff810b4303>] ? __pagevec_free+0x69/0x7f
Mar 19 01:25:27 chili kernel: [1488121.571092]  [<ffffffff810af27e>] ? sync_page+0x0/0x45
Mar 19 01:25:27 chili kernel: [1488121.576420]  [<ffffffff812eceeb>] ? io_schedule+0x73/0xb7
Mar 19 01:25:27 chili kernel: [1488121.582017]  [<ffffffff810af2bf>] ? sync_page+0x41/0x45
Mar 19 01:25:27 chili kernel: [1488121.587430]  [<ffffffff812ed416>] ? __wait_on_bit+0x41/0x70
Mar 19 01:25:27 chili kernel: [1488121.593199]  [<ffffffff810af442>] ? wait_on_page_bit+0x6b/0x71
Mar 19 01:25:27 chili kernel: [1488121.599223]  [<ffffffff8105f2fc>] ? wake_bit_function+0x0/0x23
Mar 19 01:25:27 chili kernel: [1488121.605253]  [<ffffffff810b78da>] ? lock_page+0x9/0x1f
Mar 19 01:25:27 chili kernel: [1488121.610579]  [<ffffffff810b8024>] ? truncate_inode_pages_range+0x257/0x2b0
Mar 19 01:25:27 chili kernel: [1488121.617655]  [<ffffffffa0759dff>] ? nilfs_mdt_destroy+0x41/0x80 [nilfs2]
Mar 19 01:25:27 chili kernel: [1488121.624544]  [<ffffffffa076616b>] ? nilfs_clean_segments+0x18a/0x23b [nilfs2]
Mar 19 01:25:27 chili kernel: [1488121.631890]  [<ffffffffa076ab00>] ? nilfs_ioctl+0x7dd/0x899 [nilfs2]
Mar 19 01:25:27 chili kernel: [1488121.638438]  [<ffffffff810f580f>] ? vfs_ioctl+0x21/0x92
Mar 19 01:25:27 chili kernel: [1488121.643857]  [<ffffffff810f5d7a>] ? do_vfs_ioctl+0x484/0x4d3
Mar 19 01:25:27 chili kernel: [1488121.649710]  [<ffffffff8102ca9e>] ? do_page_fault+0x266/0x282
Mar 19 01:25:27 chili kernel: [1488121.655651]  [<ffffffff810f5e1a>] ? sys_ioctl+0x51/0x70
Mar 19 01:25:27 chili kernel: [1488121.661074]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:25:27 chili kernel: [1488121.687367] benchmark_dis D ffff880008f15680     0  4677   4616 0x00000000
Mar 19 01:25:27 chili kernel: [1488121.694449]  ffff88016a7c2a00 0000000000000082 0000000000000000 ffffea000482cc88
Mar 19 01:25:27 chili kernel: [1488121.702113]  ffff88021f050300 000000000000f8e0 ffff88014b243fd8 0000000000015680
Mar 19 01:25:27 chili kernel: [1488121.709770]  0000000000015680 ffff88016a7c5b00 ffff88016a7c5df0 0000000200000030
Mar 19 01:25:27 chili kernel: [1488121.717432] Call Trace:
Mar 19 01:25:27 chili kernel: [1488121.720060]  [<ffffffff812ee158>] ? __down_read+0xa4/0xd1
Mar 19 01:25:27 chili kernel: [1488121.725665]  [<ffffffffa07666fc>] ? nilfs_transaction_begin+0xca/0x127 [nilfs2]
Mar 19 01:25:28 chili kernel: [1488121.733173]  [<ffffffffa0758b77>] ? nilfs_create+0x26/0xa4 [nilfs2]
Mar 19 01:25:28 chili kernel: [1488121.739636]  [<ffffffff810f1143>] ? generic_permission+0xe/0x8a
Mar 19 01:25:28 chili kernel: [1488121.745747]  [<ffffffff810f2c09>] ? vfs_create+0x6d/0x89
Mar 19 01:25:28 chili kernel: [1488121.751254]  [<ffffffff810f3958>] ? do_filp_open+0x354/0xa08
Mar 19 01:25:28 chili kernel: [1488121.757099]  [<ffffffff810e8277>] ? do_sys_open+0x55/0xfc
Mar 19 01:25:28 chili kernel: [1488121.762694]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:27:28 chili kernel: [1488241.784514] nilfs_cleaner D ffff880008e15680     0 31278      1 0x00000008
Mar 19 01:27:28 chili kernel: [1488241.791630]  ffff88021c43f700 0000000000000086 ffff8801e9d99a98 ffff8801e9d99a94
Mar 19 01:27:28 chili kernel: [1488241.799339]  0000000000000002 000000000000f8e0 ffff8801e9d99fd8 0000000000015680
Mar 19 01:27:28 chili kernel: [1488241.807050]  0000000000015680 ffff88021c43f000 ffff88021c43f2f0 0000000000000000
Mar 19 01:27:28 chili kernel: [1488241.814764] Call Trace:
Mar 19 01:27:28 chili kernel: [1488241.817424]  [<ffffffff810b4303>] ? __pagevec_free+0x69/0x7f
Mar 19 01:27:28 chili kernel: [1488241.823282]  [<ffffffff810af27e>] ? sync_page+0x0/0x45
Mar 19 01:27:28 chili kernel: [1488241.828608]  [<ffffffff812eceeb>] ? io_schedule+0x73/0xb7
Mar 19 01:27:28 chili kernel: [1488241.834205]  [<ffffffff810af2bf>] ? sync_page+0x41/0x45
Mar 19 01:27:28 chili kernel: [1488241.839616]  [<ffffffff812ed416>] ? __wait_on_bit+0x41/0x70
Mar 19 01:27:28 chili kernel: [1488241.845386]  [<ffffffff810af442>] ? wait_on_page_bit+0x6b/0x71
Mar 19 01:27:28 chili kernel: [1488241.851407]  [<ffffffff8105f2fc>] ? wake_bit_function+0x0/0x23
Mar 19 01:27:28 chili kernel: [1488241.857434]  [<ffffffff810b78da>] ? lock_page+0x9/0x1f
Mar 19 01:27:28 chili kernel: [1488241.862763]  [<ffffffff810b8024>] ? truncate_inode_pages_range+0x257/0x2b0
Mar 19 01:27:28 chili kernel: [1488241.869824]  [<ffffffffa0759dff>] ? nilfs_mdt_destroy+0x41/0x80 [nilfs2]
Mar 19 01:27:28 chili kernel: [1488241.876728]  [<ffffffffa076616b>] ? nilfs_clean_segments+0x18a/0x23b [nilfs2]
Mar 19 01:27:28 chili kernel: [1488241.884083]  [<ffffffffa076ab00>] ? nilfs_ioctl+0x7dd/0x899 [nilfs2]
Mar 19 01:27:28 chili kernel: [1488241.890638]  [<ffffffff810f580f>] ? vfs_ioctl+0x21/0x92
Mar 19 01:27:28 chili kernel: [1488241.896055]  [<ffffffff810f5d7a>] ? do_vfs_ioctl+0x484/0x4d3
Mar 19 01:27:28 chili kernel: [1488241.901920]  [<ffffffff8102ca9e>] ? do_page_fault+0x266/0x282
Mar 19 01:27:28 chili kernel: [1488241.907853]  [<ffffffff810f5e1a>] ? sys_ioctl+0x51/0x70
Mar 19 01:27:28 chili kernel: [1488241.913271]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:27:28 chili kernel: [1488241.935115] benchmark_dis D ffff880008f15680     0  4677   4616 0x00000000
Mar 19 01:27:28 chili kernel: [1488241.942211]  ffff88016a7c2a00 0000000000000082 0000000000000000 ffffea000482cc88
Mar 19 01:27:28 chili kernel: [1488241.949861]  ffff88021f050300 000000000000f8e0 ffff88014b243fd8 0000000000015680
Mar 19 01:27:28 chili kernel: [1488241.957533]  0000000000015680 ffff88016a7c5b00 ffff88016a7c5df0 0000000200000030
Mar 19 01:27:28 chili kernel: [1488241.965207] Call Trace:
Mar 19 01:27:28 chili kernel: [1488241.967834]  [<ffffffff812ee158>] ? __down_read+0xa4/0xd1
Mar 19 01:27:28 chili kernel: [1488241.973428]  [<ffffffffa07666fc>] ? nilfs_transaction_begin+0xca/0x127 [nilfs2]
Mar 19 01:27:28 chili kernel: [1488241.980946]  [<ffffffffa0758b77>] ? nilfs_create+0x26/0xa4 [nilfs2]
Mar 19 01:27:28 chili kernel: [1488241.987402]  [<ffffffff810f1143>] ? generic_permission+0xe/0x8a
Mar 19 01:27:28 chili kernel: [1488241.993512]  [<ffffffff810f2c09>] ? vfs_create+0x6d/0x89
Mar 19 01:27:28 chili kernel: [1488241.999034]  [<ffffffff810f3958>] ? do_filp_open+0x354/0xa08
Mar 19 01:27:28 chili kernel: [1488242.004882]  [<ffffffff810e8277>] ? do_sys_open+0x55/0xfc
Mar 19 01:27:28 chili kernel: [1488242.010478]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:29:28 chili kernel: [1488362.032508] nilfs_cleaner D ffff880008e15680     0 31278      1 0x00000008
Mar 19 01:29:28 chili kernel: [1488362.039625]  ffff88021c43f700 0000000000000086 ffff8801e9d99a98 ffff8801e9d99a94
Mar 19 01:29:28 chili kernel: [1488362.047327]  0000000000000002 000000000000f8e0 ffff8801e9d99fd8 0000000000015680
Mar 19 01:29:28 chili kernel: [1488362.055029]  0000000000015680 ffff88021c43f000 ffff88021c43f2f0 0000000000000000
Mar 19 01:29:28 chili kernel: [1488362.062739] Call Trace:
Mar 19 01:29:28 chili kernel: [1488362.065385]  [<ffffffff810b4303>] ? __pagevec_free+0x69/0x7f
Mar 19 01:29:28 chili kernel: [1488362.071247]  [<ffffffff810af27e>] ? sync_page+0x0/0x45
Mar 19 01:29:28 chili kernel: [1488362.076575]  [<ffffffff812eceeb>] ? io_schedule+0x73/0xb7
Mar 19 01:29:28 chili kernel: [1488362.082169]  [<ffffffff810af2bf>] ? sync_page+0x41/0x45
Mar 19 01:29:28 chili kernel: [1488362.087578]  [<ffffffff812ed416>] ? __wait_on_bit+0x41/0x70
Mar 19 01:29:28 chili kernel: [1488362.093347]  [<ffffffff810af442>] ? wait_on_page_bit+0x6b/0x71
Mar 19 01:29:28 chili kernel: [1488362.099367]  [<ffffffff8105f2fc>] ? wake_bit_function+0x0/0x23
Mar 19 01:29:28 chili kernel: [1488362.105395]  [<ffffffff810b78da>] ? lock_page+0x9/0x1f
Mar 19 01:29:28 chili kernel: [1488362.110723]  [<ffffffff810b8024>] ? truncate_inode_pages_range+0x257/0x2b0
Mar 19 01:29:28 chili kernel: [1488362.117798]  [<ffffffffa0759dff>] ? nilfs_mdt_destroy+0x41/0x80 [nilfs2]
Mar 19 01:29:28 chili kernel: [1488362.124686]  [<ffffffffa076616b>] ? nilfs_clean_segments+0x18a/0x23b [nilfs2]
Mar 19 01:29:28 chili kernel: [1488362.132035]  [<ffffffffa076ab00>] ? nilfs_ioctl+0x7dd/0x899 [nilfs2]
Mar 19 01:29:28 chili kernel: [1488362.138581]  [<ffffffff810f580f>] ? vfs_ioctl+0x21/0x92
Mar 19 01:29:28 chili kernel: [1488362.144005]  [<ffffffff810f5d7a>] ? do_vfs_ioctl+0x484/0x4d3
Mar 19 01:29:28 chili kernel: [1488362.149856]  [<ffffffff8102ca9e>] ? do_page_fault+0x266/0x282
Mar 19 01:29:28 chili kernel: [1488362.155798]  [<ffffffff810f5e1a>] ? sys_ioctl+0x51/0x70
Mar 19 01:29:28 chili kernel: [1488362.161214]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:29:28 chili kernel: [1488362.183045] benchmark_dis D ffff880008f15680     0  4677   4616 0x00000000
Mar 19 01:29:28 chili kernel: [1488362.190131]  ffff88016a7c2a00 0000000000000082 0000000000000000 ffffea000482cc88
Mar 19 01:29:28 chili kernel: [1488362.197789]  ffff88021f050300 000000000000f8e0 ffff88014b243fd8 0000000000015680
Mar 19 01:29:28 chili kernel: [1488362.205442]  0000000000015680 ffff88016a7c5b00 ffff88016a7c5df0 0000000200000030
Mar 19 01:29:28 chili kernel: [1488362.213102] Call Trace:
Mar 19 01:29:28 chili kernel: [1488362.215728]  [<ffffffff812ee158>] ? __down_read+0xa4/0xd1
Mar 19 01:29:28 chili kernel: [1488362.221328]  [<ffffffffa07666fc>] ? nilfs_transaction_begin+0xca/0x127 [nilfs2]
Mar 19 01:29:28 chili kernel: [1488362.228837]  [<ffffffffa0758b77>] ? nilfs_create+0x26/0xa4 [nilfs2]
Mar 19 01:29:28 chili kernel: [1488362.235297]  [<ffffffff810f1143>] ? generic_permission+0xe/0x8a
Mar 19 01:29:28 chili kernel: [1488362.241404]  [<ffffffff810f2c09>] ? vfs_create+0x6d/0x89
Mar 19 01:29:28 chili kernel: [1488362.246911]  [<ffffffff810f3958>] ? do_filp_open+0x354/0xa08
Mar 19 01:29:28 chili kernel: [1488362.252761]  [<ffffffff810e8277>] ? do_sys_open+0x55/0xfc
Mar 19 01:29:28 chili kernel: [1488362.258359]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:31:28 chili kernel: [1488482.280508] nilfs_cleaner D ffff880008e15680     0 31278      1 0x00000008
Mar 19 01:31:28 chili kernel: [1488482.287630]  ffff88021c43f700 0000000000000086 ffff8801e9d99a98 ffff8801e9d99a94
Mar 19 01:31:28 chili kernel: [1488482.295333]  0000000000000002 000000000000f8e0 ffff8801e9d99fd8 0000000000015680
Mar 19 01:31:28 chili kernel: [1488482.303038]  0000000000015680 ffff88021c43f000 ffff88021c43f2f0 0000000000000000
Mar 19 01:31:28 chili kernel: [1488482.310744] Call Trace:
Mar 19 01:31:28 chili kernel: [1488482.313396]  [<ffffffff810b4303>] ? __pagevec_free+0x69/0x7f
Mar 19 01:31:28 chili kernel: [1488482.319259]  [<ffffffff810af27e>] ? sync_page+0x0/0x45
Mar 19 01:31:28 chili kernel: [1488482.324602]  [<ffffffff812eceeb>] ? io_schedule+0x73/0xb7
Mar 19 01:31:28 chili kernel: [1488482.330199]  [<ffffffff810af2bf>] ? sync_page+0x41/0x45
Mar 19 01:31:28 chili kernel: [1488482.335633]  [<ffffffff812ed416>] ? __wait_on_bit+0x41/0x70
Mar 19 01:31:28 chili kernel: [1488482.341405]  [<ffffffff810af442>] ? wait_on_page_bit+0x6b/0x71
Mar 19 01:31:28 chili kernel: [1488482.347438]  [<ffffffff8105f2fc>] ? wake_bit_function+0x0/0x23
Mar 19 01:31:28 chili kernel: [1488482.353463]  [<ffffffff810b78da>] ? lock_page+0x9/0x1f
Mar 19 01:31:28 chili kernel: [1488482.358797]  [<ffffffff810b8024>] ? truncate_inode_pages_range+0x257/0x2b0
Mar 19 01:31:28 chili kernel: [1488482.365868]  [<ffffffffa0759dff>] ? nilfs_mdt_destroy+0x41/0x80 [nilfs2]
Mar 19 01:31:28 chili kernel: [1488482.372770]  [<ffffffffa076616b>] ? nilfs_clean_segments+0x18a/0x23b [nilfs2]
Mar 19 01:31:28 chili kernel: [1488482.380114]  [<ffffffffa076ab00>] ? nilfs_ioctl+0x7dd/0x899 [nilfs2]
Mar 19 01:31:28 chili kernel: [1488482.386662]  [<ffffffff810f580f>] ? vfs_ioctl+0x21/0x92
Mar 19 01:31:28 chili kernel: [1488482.392085]  [<ffffffff810f5d7a>] ? do_vfs_ioctl+0x484/0x4d3
Mar 19 01:31:28 chili kernel: [1488482.397939]  [<ffffffff8102ca9e>] ? do_page_fault+0x266/0x282
Mar 19 01:31:28 chili kernel: [1488482.403883]  [<ffffffff810f5e1a>] ? sys_ioctl+0x51/0x70
Mar 19 01:31:28 chili kernel: [1488482.409311]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:31:28 chili kernel: [1488482.431130] benchmark_dis D ffff880008f15680     0  4677   4616 0x00000000
Mar 19 01:31:28 chili kernel: [1488482.438229]  ffff88016a7c2a00 0000000000000082 0000000000000000 ffffea000482cc88
Mar 19 01:31:28 chili kernel: [1488482.445884]  ffff88021f050300 000000000000f8e0 ffff88014b243fd8 0000000000015680
Mar 19 01:31:28 chili kernel: [1488482.453540]  0000000000015680 ffff88016a7c5b00 ffff88016a7c5df0 0000000200000030
Mar 19 01:31:28 chili kernel: [1488482.461197] Call Trace:
Mar 19 01:31:28 chili kernel: [1488482.463827]  [<ffffffff812ee158>] ? __down_read+0xa4/0xd1
Mar 19 01:31:28 chili kernel: [1488482.469428]  [<ffffffffa07666fc>] ? nilfs_transaction_begin+0xca/0x127 [nilfs2]
Mar 19 01:31:28 chili kernel: [1488482.476937]  [<ffffffffa0758b77>] ? nilfs_create+0x26/0xa4 [nilfs2]
Mar 19 01:31:28 chili kernel: [1488482.483397]  [<ffffffff810f1143>] ? generic_permission+0xe/0x8a
Mar 19 01:31:28 chili kernel: [1488482.489505]  [<ffffffff810f2c09>] ? vfs_create+0x6d/0x89
Mar 19 01:31:28 chili kernel: [1488482.495014]  [<ffffffff810f3958>] ? do_filp_open+0x354/0xa08
Mar 19 01:31:28 chili kernel: [1488482.500861]  [<ffffffff810e8277>] ? do_sys_open+0x55/0xfc
Mar 19 01:31:28 chili kernel: [1488482.506458]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:33:28 chili kernel: [1488602.540609] nilfs_cleaner D ffff880008e15680     0 31278      1 0x00000008
Mar 19 01:33:28 chili kernel: [1488602.547693]  ffff88021c43f700 0000000000000086 ffff8801e9d99a98 ffff8801e9d99a94
Mar 19 01:33:28 chili kernel: [1488602.559904]  0000000000000002 000000000000f8e0 ffff8801e9d99fd8 0000000000015680
Mar 19 01:33:28 chili kernel: [1488602.567544]  0000000000015680 ffff88021c43f000 ffff88021c43f2f0 0000000000000000
Mar 19 01:33:28 chili kernel: [1488602.575203] Call Trace:
Mar 19 01:33:28 chili kernel: [1488602.577848]  [<ffffffff810b4303>] ? __pagevec_free+0x69/0x7f
Mar 19 01:33:28 chili kernel: [1488602.583694]  [<ffffffff810af27e>] ? sync_page+0x0/0x45
Mar 19 01:33:28 chili kernel: [1488602.589018]  [<ffffffff812eceeb>] ? io_schedule+0x73/0xb7
Mar 19 01:33:28 chili kernel: [1488602.594602]  [<ffffffff810af2bf>] ? sync_page+0x41/0x45
Mar 19 01:33:28 chili kernel: [1488602.600010]  [<ffffffff812ed416>] ? __wait_on_bit+0x41/0x70
Mar 19 01:33:28 chili kernel: [1488602.605765]  [<ffffffff810af442>] ? wait_on_page_bit+0x6b/0x71
Mar 19 01:33:28 chili kernel: [1488602.611798]  [<ffffffff8105f2fc>] ? wake_bit_function+0x0/0x23
Mar 19 01:33:28 chili kernel: [1488602.617826]  [<ffffffff810b78da>] ? lock_page+0x9/0x1f
Mar 19 01:33:28 chili kernel: [1488602.623163]  [<ffffffff810b8024>] ? truncate_inode_pages_range+0x257/0x2b0
Mar 19 01:33:28 chili kernel: [1488602.630224]  [<ffffffffa0759dff>] ? nilfs_mdt_destroy+0x41/0x80 [nilfs2]
Mar 19 01:33:28 chili kernel: [1488602.637123]  [<ffffffffa076616b>] ? nilfs_clean_segments+0x18a/0x23b [nilfs2]
Mar 19 01:33:28 chili kernel: [1488602.644461]  [<ffffffffa076ab00>] ? nilfs_ioctl+0x7dd/0x899 [nilfs2]
Mar 19 01:33:28 chili kernel: [1488602.651012]  [<ffffffff810f580f>] ? vfs_ioctl+0x21/0x92
Mar 19 01:33:28 chili kernel: [1488602.656419]  [<ffffffff810f5d7a>] ? do_vfs_ioctl+0x484/0x4d3
Mar 19 01:33:28 chili kernel: [1488602.662269]  [<ffffffff8102ca9e>] ? do_page_fault+0x266/0x282
Mar 19 01:33:28 chili kernel: [1488602.668200]  [<ffffffff810f5e1a>] ? sys_ioctl+0x51/0x70
Mar 19 01:33:28 chili kernel: [1488602.673624]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b
Mar 19 01:33:28 chili kernel: [1488602.695436] benchmark_dis D ffff880008f15680     0  4677   4616 0x00000000
Mar 19 01:33:28 chili kernel: [1488602.702514]  ffff88016a7c2a00 0000000000000082 0000000000000000 ffffea000482cc88
Mar 19 01:33:28 chili kernel: [1488602.710154]  ffff88021f050300 000000000000f8e0 ffff88014b243fd8 0000000000015680
Mar 19 01:33:28 chili kernel: [1488602.717797]  0000000000015680 ffff88016a7c5b00 ffff88016a7c5df0 0000000200000030
Mar 19 01:33:29 chili kernel: [1488602.725433] Call Trace:
Mar 19 01:33:29 chili kernel: [1488602.728060]  [<ffffffff812ee158>] ? __down_read+0xa4/0xd1
Mar 19 01:33:29 chili kernel: [1488602.733651]  [<ffffffffa07666fc>] ? nilfs_transaction_begin+0xca/0x127 [nilfs2]
Mar 19 01:33:29 chili kernel: [1488602.741158]  [<ffffffffa0758b77>] ? nilfs_create+0x26/0xa4 [nilfs2]
Mar 19 01:33:29 chili kernel: [1488602.747634]  [<ffffffff810f1143>] ? generic_permission+0xe/0x8a
Mar 19 01:33:29 chili kernel: [1488602.753747]  [<ffffffff810f2c09>] ? vfs_create+0x6d/0x89
Mar 19 01:33:29 chili kernel: [1488602.759242]  [<ffffffff810f3958>] ? do_filp_open+0x354/0xa08
Mar 19 01:33:29 chili kernel: [1488602.765085]  [<ffffffff810e8277>] ? do_sys_open+0x55/0xfc
Mar 19 01:33:29 chili kernel: [1488602.770675]  [<ffffffff81008ac2>] ? system_call_fastpath+0x16/0x1b

--------------080608070600030201050708--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
