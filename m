From: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Subject: Filesystem error causes nilfs_btree_do_lookup to trigger cpu soft
 lockup
Date: Wed, 13 Nov 2013 19:44:21 -0500
Message-ID: <52841CE5.6030009@intellitree.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, using Nilfs in kernel 3.2.12, I started running into errors after 
about a week of steady use.  On the system where this happened, it 
didn't behave very well; the kernel's watchdog detected a soft-lockup 
after 23 seconds and rebooted the system.  I had it mounted with "-o 
errors=continue".

I moved the drive to a different system, and mounted it (with 
errors=remount-ro), and read the problem files, and got I/O errors in 
user-land (as I might expect) but it didn't hang up the kernel or 
trigger a soft-lockup.

After some reading, I now understand that errors=continue might not be 
the best idea.  Also, the soft-lockup is detected after 20 seconds, 
which is maybe too narrow of a window?

But, I wanted to post here and see if you recognized a bug that was 
already fixed in a newer kernel, or if it inspires ideas of how to 
prevent soft-lockups (by putting limits on scanning functions, or 
something).  Also, I've decided I should at least upgrade to kernel 
3.2.52, but do you know if I need to go newer than that, to avoid known 
bugs?

Below is the output of "log" on the crash utility, from my vmcore.

Thanks in advance.
-Mike

