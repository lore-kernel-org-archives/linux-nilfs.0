From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Wed, 06 May 2009 12:02:04 +0900 (JST)
Message-ID: <20090506.120204.27533580.ryusuke@osrg.net>
References: <20090506.004648.105122016.ryusuke@osrg.net>
	<4A006EAB.6000206@prnet.org> <4A00944B.2020105@prnet.org>
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
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Tue, 05 May 2009 21:32:27 +0200, David Arendt wrote:
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

The log shows a btree routine, nilfs_btree_propagate() has detected an
orphan btree node in the page cache.  Looks another inconsistency.

I'd like to know if this is a regression of the previous patch or not
( I guess it's not ). If you see this for new volumes, please let me
know.

I'll digging into the btree code to hunt this later.

Thanks,
Ryusuke Konishi

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
> > Hi,
> >
> > I have applied your patch now. Also the garbage collector didn't crash 
> > until now. I have chosen to not reformat for further testing as there 
> > are only temporary files on this partition where loosing them would not 
> > be a big problem.
> >
> > Bye,
> > David Arendt
> >
> > Ryusuke Konishi wrote:
> >   
> >> Hi!
> >> On Tue,  5 May 2009 17:26:48 +0200, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> >>   
> >>     
> >>> Thank you.
> >>> I will try this patch in a few hours.  If I see it correctly the
> >>> patch will prevent this error in future and will not correct the
> >>> current error, so I suppose that after applying the patch I will
> >>> need to reformat the volume.
> >>>     
> >>>       
> >> I expect the patch will even fix the current error on the next GC, but
> >> you had better reformat the volume for safety.
> >>
> >> Ryusuke Konishi
> >>   
> >>     
> >
> > _______________________________________________
> > users mailing list
> > users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> > https://www.nilfs.org/mailman/listinfo/users
> >   
> 
