From: Leandro Lucarella <llucax@gmail.com>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Sun, 14 Jun 2009 12:32:56 -0300
Message-ID: <20090614153256.GA4020@homero.springfield.home>
References: <20090614013211.GA22552@homero.springfield.home> <20090614.124517.47505469.konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759718AbZFNPeN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090614.124517.47505469.konishi.ryusuke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, albertito@blitiri.com.ar, users@nilfs.org

Ryusuke Konishi, el 14 de junio a las 12:45 me escribiste:
> Hi,
> On Sat, 13 Jun 2009 22:32:11 -0300, Leandro Lucarella wrote:
> > Hi!
> > 
> > While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
> > sometimes they got stucked in D state, and the kernel had said the
> > following message:
> > 
> >         NILFS: IO error writing segment
> > 
> > A friend gave me a hand and after adding some printk()s we found out that
> > the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
> > fail, making it return NULL; but we don't know how that causes the
> > processes to get stucked.
> 
> Thank you for reporting this issue.
> 
> Could you get stack dump of the stuck nilfs task?
> It is acquirable as follows if you enabled magic sysrq feature:
> 
>  # echo t > /proc/sysrq-trigger
> 
> I will dig into the process how it got stuck.

Here is (what I thought it's) the important stuff:

[...]
kdmflush      S dc5abf5c     0  1018      2
 dc5abf84 00000046 dc60d780 dc5abf5c c01ad12e dd4d6ed0 dd4d7148 e3504d6e
 00003c16 dc8b2560 dc5abf7c c040e24b dd846da0 dc60d7cc dd4d6ed0 dc5abf8c
 c040d628 dc5abfd0 c0131dbd dc7fe230 dd4d6ed0 dc5abfa8 dd4d6ed0 dd846da8
Call Trace:
 [<c01ad12e>] ? bio_fs_destructor+0xe/0x10
 [<c040e24b>] ? down_write+0xb/0x30
 [<c040d628>] schedule+0x8/0x20
 [<c0131dbd>] worker_thread+0x16d/0x1e0
 [<debcba30>] ? dm_wq_work+0x0/0x120 [dm_mod]
 [<c0135420>] ? autoremove_wake_function+0x0/0x50
 [<c0131c50>] ? worker_thread+0x0/0x1e0
 [<c0134fb3>] kthread+0x43/0x80
 [<c0134f70>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
[...]
loop0         S dcc7bce0     0 15884      2
 d7671f48 00000046 c01ad116 dcc7bce0 dcc7bca0 d4686590 d4686808 b50316ce
 000003b8 dc7010a0 c01b0d4f c01b0cf0 dcc7bcec 0c7f3000 00000000 d7671f50
 c040d628 d7671fd0 de85391c 00000000 00000000 00000000 dcbbd108 dcbbd000
Call Trace:
 [<c01ad116>] ? bio_free+0x46/0x50
 [<c01b0d4f>] ? mpage_end_io_read+0x5f/0x70
 [<c01b0cf0>] ? mpage_end_io_read+0x0/0x70
 [<c040d628>] schedule+0x8/0x20
 [<de85391c>] loop_thread+0x1cc/0x490 [loop]
 [<de853590>] ? do_lo_send_aops+0x0/0x1c0 [loop]
 [<c0135420>] ? autoremove_wake_function+0x0/0x50
 [<de853750>] ? loop_thread+0x0/0x490 [loop]
 [<c0134fb3>] kthread+0x43/0x80
 [<c0134f70>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
segctord      D 00000001     0 15886      2
 d3847ef4 00000046 c011cefb 00000001 00000001 dcf48fd0 dcf49248 c052b9d0
 d50962e4 dc701720 d46871dc d46871e4 c23f180c c23f180c d3847f28 d3847efc
 c040d628 d3847f20 c040ed3d c23f1810 dcf48fd0 d46871dc 00000000 c23f180c
Call Trace:
 [<c011cefb>] ? dequeue_task_fair+0x27b/0x280
 [<c040d628>] schedule+0x8/0x20
 [<c040ed3d>] rwsem_down_failed_common+0x7d/0x180
 [<c040ee5d>] rwsem_down_write_failed+0x1d/0x30
 [<c040eeaa>] call_rwsem_down_write_failed+0x6/0x8
 [<c040e25e>] ? down_write+0x1e/0x30
 [<decb6299>] nilfs_transaction_lock+0x59/0x100 [nilfs2]
 [<decb6d5c>] nilfs_segctor_thread+0xcc/0x2e0 [nilfs2]
 [<decb6c80>] ? nilfs_construction_timeout+0x0/0x10 [nilfs2]
 [<decb6c90>] ? nilfs_segctor_thread+0x0/0x2e0 [nilfs2]
 [<c0134fb3>] kthread+0x43/0x80
 [<c0134f70>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
rm            D d976bde0     0 16147      1
 d976bdf0 00000086 003abc46 d976bde0 c013cc46 c18ad190 c18ad408 00000000
 003abc46 dc789900 d976be38 d976bdf0 00000000 d976be30 d976be38 d976bdf8
 c040d628 d976be00 c040d67a d976be08 c01668dd d976be24 c040dad7 c01668b0
Call Trace:
 [<c013cc46>] ? getnstimeofday+0x56/0x110
 [<c040d628>] schedule+0x8/0x20
 [<c040d67a>] io_schedule+0x3a/0x70
 [<c01668dd>] sync_page+0x2d/0x60
 [<c040dad7>] __wait_on_bit+0x47/0x70
 [<c01668b0>] ? sync_page+0x0/0x60
 [<c0166b08>] wait_on_page_bit+0x98/0xb0
 [<c0135470>] ? wake_bit_function+0x0/0x60
 [<c016f3e4>] truncate_inode_pages_range+0x244/0x360
 [<c01a448c>] ? __mark_inode_dirty+0x2c/0x160
 [<decb756c>] ? nilfs_transaction_commit+0x9c/0x170 [nilfs2]
 [<c040e27b>] ? down_read+0xb/0x20
 [<c016f51a>] truncate_inode_pages+0x1a/0x20
 [<deca3e9f>] nilfs_delete_inode+0x9f/0xd0 [nilfs2]
 [<deca3e00>] ? nilfs_delete_inode+0x0/0xd0 [nilfs2]
 [<c019c082>] generic_delete_inode+0x92/0x150
 [<c019c1af>] generic_drop_inode+0x6f/0x1b0
 [<c019b457>] iput+0x47/0x50
 [<c0194763>] do_unlinkat+0xd3/0x160
 [<c0197106>] ? vfs_readdir+0x66/0x90
 [<c0196e00>] ? filldir64+0x0/0xf0
 [<c01971c6>] ? sys_getdents64+0x96/0xb0
 [<c0194913>] sys_unlinkat+0x23/0x50
 [<c0102db5>] syscall_call+0x7/0xb
umount        D d06bbe6c     0 16727      1
 d06bbe7c 00000086 d06bbe58 d06bbe6c c013cc46 dc5ef350 dc5ef5c8 00000000
 022bb380 dc6503a0 d06bbec4 d06bbe7c 00000000 d06bbebc d06bbec4 d06bbe84
 c040d628 d06bbe8c c040d67a d06bbe94 c01668dd d06bbeb0 c040dad7 c01668b0
Call Trace:
 [<c013cc46>] ? getnstimeofday+0x56/0x110
 [<c040d628>] schedule+0x8/0x20
 [<c040d67a>] io_schedule+0x3a/0x70
 [<c01668dd>] sync_page+0x2d/0x60
 [<c040dad7>] __wait_on_bit+0x47/0x70
 [<c01668b0>] ? sync_page+0x0/0x60
 [<c0166b08>] wait_on_page_bit+0x98/0xb0
 [<c0135470>] ? wake_bit_function+0x0/0x60
 [<c0167494>] wait_on_page_writeback_range+0xa4/0x110
 [<c01675a0>] ? __filemap_fdatawrite_range+0x60/0x80
 [<c0167534>] filemap_fdatawait+0x34/0x40
 [<c016871b>] filemap_write_and_wait+0x3b/0x50
 [<c01ae329>] sync_blockdev+0x19/0x20
 [<c01a4365>] __sync_inodes+0x45/0x70
 [<c01a439d>] sync_inodes+0xd/0x30
 [<c01a70d7>] do_sync+0x17/0x70
 [<c01a715d>] sys_sync+0xd/0x20
 [<c0102db5>] syscall_call+0x7/0xb
[...]

'rm' is the "original" stuck process, 'umount' got stuck after that, when I
tried to umount the nilfs (it was mounted in a loop device).


Here is the complete trace:
http://pastebin.lugmen.org.ar/4931

Thank you.

-- 
Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/
----------------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------------
Don't take life to seriously, you won't get out alive
