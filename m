From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: fix missing zero-fill initialization
 of btree node cache
Date: Mon, 28 Sep 2009 11:56:17 +0900 (JST)
Message-ID: <20090928.115617.39789094.ryusuke@osrg.net>
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

Hi folks,

I found a bug which is guessed to be the cause of file system
corruption after mount.  The following patch is the bugfix.

If you have experienced the problem, please try this patch.

I made it for the mainline kernel; if you apply it to the standalone
module, do as follows:

 $ cd nilfs2-module/fs
 $ patch -p3 < path-to-the-patch

I will send it upstream after some tests.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix missing zero-fill initialization of btree node cache

This will fix file system corruption which infrequently happens after
mount.  The problem was reported from users with the title "[NILFS
users] Fail to mount NILFS." (Message-ID:
<200908211918.34720.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>), and so forth.  I've also
experienced the corruption multiple times on kernel 2.6.30 and 2.6.31.

The problem turned out to be caused due to discordance between
mapping->nrpages of a btree node cache and the actual number of pages
hung on the cache; if the mapping->nrpages becomes zero even as it has
pages, truncate_inode_pages() returns without doing anything.  Usually
this is harmless except it may cause page leak, but garbage collection
fairly infrequently sees a stale page remained in the btree node cache
of DAT (i.e. disk address translation file of nilfs), thus the
corruption is induced.

I found a missing zero-fill initialization of btree node caches was
the root cause.  This corrects the bug.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 6a2711f..5941958 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -36,6 +36,7 @@
 
 void nilfs_btnode_cache_init_once(struct address_space *btnc)
 {
+	memset(btnc, 0, sizeof(*btnc));
 	INIT_RADIX_TREE(&btnc->page_tree, GFP_ATOMIC);
 	spin_lock_init(&btnc->tree_lock);
 	INIT_LIST_HEAD(&btnc->private_list);
