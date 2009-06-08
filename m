From: "Dunphy, Bill" <WDunphy-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org>
Subject: Re: [SPAM] Write hang on ARM based target
Date: Mon, 8 Jun 2009 14:30:32 -0600
Message-ID: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900F96@tdpost.td.tandbergdata.com>
References: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900F8D@tdpost.td.tandbergdata.com>
	<20090609.014919.79903506.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <20090609.014919.79903506.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke,

Thanks for the prompt reply.

>Hi!
>On Mon, 8 Jun 2009 09:46:52 -0600, "Dunphy, Bill" wrote:
>> Greetings,
>>  
>> I'm attempting to get NILFS up and running on a Marvell 
>> DB-88F6281-BP-A
>> (ARM) and have experienced a consistent hang during data transfer.  
>> This target board is running a 2.6.22.18 kernel and I've tested it 
>> against NILFS versions 2.0.12, 2.0.14 and the latest git pull 
>> (6/4/09).  I've eliminated the garbage collector and and have enabled

>> full debugging for log capture.  The failure is not immediate or at a

>> fixed point - typically in the 1-2GB neighborhood of writing variably
sized files.
>> This same exercise (a simple recursive local copy) works flawlessly
on 
>> my host Ubuntu i86 machine as well as on the target with an ext3 file

>> system.
>>  
>> Is there a specific kernel feature that I might be missing and need
to 
>> enable?  A kernel version sensitivity?  Is this log information 
>> something you would be interested in seeing?  If so, how verbose
would 
>> you like it or better still, how would you like me to collect it?
>
>Thanks for reporting.
>
>What will happen if you trigger SysRq when you meet the hang?
>
> # echo t > /proc/sysrq-trigger
>
>I don't know whether the arm kernel codes is supporting sysrq, but we
may get the stack dump of >the nilfs task hung at some lock.  If it
works, it would help us to narrow down the problem.

Here's the stack trace of the copy process which has entered a permanent
disk sleep state:

cp            D C002CAA4     0   339    333 (NOTLB)
[<c002c580>] (schedule+0x0/0x600) from [<c002d54c>]
(schedule_timeout+0x98/0xc4)
[<c002d4b4>] (schedule_timeout+0x0/0xc4) from [<c002cc28>]
(io_schedule_timeout+0x34/0x58)
 r7:00000001 r6:dfe6fc64 r5:dfd7bac0 r4:c03fb3a0
[<c002cbf4>] (io_schedule_timeout+0x0/0x58) from [<c014b834>]
(congestion_wait+0x70/0x94)
 r4:c03df664
[<c014b7c4>] (congestion_wait+0x0/0x94) from [<c0146b2c>]
(balance_dirty_pages_ratelimited_nr+0x12c/0x1c0)
 r8:00000000 r7:cf142660 r6:00000600 r5:c04038c4 r4:ffffffce
[<c0146a00>] (balance_dirty_pages_ratelimited_nr+0x0/0x1c0) from
[<c0142860>] (generic_file_buffered_write+0x570/0x670)
[<c01422f0>] (generic_file_buffered_write+0x0/0x670) from [<c0142db0>]
(__generic_file_aio_write_nolock+0x450/0x4a0)
[<c0142960>] (__generic_file_aio_write_nolock+0x0/0x4a0) from
[<c0142e78>] (generic_file_aio_write+0x78/0xf4)
[<c0142e00>] (generic_file_aio_write+0x0/0xf4) from [<c0160430>]
(do_sync_write+0xb8/0x108)
[<c0160378>] (do_sync_write+0x0/0x108) from [<c0160d18>]
(vfs_write+0xb8/0x148)
[<c0160c60>] (vfs_write+0x0/0x148) from [<c01612dc>]
(sys_write+0x44/0x70)
 r7:00000549 r6:dead0bc0 r5:00000000 r4:00009000
