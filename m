From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 21/23] nilfs2: flush palloc cache before
	manipulating data pages of GC dat
Date: Sun, 15 Nov 2009 21:46:59 +0900
Message-ID: <1258289221-3827-22-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

Data pages in gcdat metadata file (i.e. the secondary DAT for GC), are
cleared or even moved back to the normal DAT when a shot of garbage
collection was done.

Buffer heads held by the palloc cache of gcdat must be cleared before
these page cache manipulation.  This adds nilfs_palloc_clear_cache()
to ensure this.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/gcdat.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/gcdat.c b/fs/nilfs2/gcdat.c
index 93383c5..dd5f7e0 100644
--- a/fs/nilfs2/gcdat.c
+++ b/fs/nilfs2/gcdat.c
@@ -61,6 +61,8 @@ void nilfs_commit_gcdat_inode(struct the_nilfs *nilfs)
 
 	nilfs_bmap_commit_gcdat(gii->i_bmap, dii->i_bmap);
 
+	nilfs_palloc_clear_cache(dat);
+	nilfs_palloc_clear_cache(gcdat);
 	nilfs_clear_dirty_pages(mapping);
 	nilfs_copy_back_pages(mapping, gmapping);
 	/* note: mdt dirty flags should be cleared by segctor. */
@@ -79,6 +81,7 @@ void nilfs_clear_gcdat_inode(struct the_nilfs *nilfs)
 	gcdat->i_state = I_CLEAR;
 	gii->i_flags = 0;
 
+	nilfs_palloc_clear_cache(gcdat);
 	truncate_inode_pages(gcdat->i_mapping, 0);
 	truncate_inode_pages(&gii->i_btnode_cache, 0);
 }
-- 
1.6.3.4
