From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: add sync_page method to page
	caches of meta data
Date: Mon,  8 Jun 2009 15:07:17 +0900
Message-ID: <1244441239-20032-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244441239-20032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1244441239-20032-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This applies block_sync_page() function to the sync_page method of
page caches for meta data files, gc page caches, and btree node
buffers.  This is a companion patch of ("nilfs2: enable sync_page
mothod") which applied the function for data pages.

This allows lock_page() for those meta data to unplug pending bio
requests.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c  |    4 +++-
 fs/nilfs2/gcinode.c |    5 +++--
 fs/nilfs2/mdt.c     |    1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 0e01957..7e0b61b 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -46,7 +46,9 @@ void nilfs_btnode_cache_init_once(struct address_space *btnc)
 	INIT_LIST_HEAD(&btnc->i_mmap_nonlinear);
 }
 
-static struct address_space_operations def_btnode_aops;
+static struct address_space_operations def_btnode_aops = {
+	.sync_page		= block_sync_page,
+};
 
 void nilfs_btnode_cache_init(struct address_space *btnc,
 			     struct backing_dev_info *bdi)
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 19d2102..1b3c2bb 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -52,8 +52,9 @@
 #include "dat.h"
 #include "ifile.h"
 
-static struct address_space_operations def_gcinode_aops = {};
-/* XXX need def_gcinode_iops/fops? */
+static struct address_space_operations def_gcinode_aops = {
+	.sync_page		= block_sync_page,
+};
 
 /*
  * nilfs_gccache_submit_read_data() - add data buffer and submit read request
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 9b149a1..a5cd801 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -434,6 +434,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 
 static struct address_space_operations def_mdt_aops = {
 	.writepage		= nilfs_mdt_write_page,
+	.sync_page		= block_sync_page,
 };
 
 static struct inode_operations def_mdt_iops;
-- 
1.6.2