[<c0161298>] (sys_write+0x0/0x70) from [<c0027400>]
(ret_fast_syscall+0x0/0x2c)
 r8:c00275a8 r7:00000004 r6:0000000d r5:bee23f50 r4:00000549

>Also, you can know the progress of segment writer by specifying the
following debug options,
>
> # echo "-vvv segment -vv seginfo" > /proc/fs/nilfs2/debug_option
>
>This feature is only available on the nilfs2 out-of-tree module built
with CONFIG_NILFS_DEBUG=y >option.

Here's the tail of the syslog with segment and seginfo logging enhanced
as requested:

NILFS(segment) nilfs_segctor_sync: start task=dfd7bac0 seq=159
NILFS(segment) nilfs_segctor_thread: woke 
NILFS(segment) nilfs_segctor_thread: sequence: req=159, done=158,
state=0
NILFS(segment) nilfs_transaction_lock: task c0909820 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_segctor_confirm: Skipped construction (no changes)
NILFS(segment) nilfs_segctor_notify: complete requests from seq=159 to
seq=159
NILFS(segment) nilfs_segctor_wakeup: wakeup task=dfe6fb44 seq=159
NILFS(segment) nilfs_transaction_unlock: task c0909820 unlocked segment
semaphore
NILFS(segment) nilfs_segctor_thread: sequence: req=159, done=159,
state=0
NILFS(segment) nilfs_segctor_sync: done task=dfd7bac0 seq=159 err=0
NILFS(segment) nilfs_transaction_lock: task dfd7bac0 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_transaction_unlock: task dfd7bac0 unlocked segment
semaphore
NILFS(segment) nilfs_segctor_sync: start task=dfd7bac0 seq=160
NILFS(segment) nilfs_segctor_thread: woke 
NILFS(segment) nilfs_segctor_thread: sequence: req=160, done=159,
state=0
NILFS(segment) nilfs_transaction_lock: task c0909820 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_segctor_confirm: Skipped construction (no changes)
NILFS(segment) nilfs_segctor_notify: comion_unlock: task dfd7bac0
unlocked segment semaphore
NILFS(segment) nilfs_transaction_lock: task dfd7bac0 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_transaction_unlock: task dfd7bac0 unlocked segment
semaphore

// Bunch of repeated lock, lock, unlock entries...

NILFS(segment) nilfs_transaction_lock: task dfd7bac0 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_transaction_unlock: task dfd7bac0 unlocked segment
semaphore
NILFS(segment) nilfs_segctor_sync: start task=dfd7bac0 seq=703
NILFS(segment) nilfs_segctor_thread: woke 
NILFS(segment) nilfs_segctor_thread: sequence: req=703, done=702,
state=0
NILFS(segment) nilfs_transaction_lock: task c0909820 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_segctor_confirm: Skipped construction (no changes)
NILFS(segment) nilfs_segctor_notify: complete requests from seq=703 to
seq=703
NILFS(segment) nilfs_segctor_wakeup: wakeup task=dfe6fb44 seq=703
NILFS(segment) nilfs_transaction_unlock: task c0909820 unlocked segment
semaphore
NILFS(segment) nilfs_segctor_thread: sequence: req=703, done=703,
state=0
NILFS(segment) nilfs_segctor_sync: done task=dfd7bac0 seq=703 err=0
NILFS(segment) nilfs_transaction_lock: task dfd7bac0 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_transaction_unlock: task dfd7bac0 unlocked segment
semaphore

// Bunch of repeated lock, lock, unlock entries...

NILFS(segment) nilfs_transaction_lock: task dfd7bac0 locking segment
semaphore
NILFS(segment) nilfs_transaction_lock: locked
NILFS(segment) nilfs_transaction_unlock: task dfd7bac0 unlocked segment
semaphore

// Game over.

As you can see, I've cut out some repeated sections to trim down the
output.  If you need more log info beyond this tail, let me know how
much and how you would like me to pass it to you.

Bill 