[10796.519283] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143304192, 
inode=0, rec_len=0, name_len=0
[10796.519292] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143308288, 
inode=0, rec_len=0, name_len=0
[10796.519300] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143312384, 
inode=0, rec_len=0, name_len=0
[10796.519308] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143316480, 
inode=0, rec_len=0, name_len=0
[10796.519317] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143320576, 
inode=0, rec_len=0, name_len=0
[10796.519325] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143324672, 
inode=0, rec_len=0, name_len=0
[10796.519333] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143328768, 
inode=0, rec_len=0, name_len=0
[10796.519341] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143332864, 
inode=0, rec_len=0, name_len=0
[10796.519350] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143336960, 
inode=0, rec_len=0, name_len=0
[10796.519364] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143341056, 
inode=0, rec_len=0, name_len=0
[10796.519374] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143345152, 
inode=0, rec_len=0, name_len=0
[10796.519382] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143349248, 
inode=0, rec_len=0, name_len=0
[10796.519390] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143353344, 
inode=0, rec_len=0, name_len=0
[10796.519398] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143357440, 
inode=0, rec_len=0, name_len=0
[10796.519406] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143361536, 
inode=0, rec_len=0, name_len=0
[10796.519415] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143365632, 
inode=0, rec_len=0, name_len=0
[10796.519423] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143369728, 
inode=0, rec_len=0, name_len=0
[10796.519431] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143373824, 
inode=0, rec_len=0, name_len=0
[10796.519439] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143377920, 
inode=0, rec_len=0, name_len=0
[10796.519447] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143382016, 
inode=0, rec_len=0, name_len=0
[10796.519455] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143386112, 
inode=0, rec_len=0, name_len=0
[10796.519463] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143390208, 
inode=0, rec_len=0, name_len=0
[10796.519471] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143394304, 
inode=0, rec_len=0, name_len=0
[10796.519480] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143398400, 
inode=0, rec_len=0, name_len=0
[10796.519488] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143402496, 
inode=0, rec_len=0, name_len=0
[10796.519496] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143406592, 
inode=0, rec_len=0, name_len=0
[10796.519505] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143410688, 
inode=0, rec_len=0, name_len=0
[10796.519513] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143414784, 
inode=0, rec_len=0, name_len=0
[10796.519521] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143418880, 
inode=0, rec_len=0, name_len=0
[10796.519530] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143422976, 
inode=0, rec_len=0, name_len=0
[10796.519538] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143427072, 
inode=0, rec_len=0, name_len=0
[10796.519545] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143431168, 
inode=0, rec_len=0, name_len=0
[10796.519554] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143435264, 
inode=0, rec_len=0, name_len=0
[10796.519562] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143439360, 
inode=0, rec_len=0, name_len=0
[10796.519570] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143443456, 
inode=0, rec_len=0, name_len=0
[10796.519578] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143447552, 
inode=0, rec_len=0, name_len=0
[10796.519587] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143451648, 
inode=0, rec_len=0, name_len=0
[10796.519595] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143455744, 
inode=0, rec_len=0, name_len=0
[10796.519604] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143459840, 
inode=0, rec_len=0, name_len=0
[10796.519612] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143463936, 
inode=0, rec_len=0, name_len=0
[10796.519627] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143468032, 
inode=0, rec_len=0, name_len=0
[10796.519635] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143472128, 
inode=0, rec_len=0, name_len=0
[10796.519643] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143476224, 
inode=0, rec_len=0, name_len=0
[10796.519652] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143480320, 
inode=0, rec_len=0, name_len=0
[10796.519660] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143484416, 
inode=0, rec_len=0, name_len=0
[10796.519668] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143488512, 
inode=0, rec_len=0, name_len=0
[10796.519676] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143492608, 
inode=0, rec_len=0, name_len=0
[10796.519685] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143496704, 
inode=0, rec_len=0, name_len=0
[10796.519693] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143500800, 
inode=0, rec_len=0, name_len=0
[10796.519701] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143504896, 
inode=0, rec_len=0, name_len=0
[10796.519710] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143508992, 
inode=0, rec_len=0, name_len=0
[10796.519718] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143513088, 
inode=0, rec_len=0, name_len=0
[10796.519727] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143517184, 
inode=0, rec_len=0, name_len=0
[10796.519735] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143521280, 
inode=0, rec_len=0, name_len=0
[10796.519744] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143525376, 
inode=0, rec_len=0, name_len=0
[10796.519752] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143529472, 
inode=0, rec_len=0, name_len=0
[10796.519760] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143533568, 
inode=0, rec_len=0, name_len=0
[10796.519769] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143537664, 
inode=0, rec_len=0, name_len=0
[10796.519777] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143541760, 
inode=0, rec_len=0, name_len=0
[10796.519877] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143545856, 
inode=0, rec_len=0, name_len=0
[10796.519898] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143549952, 
inode=0, rec_len=0, name_len=0
[10796.519906] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143554048, 
inode=0, rec_len=0, name_len=0
[10796.519914] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143558144, 
inode=0, rec_len=0, name_len=0
[10796.519922] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143562240, 
inode=0, rec_len=0, name_len=0
[10796.519937] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143566336, 
inode=0, rec_len=0, name_len=0
[10796.519945] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143570432, 
inode=0, rec_len=0, name_len=0
[10796.519954] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143574528, 
inode=0, rec_len=0, name_len=0
[10796.519962] NILFS error (device sdf1): nilfs_check_page: bad entry in 
directory #2383620: rec_len is smaller than minimal - offset=1143578624, 
inode=0, rec_len=0, name_len=0
[10796.519969] BUG: soft lockup - CPU#5 stuck for 23s! [rsync:15865]
[10796.519971] Modules linked in: twofish_i586 twofish_generic 
twofish_common camellia serpent blowfish_generic blowfish_common xcbc 
sha512_generic crypto_null aes_i586 coretemp lm85 hwmon_vid i2c_i801 
i5k_amb asix r8169 8139too natsemi tg3 bnx2 3c59x tulip e100 e1000 
e1000e vmxnet3
[10796.519990] Modules linked in: twofish_i586 twofish_generic 
twofish_common camellia serpent blowfish_generic blowfish_common xcbc 
sha512_generic crypto_null aes_i586 coretemp lm85 hwmon_vid i2c_i801 
i5k_amb asix r8169 8139too natsemi tg3 bnx2 3c59x tulip e100 e1000 
e1000e vmxnet3
[10796.520004]
[10796.520006] Pid: 15865, comm: rsync Not tainted 3.2.12-gentoo #10 
Dell Inc. PowerEdge 2950/0CU542
[10796.520010] EIP: 0060:[<c02bc7db>] EFLAGS: 00000202 CPU: 5
[10796.520016] EIP is at nilfs_btree_node_lookup+0x46/0xab
[10796.520018] EAX: 002616c3 EBX: 210e4606 ECX: 000001c4 EDX: 00000000
[10796.520020] ESI: 00000000 EDI: 000000e2 EBP: 000000e3 ESP: eea05a30
[10796.520022]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[10796.520024] Process rsync (pid: 15865, ti=eea04000 task=f25cebd0 
task.ti=eea04000)
[10796.522257] Stack:
[10796.522257]  000000e2 e8b36000 000000e1 e8b36000 18bc9446 00000000 
ead61c24 c02bcc2b
[10796.522257]  eea05a84 f15fc038 00000002 00000000 000000ff 04fffffe 
00000001 f15fc0d8
[10796.522257]  00000002 000000d8 00000000 00000000 ead61dec 00000026 
f15fc038 210e4606
[10796.522257] Call Trace:
[10796.522257]  [<c02bcc2b>] ? nilfs_btree_do_lookup+0x11a/0x1d0
[10796.522257]  [<c02bcec0>] ? nilfs_btree_lookup+0x35/0x49
[10796.522257]  [<c02bc603>] ? nilfs_bmap_lookup_at_level+0x2b/0x9a
[10796.522257]  [<c02bb18c>] ? nilfs_grab_buffer+0x88/0xb0
[10796.522257]  [<c02bb381>] ? nilfs_mdt_submit_block+0xa2/0x11b
[10796.522257]  [<c02bb414>] ? nilfs_mdt_read_block+0x1a/0xb4
[10796.522257]  [<c0148d90>] ? hrtimer_forward+0xff/0x11b
[10796.522257]  [<c02bb593>] ? nilfs_mdt_get_block+0x2c/0x1a0
[10796.522257]  [<c02c8fef>] ? nilfs_palloc_get_block+0x52/0x8a
[10796.522257]  [<c02c90e8>] ? nilfs_palloc_get_entry_block+0x56/0x5e
[10796.522257]  [<c02c03a7>] ? nilfs_dat_translate+0x25/0xee
[10796.522257]  [<c02bbe99>] ? nilfs_btnode_submit_block+0x86/0x16d
[10796.522257]  [<c02bca22>] ? __nilfs_btree_get_block+0x35/0x124
[10796.522257]  [<c02bcbea>] ? nilfs_btree_do_lookup+0xd9/0x1d0
[10796.522257]  [<c0114953>] ? intel_pmu_enable_all+0x79/0xd6
[10796.522257]  [<c02be713>] ? nilfs_btree_lookup_contig+0x47/0x2c9
[10796.522257]  [<c035e212>] ? number+0x16c/0x272
[10796.522257]  [<c035e0a2>] ? put_dec+0x61/0x65
[10796.522257]  [<c035e212>] ? number+0x16c/0x272
[10796.522257]  [<c02bc433>] ? nilfs_bmap_lookup_contig+0x3b/0x59
[10796.522257]  [<c02b7564>] ? nilfs_get_block+0x74/0x1b3
[10796.522257]  [<c01bb9fa>] ? do_mpage_readpage+0x254/0x5d6
[10796.522257]  [<c02b74f0>] ? nilfs_setattr+0xbb/0xbb
[10796.522257]  [<c0174c72>] ? get_page_from_freelist+0x5a/0x341
[10796.522257]  [<c01bbdc4>] ? mpage_readpage+0x48/0x5e
[10796.522257]  [<c02b74f0>] ? nilfs_setattr+0xbb/0xbb
[10796.522257]  [<c0170d59>] ? add_to_page_cache_locked+0x6d/0x96
[10796.522257]  [<c0170dac>] ? add_to_page_cache_lru+0x2a/0x2f
[10796.522257]  [<c0170ebf>] ? do_read_cache_page+0x6e/0xee
[10796.522257]  [<c02b62c3>] ? nilfs_writepages+0x23/0x23
[10796.522257]  [<c0170f6c>] ? read_cache_page_async+0x14/0x18
[10796.522257]  [<c0170f79>] ? read_cache_page+0x9/0xf
[10796.522257]  [<c02b7a5a>] ? nilfs_get_page+0x17/0x1b9
[10796.522257]  [<c02b864b>] ? nilfs_empty_dir+0x3b/0x108
[10796.522257]  [<c02ba1e8>] ? nilfs_rmdir+0x2c/0x7f
[10796.522257]  [<c019e88b>] ? vfs_rmdir+0x78/0xc9
[10796.522257]  [<c01a0983>] ? do_rmdir+0x89/0xc1
[10796.522257]  [<c01a97a1>] ? mntput_no_expire+0x9/0xb7
[10796.522257]  [<c01947b7>] ? filp_close+0x54/0x5a
[10796.522257]  [<c01957d2>] ? sys_close+0x60/0x92
[10796.522257]  [<c08cf8c1>] ? syscall_call+0x7/0xb
[10796.522257]  [<c08c0000>] ? cpqarray_remove_one_pci+0x21/0x54
[10796.522257] Code: 00 00 00 00 8d 68 ff eb 49 8b 4c 24 08 ba 02 00 00 
00 89 d7 01 e9 89 c8 99 f7 ff 89 04 24 89 c2 89 c7 8b 44 24 04 e8 01 ff 
ff ff <39> f2 75 04 39 d8 74 3b 39 f2 77 12 72 04 39 d8 73 0c 8d 47 01
[10796.522257] Call Trace:
[10796.522257]  [<c02bcc2b>] ? nilfs_btree_do_lookup+0x11a/0x1d0
[10796.522257]  [<c02bcec0>] ? nilfs_btree_lookup+0x35/0x49
[10796.522257]  [<c02bc603>] ? nilfs_bmap_lookup_at_level+0x2b/0x9a
[10796.522257]  [<c02bb18c>] ? nilfs_grab_buffer+0x88/0xb0
[10796.522257]  [<c02bb381>] ? nilfs_mdt_submit_block+0xa2/0x11b
[10796.522257]  [<c02bb414>] ? nilfs_mdt_read_block+0x1a/0xb4
[10796.522257]  [<c0148d90>] ? hrtimer_forward+0xff/0x11b
[10796.522257]  [<c02bb593>] ? nilfs_mdt_get_block+0x2c/0x1a0
[10796.522257]  [<c02c8fef>] ? nilfs_palloc_get_block+0x52/0x8a
[10796.522257]  [<c02c90e8>] ? nilfs_palloc_get_entry_block+0x56/0x5e
[10796.522257]  [<c02c03a7>] ? nilfs_dat_translate+0x25/0xee
[10796.522257]  [<c02bbe99>] ? nilfs_btnode_submit_block+0x86/0x16d
[10796.522257]  [<c02bca22>] ? __nilfs_btree_get_block+0x35/0x124
[10796.522257]  [<c02bcbea>] ? nilfs_btree_do_lookup+0xd9/0x1d0
[10796.522257]  [<c0114953>] ? intel_pmu_enable_all+0x79/0xd6
[10796.522257]  [<c02be713>] ? nilfs_btree_lookup_contig+0x47/0x2c9
[10796.522257]  [<c035e212>] ? number+0x16c/0x272
[10796.522257]  [<c035e0a2>] ? put_dec+0x61/0x65
[10796.522257]  [<c035e212>] ? number+0x16c/0x272
[10796.522257]  [<c02bc433>] ? nilfs_bmap_lookup_contig+0x3b/0x59
[10796.522257]  [<c02b7564>] ? nilfs_get_block+0x74/0x1b3
[10796.522257]  [<c01bb9fa>] ? do_mpage_readpage+0x254/0x5d6
[10796.522257]  [<c02b74f0>] ? nilfs_setattr+0xbb/0xbb
[10796.522257]  [<c0174c72>] ? get_page_from_freelist+0x5a/0x341
[10796.522257]  [<c01bbdc4>] ? mpage_readpage+0x48/0x5e
[10796.522257]  [<c02b74f0>] ? nilfs_setattr+0xbb/0xbb
[10796.522257]  [<c0170d59>] ? add_to_page_cache_locked+0x6d/0x96
[10796.522257]  [<c0170dac>] ? add_to_page_cache_lru+0x2a/0x2f
[10796.522257]  [<c0170ebf>] ? do_read_cache_page+0x6e/0xee
[10796.522257]  [<c02b62c3>] ? nilfs_writepages+0x23/0x23
[10796.522257]  [<c0170f6c>] ? read_cache_page_async+0x14/0x18
[10796.522257]  [<c0170f79>] ? read_cache_page+0x9/0xf
[10796.522257]  [<c02b7a5a>] ? nilfs_get_page+0x17/0x1b9
[10796.522257]  [<c02b864b>] ? nilfs_empty_dir+0x3b/0x108
[10796.522257]  [<c02ba1e8>] ? nilfs_rmdir+0x2c/0x7f
[10796.522257]  [<c019e88b>] ? vfs_rmdir+0x78/0xc9
[10796.522257]  [<c01a0983>] ? do_rmdir+0x89/0xc1
[10796.522257]  [<c01a97a1>] ? mntput_no_expire+0x9/0xb7
[10796.522257]  [<c01947b7>] ? filp_close+0x54/0x5a
[10796.522257]  [<c01957d2>] ? sys_close+0x60/0x92
[10796.522257]  [<c08cf8c1>] ? syscall_call+0x7/0xb
[10796.522257]  [<c08c0000>] ? cpqarray_remove_one_pci+0x21/0x54
[10796.522257] Kernel panic - not syncing: softlockup: hung tasks

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
