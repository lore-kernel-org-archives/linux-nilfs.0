From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Wed, 06 May 2009 17:46:26 +0200
Message-ID: <4A01B0D2.6030509@prnet.org>
References: <20090506.004648.105122016.ryusuke@osrg.net>	<4A006EAB.6000206@prnet.org>	<4A00944B.2020105@prnet.org>
	<20090506.120204.27533580.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090506.120204.27533580.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

today I had run cleanerd on 2 clean partitions.

One worked flawlessly. On the other one this error occured:

BUG: unable to handle kernel NULL pointer dereference at 00000ccd
IP: [<f8341fcc>] nilfs_gc_iget+0x4c/0x130 [nilfs2]
*pdpt = 0000000013d32001 *pde = 0000000000000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.0/resource
Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi 
capifs kernelcapi nilfs2 scsi_wait_scan

Pid: 8551, comm: nilfs_cleanerd Tainted: P           (2.6.29.2server #1) 
P5QL-E
EIP: 0060:[<f8341fcc>] EFLAGS: 00010202 CPU: 3
EIP is at nilfs_gc_iget+0x4c/0x130 [nilfs2]
EAX: 00000ccd EBX: 00000000 ECX: 00000002 EDX: f6897c00
ESI: 0000004e EDI: 00000002 EBP: 00000000 ESP: c3801ca0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process nilfs_cleanerd (pid: 8551, ti=c3800000 task=d4d10330 
task.ti=c3800000)
Stack:
 e11854c0 f6857a00 f6897c3c 00000000 00000000 00000000 e1185500 f8342e06
 00000002 00000000 c3801d60 00000044 f7450990 d4d10484 00000001 00000001
 00000000 00000000 00020050 00000202 00000000 00000000 00000000 c3801d58
Call Trace:
 [<f8342e06>] nilfs_ioctl_do_move_blocks+0x76/0x3e0 [nilfs2]
 [<f8342379>] nilfs_ioctl_wrap_copy+0x169/0x1f0 [nilfs2]
 [<f834292e>] nilfs_ioctl_prepare_clean_segments+0x6e/0x130 [nilfs2]
 [<f8342d90>] nilfs_ioctl_do_move_blocks+0x0/0x3e0 [nilfs2]
 [<f833deb3>] nilfs_clean_segments+0x83/0x200 [nilfs2]
 [<f83423c6>] nilfs_ioctl_wrap_copy+0x1b6/0x1f0 [nilfs2]
 [<f8342810>] nilfs_ioctl+0x3d0/0x480 [nilfs2]
 [<f8342c90>] nilfs_ioctl_do_get_bdescs+0x0/0xb0 [nilfs2]
 [<c0312ddf>] ehci_irq+0x17f/0x340
 [<c0168a78>] page_add_new_anon_rmap+0x28/0x60
 [<c013ddfe>] getnstimeofday+0x4e/0x120
 [<f8342440>] nilfs_ioctl+0x0/0x480 [nilfs2]
 [<c017f50b>] vfs_ioctl+0x2b/0x90
 [<c017f87b>] do_vfs_ioctl+0x1eb/0x530
 [<c012d45b>] run_timer_softirq+0x15b/0x190
 [<c0128d74>] __do_softirq+0x94/0x140
 [<c017fbfd>] sys_ioctl+0x3d/0x70
 [<c0103131>] sysenter_do_call+0x12/0x25
 [<c0400000>] pci_read_bridge_bases+0x20/0x350
Code: f8 69 c0 01 00 37 9e c1 e8 18 c1 e0 02 89 44 24 08 8b 92 dc 00 00 
00 01 d0 89 44 24 08 8b 00 85 c0 75 08 eb 2b 85 c9 74 27 89 c8 <8b> 08 
0f 18 01 90 3b 70 20 89 c3 75 ed 8b 50 9c 8b 40 98 31 ea
EIP: [<f8341fcc>] nilfs_gc_iget+0x4c/0x130 [nilfs2] SS:ESP 0068:c3801ca0
---[ end trace 573da78de6d7c815 ]---

Bye,
Arendt David

Ryusuke Konishi wrote:
> Hi,
> On Tue, 05 May 2009 21:32:27 +0200, David Arendt wrote:
>   
>> Hi,
>>
>> after cleaner was running for 2 hours and freeing up 200gbytes of space 
>> I had the following crash:
>>
>> nilfs_cpfile_delete_checkpoints: cannot delete block: cno=76377, range = 
>> [75980, 76972)
>> NILFS: GC failed during preparation: cannot delete checkpoints: err=-2
>> NILFS_PAGE_BUG(c10d67e0): cnt=2 index#=74049180 flags=0x40000835 
>> mapping=f71d10d4 ino=0
>>  BH[0] d3cbdb30: cnt=2 block#=74049180 state=0x2002b
>> ------------[ cut here ]------------
>> kernel BUG at /home/admin/x/nilfs-2.0.12/fs/btnode.c:233!
>>     
>
> The log shows a btree routine, nilfs_btree_propagate() has detected an
> orphan btree node in the page cache.  Looks another inconsistency.
>
> I'd like to know if this is a regression of the previous patch or not
> ( I guess it's not ). If you see this for new volumes, please let me
> know.
>
> I'll digging into the btree code to hunt this later.
>
> Thanks,
> Ryusuke Konishi
>
>   
>> invalid opcode: 0000 [#1] PREEMPT SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.0/resource
>> Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi 
>> capifs kernelcapi nilfs2 scsi_wait_scan
>>
>> Pid: 2285, comm: segctord Tainted: P           (2.6.29.2server #1) P5QL-E
>> EIP: 0060:[<f8331680>] EFLAGS: 00010282 CPU: 2
>> EIP is at nilfs_btnode_prepare_change_key+0x170/0x180 [nilfs2]
>> EAX: 00000038 EBX: 003ba23a ECX: 00000092 EDX: 0307b000
>> ESI: 00000000 EDI: 00000000 EBP: f2783afc ESP: f6c13ce0
>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process segctord (pid: 2285, ti=f6c12000 task=f75d5cc0 task.ti=f6c12000)
>> Stack:
>>  f83366b8 00000001 f2783af8 00000000 f71d10d4 d3cbdb30 003ba248 00000000
>>  f833184d 00000000 f2783ac8 f2783ad4 f71d1044 f83328c9 f2783ae8 f83436a4
>>  00000000 f2783a78 f71d1044 f83342fe 00000001 00000001 02783a78 f2783ac8
>> Call Trace:
>>  [<f83366b8>] nilfs_dat_prepare_entry+0x18/0x20 [nilfs2]
>>  [<f833184d>] nilfs_bmap_prepare_update+0x2d/0x60 [nilfs2]
>>  [<f83328c9>] nilfs_btree_prepare_update_v+0xe9/0x100 [nilfs2]
>>  [<f83342fe>] nilfs_btree_propagate_v+0x17e/0x210 [nilfs2]
>>  [<f833538a>] nilfs_btree_propagate+0xba/0x160 [nilfs2]
>>  [<f8331aa6>] nilfs_bmap_propagate+0x26/0x40 [nilfs2]
>>  [<f833e42e>] nilfs_collect_file_node+0x1e/0x50 [nilfs2]
>>  [<f833a5a1>] nilfs_segctor_apply_buffers+0x51/0xb0 [nilfs2]
>>  [<f833a975>] nilfs_segctor_scan_file+0x125/0x1f0 [nilfs2]
>>  [<f833e410>] nilfs_collect_file_node+0x0/0x50 [nilfs2]
>>  [<c019177b>] __getblk+0x7b/0x210
>>  [<f8339a5c>] nilfs_segbuf_extend_segsum+0x1c/0x50 [nilfs2]
>>  [<f833cb5d>] nilfs_segctor_do_construct+0x166d/0x18c0 [nilfs2]
>>  [<f8341898>] nilfs_palloc_commit_free_entry+0xc8/0x100 [nilfs2]
>>  [<c011c25b>] update_curr+0x7b/0xe0
>>  [<c011f9bb>] finish_task_switch+0x2b/0xa0
>>  [<f833199f>] nilfs_bmap_test_and_clear_dirty+0x2f/0x40 [nilfs2]
>>  [<f8330e2e>] nilfs_mdt_fetch_dirty+0xe/0x30 [nilfs2]
>>  [<f833a4c3>] nilfs_test_metadata_dirty+0x93/0xb0 [nilfs2]
>>  [<f833a534>] nilfs_segctor_confirm+0x54/0x70 [nilfs2]
>>  [<f833d009>] nilfs_segctor_construct+0x99/0xb0 [nilfs2]
>>  [<f833d7ba>] nilfs_segctor_thread+0x11a/0x2b0 [nilfs2]
>>  [<f833d310>] nilfs_construction_timeout+0x0/0x10 [nilfs2]
>>  [<f833d6a0>] nilfs_segctor_thread+0x0/0x2b0 [nilfs2]
>>  [<c0136e92>] kthread+0x42/0x70
>>  [<c0136e50>] kthread+0x0/0x70
>>  [<c010391b>] kernel_thread_helper+0x7/0x1c
>> Code: ff ff ff 8b 54 24 14 8b 42 08 e8 1c b8 e1 c7 89 f8 83 c4 24 5b 5e 
>> 5f 5d c3 e8 3d 78 0d c8 eb b4 0f 0b eb fe 89 d0 e8 40 e7 ff ff <0f> 0b 
>> eb fe 89 d0 e8 25 b7 e1 c7 e9 2d ff ff ff 53 b9 ff ff ff
>> EIP: [<f8331680>] nilfs_btnode_prepare_change_key+0x170/0x180 [nilfs2] 
>> SS:ESP 0068:f6c13ce0
>> ---[ end trace 0a4368694028129d ]---
>> note: segctord[2285] exited with preempt_count 1
>>
>> Bye,
>> David Arendt
>>
>> David Arendt wrote:
>>     
>>> Hi,
>>>
>>> I have applied your patch now. Also the garbage collector didn't crash 
>>> until now. I have chosen to not reformat for further testing as there 
>>> are only temporary files on this partition where loosing them would not 
>>> be a big problem.
>>>
>>> Bye,
>>> David Arendt
>>>
>>> Ryusuke Konishi wrote:
>>>   
>>>       
>>>> Hi!
>>>> On Tue,  5 May 2009 17:26:48 +0200, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>>>>   
>>>>     
>>>>         
>>>>> Thank you.
>>>>> I will try this patch in a few hours.  If I see it correctly the
>>>>> patch will prevent this error in future and will not correct the
>>>>> current error, so I suppose that after applying the patch I will
>>>>> need to reformat the volume.
>>>>>     
>>>>>       
>>>>>           
>>>> I expect the patch will even fix the current error on the next GC, but
>>>> you had better reformat the volume for safety.
>>>>
>>>> Ryusuke Konishi
>>>>   
>>>>     
>>>>         
>>> _______________________________________________
>>> users mailing list
>>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>>> https://www.nilfs.org/mailman/listinfo/users
>>>   
>>>       
