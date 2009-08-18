From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: fix oopses with doubly mounted
	snapshots
Date: Wed, 19 Aug 2009 02:09:30 +0900 (JST)
Message-ID: <20090819.020930.20403462.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

This is a bugfix for nilfs in 2.6.31-rc.

Today, I met kernel oopses after mounted snapshot twice by chance.
This fixes the oopses and a liked memory leak problem.

I'll send this upstream along with other fixes.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Date: Wed, 19 Aug 2009 00:29:43 +0900
Subject: [PATCH] nilfs2: fix oopses with doubly mounted snapshots

will fix kernel oopses like the following:

 # mount -t nilfs2 -r -o cp=20 /dev/sdb1 /test1
 # mount -t nilfs2 -r -o cp=20 /dev/sdb1 /test2
 # umount /test1
 # umount /test2

BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1069
in_atomic(): 0, irqs_disabled(): 1, pid: 3886, name: umount.nilfs2
1 lock held by umount.nilfs2/3886:
 #0:  (&type->s_umount_key#31){+.+...}, at: [<c10b398a>] deactivate_super+0x52/0x6c
irq event stamp: 1219
hardirqs last  enabled at (1219): [<c135c774>] __mutex_unlock_slowpath+0xf8/0x119
hardirqs last disabled at (1218): [<c135c6d5>] __mutex_unlock_slowpath+0x59/0x119
softirqs last  enabled at (1214): [<c1033316>] __do_softirq+0x1a5/0x1ad
softirqs last disabled at (1205): [<c1033354>] do_softirq+0x36/0x5a
Pid: 3886, comm: umount.nilfs2 Not tainted 2.6.31-rc6 #55
Call Trace:
 [<c1023549>] __might_sleep+0x107/0x10e
 [<c13603c0>] do_page_fault+0x246/0x397
 [<c136017a>] ? do_page_fault+0x0/0x397
 [<c135e753>] error_code+0x6b/0x70
 [<c136017a>] ? do_page_fault+0x0/0x397
 [<c104f805>] ? __lock_acquire+0x91/0x12fd
 [<c1050a62>] ? __lock_acquire+0x12ee/0x12fd
 [<c1050a62>] ? __lock_acquire+0x12ee/0x12fd
 [<c1050b2b>] lock_acquire+0xba/0xdd
 [<d0d17d3f>] ? nilfs_detach_segment_constructor+0x2f/0x2fa [nilfs2]
 [<c135d4fe>] down_write+0x2a/0x46
 [<d0d17d3f>] ? nilfs_detach_segment_constructor+0x2f/0x2fa [nilfs2]
 [<d0d17d3f>] nilfs_detach_segment_constructor+0x2f/0x2fa [nilfs2]
 [<c104ea2c>] ? mark_held_locks+0x43/0x5b
 [<c104ecb1>] ? trace_hardirqs_on_caller+0x10b/0x133
 [<c104ece4>] ? trace_hardirqs_on+0xb/0xd
 [<d0d09ac1>] nilfs_put_super+0x2f/0xca [nilfs2]
 [<c10b3352>] generic_shutdown_super+0x49/0xb8
 [<c10b33de>] kill_block_super+0x1d/0x31
 [<c10e6599>] ? vfs_quota_off+0x0/0x12
 [<c10b398f>] deactivate_super+0x57/0x6c
 [<c10c4bc3>] mntput_no_expire+0x8c/0xb4
 [<c10c5094>] sys_umount+0x27f/0x2a4
 [<c10c50c6>] sys_oldumount+0xd/0xf
 [<c10031a4>] sysenter_do_call+0x12/0x38
 ...

This turns out to be a bug brought by an -rc1 patch ("nilfs2: simplify
remaining sget() use").

In the patch, a new "put resource" function, nilfs_put_sbinfo()
was introduced to delay freeing nilfs_sb_info struct.

But the nilfs_put_sbinfo() mistakenly used atomic_dec_and_test()
function to check the reference count, and it caused the nilfs_sb_info
was freed when user mounted a snapshot twice.

This bug also suggests there was unseen memory leak in usual mount
/umount operations for nilfs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index e8adbff..1b9caaf 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -253,7 +253,7 @@ nilfs_detach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 
 static inline void nilfs_put_sbinfo(struct nilfs_sb_info *sbi)
 {
-	if (!atomic_dec_and_test(&sbi->s_count))
+	if (atomic_dec_and_test(&sbi->s_count))
 		kfree(sbi);
 }
 
-- 
1.6.3.4
