From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/5] nilfs2: fix incorrect KERN_CRIT messages
	in case of write failures
Date: Tue,  7 Jul 2009 12:53:10 +0900
Message-ID: <1246938792-14681-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

In case of write-failure retries, the following KERN_CRIT level
messages are mistakenly output by nilfs_dat_commit_start() function:

nilfs_dat_commit_start: vbn = 408463, start = 12506, end = 18446744073709551615, pbn = 530210
nilfs_dat_commit_start: vbn = 408515, start = 12506, end = 18446744073709551615, pbn = 530211
nilfs_dat_commit_start: vbn = 408464, start = 12506, end = 18446744073709551615, pbn = 530212
...

This suppresses these messages.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 fs/nilfs2/dat.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 0b2710e..8927ca2 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -134,15 +134,6 @@ void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(nilfs_mdt_cno(dat));
-	if (entry->de_blocknr != cpu_to_le64(0) ||
-	    entry->de_end != cpu_to_le64(NILFS_CNO_MAX)) {
-		printk(KERN_CRIT
-		       "%s: vbn = %llu, start = %llu, end = %llu, pbn = %llu\n",
-		       __func__, (unsigned long long)req->pr_entry_nr,
-		       (unsigned long long)le64_to_cpu(entry->de_start),
-		       (unsigned long long)le64_to_cpu(entry->de_end),
-		       (unsigned long long)le64_to_cpu(entry->de_blocknr));
-	}
 	entry->de_blocknr = cpu_to_le64(blocknr);
 	kunmap_atomic(kaddr, KM_USER0);
 
-- 
1.6.3.3
