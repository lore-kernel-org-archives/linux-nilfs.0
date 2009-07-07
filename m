From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/5] nilfs2: fix lockdep warning between
	regular file and inode file
Date: Tue,  7 Jul 2009 12:53:11 +0900
Message-ID: <1246938792-14681-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1246938792-14681-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1246938792-14681-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This will fix the following false positive of recursive locking which
lockdep has detected:

=============================================
[ INFO: possible recursive locking detected ]
2.6.30-nilfs #42
---------------------------------------------
nilfs_cleanerd/10607 is trying to acquire lock:
 (&bmap->b_sem){++++-.}, at: [<e0d025b7>] nilfs_bmap_lookup_at_level+0x1a/0x74 [nilfs2]

but task is already holding lock:
 (&bmap->b_sem){++++-.}, at: [<e0d024e0>] nilfs_bmap_truncate+0x19/0x6a [nilfs2]
other info that might help us debug this:
2 locks held by nilfs_cleanerd/10607:
 #0:  (&nilfs->ns_segctor_sem){++++.+}, at: [<e0d0d75a>] nilfs_transaction_begin+0xb6/0x10c [nilfs2]
 #1:  (&bmap->b_sem){++++-.}, at: [<e0d024e0>] nilfs_bmap_truncate+0x19/0x6a [nilfs2]

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 36df60b..99d58a0 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -568,6 +568,7 @@ void nilfs_bmap_abort_update_v(struct nilfs_bmap *bmap,
 }
 
 static struct lock_class_key nilfs_bmap_dat_lock_key;
+static struct lock_class_key nilfs_bmap_mdt_lock_key;
 
 /**
  * nilfs_bmap_read - read a bmap from an inode
@@ -603,7 +604,11 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 		bmap->b_ptr_type = NILFS_BMAP_PTR_VS;
 		bmap->b_last_allocated_key = 0;
 		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_mdt_lock_key);
 		break;
+	case NILFS_IFILE_INO:
+		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_mdt_lock_key);
+		/* Fall through */
 	default:
 		bmap->b_ptr_type = NILFS_BMAP_PTR_VM;
 		bmap->b_last_allocated_key = 0;
-- 
1.6.3.3
