From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Tue, 05 May 2009 23:19:19 +0200
Message-ID: <4A00AD57.805@prnet.org>
References: <D6LvKjCkn1gF.D60GTY3Z@mail.prnet.org>	<20090506.004648.105122016.ryusuke@osrg.net>	<4A006EAB.6000206@prnet.org>
	<4A00944B.2020105@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A00944B.2020105-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi,

The following error occurred after running cleaner once again after this 
error, but some more space could be freed up.

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c015792e>] shrink_page_list+0x31e/0x6d0
*pdpt = 000000002bb7f001 *pde = 0000000000000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.0/resource
Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi 
capifs kernelcapi nilfs2 scsi_wait_scan

Pid: 333, comm: kswapd0 Tainted: P           (2.6.29.2server #1) P5QL-E
EIP: 0060:[<c015792e>] EFLAGS: 00010282 CPU: 3
EIP is at shrink_page_list+0x31e/0x6d0
EAX: 00000000 EBX: c158f300 ECX: 40000811 EDX: ecc48e54
ESI: f6c5df70 EDI: 00000001 EBP: f6c5debc ESP: f6c5dd84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kswapd0 (pid: 333, ti=f6c5c000 task=f7482000 task.ti=f6c5c000)
Stack:
 c01575a2 00000000 f6c5de0c 00000000 00000000 00000000 00000009 ecc48e54
 00000009 00000001 c1622320 c1622340 c1622360 c1624d40 c1624d60 c1624d80
 c1624da0 c1624dc0 c1624de0 00000001 c16a5d80 c158f400 00000000 c0538e1c
Call Trace:
 [<c01575a2>] shrink_active_list+0x332/0x3a0
 [<c01569a8>] isolate_pages_global+0x88/0x210
 [<c01556e9>] ____pagevec_lru_add+0x119/0x130
 [<c0157f04>] shrink_list+0x224/0x560
 [<c01584b7>] shrink_zone+0x277/0x300
 [<c0158fa8>] kswapd+0x518/0x530
 [<c0156920>] isolate_pages_global+0x0/0x210
 [<c01371b0>] autoremove_wake_function+0x0/0x50
 [<c011bb2d>] complete+0x3d/0x60
 [<c0158a90>] kswapd+0x0/0x530
 [<c0136e92>] kthread+0x42/0x70
 [<c0136e50>] kthread+0x0/0x70
 [<c010391b>] kernel_thread_helper+0x7/0x1c
Code: 00 00 8b 50 04 89 c8 c1 e8 0b 83 e0 01 29 c2 83 fa 02 0f 85 f0 fd 
ff ff 8b 44 24 1c 85 c0 0f 84 f3 01 00 00 8b 54 24 1c 8b 42 38 <8b> 00 
85 c0 0f 84 d8 fe ff ff 64 a1 00 60 5a c0 f6 40 0e 80 8b
EIP: [<c015792e>] shrink_page_list+0x31e/0x6d0 SS:ESP 0068:f6c5dd84
---[ end trace 4d2b343635092946 ]---
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c015792e>] shrink_page_list+0x31e/0x6d0
*pdpt = 000000002bb7f001 *pde = 0000000000000000
Oops: 0000 [#2] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.0/resource
Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi 
capifs kernelcapi nilfs2 scsi_wait_scan

Pid: 7032, comm: nilfs_cleanerd Tainted: P      D    (2.6.29.2server #1) 
P5QL-E
EIP: 0060:[<c015792e>] EFLAGS: 00210286 CPU: 0
EIP is at shrink_page_list+0x31e/0x6d0
EAX: 00000000 EBX: c158f420 ECX: 40000811 EDX: ecc4b9d4
ESI: ebd79d70 EDI: 00000001 EBP: ebd79cd8 ESP: ebd79ba0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process nilfs_cleanerd (pid: 7032, ti=ebd78000 task=f755a330 
task.ti=ebd78000)
Stack:
 c01575a2 00000000 ebd79c28 00000000 00000000 00000008 00000005 ecc4b9d4
 00000005 00000001 c1616360 c1612da0 c16126a0 c167b720 c167b4a0 c10a1c00
 c10a28e0 c10a28c0 c10a28a0 c10a2880 c10a2860 c15f1740 00000000 c0538e1c
Call Trace:
 [<c01575a2>] shrink_active_list+0x332/0x3a0
 [<c01569a8>] isolate_pages_global+0x88/0x210
 [<c01556e9>] ____pagevec_lru_add+0x119/0x130
 [<c0157f04>] shrink_list+0x224/0x560
 [<c022751c>] elv_merged_request+0x4c/0x50
 [<c01584b7>] shrink_zone+0x277/0x300
 [<c0151807>] rmqueue_bulk+0x67/0x80
 [<c01588ef>] try_to_free_pages+0x21f/0x340
 [<c0156920>] isolate_pages_global+0x0/0x210
 [<c015286e>] __alloc_pages_internal+0x19e/0x430
 [<c0154df0>] __do_page_cache_readahead+0x100/0x230
 [<c015531a>] do_page_cache_readahead+0x4a/0x70
 [<c014f328>] filemap_fault+0x2c8/0x480
 [<c015f482>] __do_fault+0x42/0x400
 [<c0119b13>] pte_alloc_one+0x33/0x40
 [<c0161126>] __pte_alloc+0xd6/0xe0
 [<c01612ae>] handle_mm_fault+0x17e/0x800
 [<c0165fff>] mmap_region+0x14f/0x3f0
 [<c0115caa>] do_page_fault+0x28a/0x860
 [<c0115a20>] do_page_fault+0x0/0x860
 [<c040ab12>] error_code+0x72/0x78
 [<c0400000>] pci_read_bridge_bases+0x20/0x350
Code: 00 00 8b 50 04 89 c8 c1 e8 0b 83 e0 01 29 c2 83 fa 02 0f 85 f0 fd 
ff ff 8b 44 24 1c 85 c0 0f 84 f3 01 00 00 8b 54 24 1c 8b 42 38 <8b> 00 
85 c0 0f 84 d8 fe ff ff 64 a1 00 60 5a c0 f6 40 0e 80 8b
EIP: [<c015792e>] shrink_page_list+0x31e/0x6d0 SS:ESP 0068:ebd79ba0
---[ end trace 4d2b343635092947 ]---

Bye,
David Arendt

David Arendt wrote:
> Hi,
>
> after cleaner was running for 2 hours and freeing up 200gbytes of space 
> I had the following crash:
>
> nilfs_cpfile_delete_checkpoints: cannot delete block: cno=76377, range = 
> [75980, 76972)
> NILFS: GC failed during preparation: cannot delete checkpoints: err=-2
> NILFS_PAGE_BUG(c10d67e0): cnt=2 index#=74049180 flags=0x40000835 
> mapping=f71d10d4 ino=0
>  BH[0] d3cbdb30: cnt=2 block#=74049180 state=0x2002b
> ------------[ cut here ]------------
> kernel BUG at /home/admin/x/nilfs-2.0.12/fs/btnode.c:233!
> invalid opcode: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.0/resource
> Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi 
> capifs kernelcapi nilfs2 scsi_wait_scan
>
> Pid: 2285, comm: segctord Tainted: P           (2.6.29.2server #1) P5QL-E
> EIP: 0060:[<f8331680>] EFLAGS: 00010282 CPU: 2
> EIP is at nilfs_btnode_prepare_change_key+0x170/0x180 [nilfs2]
> EAX: 00000038 EBX: 003ba23a ECX: 00000092 EDX: 0307b000
> ESI: 00000000 EDI: 00000000 EBP: f2783afc ESP: f6c13ce0
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process segctord (pid: 2285, ti=f6c12000 task=f75d5cc0 task.ti=f6c12000)
> Stack:
>  f83366b8 00000001 f2783af8 00000000 f71d10d4 d3cbdb30 003ba248 00000000
>  f833184d 00000000 f2783ac8 f2783ad4 f71d1044 f83328c9 f2783ae8 f83436a4
>  00000000 f2783a78 f71d1044 f83342fe 00000001 00000001 02783a78 f2783ac8
> Call Trace:
>  [<f83366b8>] nilfs_dat_prepare_entry+0x18/0x20 [nilfs2]
>  [<f833184d>] nilfs_bmap_prepare_update+0x2d/0x60 [nilfs2]
>  [<f83328c9>] nilfs_btree_prepare_update_v+0xe9/0x100 [nilfs2]
>  [<f83342fe>] nilfs_btree_propagate_v+0x17e/0x210 [nilfs2]
>  [<f833538a>] nilfs_btree_propagate+0xba/0x160 [nilfs2]
>  [<f8331aa6>] nilfs_bmap_propagate+0x26/0x40 [nilfs2]
>  [<f833e42e>] nilfs_collect_file_node+0x1e/0x50 [nilfs2]
>  [<f833a5a1>] nilfs_segctor_apply_buffers+0x51/0xb0 [nilfs2]
>  [<f833a975>] nilfs_segctor_scan_file+0x125/0x1f0 [nilfs2]
>  [<f833e410>] nilfs_collect_file_node+0x0/0x50 [nilfs2]
>  [<c019177b>] __getblk+0x7b/0x210
>  [<f8339a5c>] nilfs_segbuf_extend_segsum+0x1c/0x50 [nilfs2]
>  [<f833cb5d>] nilfs_segctor_do_construct+0x166d/0x18c0 [nilfs2]
>  [<f8341898>] nilfs_palloc_commit_free_entry+0xc8/0x100 [nilfs2]
>  [<c011c25b>] update_curr+0x7b/0xe0
>  [<c011f9bb>] finish_task_switch+0x2b/0xa0
>  [<f833199f>] nilfs_bmap_test_and_clear_dirty+0x2f/0x40 [nilfs2]
>  [<f8330e2e>] nilfs_mdt_fetch_dirty+0xe/0x30 [nilfs2]
>  [<f833a4c3>] nilfs_test_metadata_dirty+0x93/0xb0 [nilfs2]
>  [<f833a534>] nilfs_segctor_confirm+0x54/0x70 [nilfs2]
>  [<f833d009>] nilfs_segctor_construct+0x99/0xb0 [nilfs2]
>  [<f833d7ba>] nilfs_segctor_thread+0x11a/0x2b0 [nilfs2]
>  [<f833d310>] nilfs_construction_timeout+0x0/0x10 [nilfs2]
>  [<f833d6a0>] nilfs_segctor_thread+0x0/0x2b0 [nilfs2]
>  [<c0136e92>] kthread+0x42/0x70
>  [<c0136e50>] kthread+0x0/0x70
>  [<c010391b>] kernel_thread_helper+0x7/0x1c
> Code: ff ff ff 8b 54 24 14 8b 42 08 e8 1c b8 e1 c7 89 f8 83 c4 24 5b 5e 
> 5f 5d c3 e8 3d 78 0d c8 eb b4 0f 0b eb fe 89 d0 e8 40 e7 ff ff <0f> 0b 
> eb fe 89 d0 e8 25 b7 e1 c7 e9 2d ff ff ff 53 b9 ff ff ff
> EIP: [<f8331680>] nilfs_btnode_prepare_change_key+0x170/0x180 [nilfs2] 
> SS:ESP 0068:f6c13ce0
> ---[ end trace 0a4368694028129d ]---
> note: segctord[2285] exited with preempt_count 1
>
> Bye,
> David Arendt
>
> David Arendt wrote:
>   
>> Hi,
>>
>> I have applied your patch now. Also the garbage collector didn't crash 
>> until now. I have chosen to not reformat for further testing as there 
>> are only temporary files on this partition where loosing them would not 
>> be a big problem.
>>
>> Bye,
>> David Arendt
>>
>> Ryusuke Konishi wrote:
>>   
>>     
>>> Hi!
>>> On Tue,  5 May 2009 17:26:48 +0200, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>>>   
>>>     
>>>       
>>>> Thank you.
>>>> I will try this patch in a few hours.  If I see it correctly the
>>>> patch will prevent this error in future and will not correct the
>>>> current error, so I suppose that after applying the patch I will
>>>> need to reformat the volume.
>>>>     
>>>>       
>>>>         
>>> I expect the patch will even fix the current error on the next GC, but
>>> you had better reformat the volume for safety.
>>>
>>> Ryusuke Konishi
>>>   
>>>     
>>>       
>> _______________________________________________
>> users mailing list
>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> https://www.nilfs.org/mailman/listinfo/users
>>   
>>     
>
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>   
