From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Write hang on ARM based target
Date: Fri, 19 Jun 2009 03:36:42 +0900 (JST)
Message-ID: <20090619.033642.32757627.ryusuke@osrg.net>
References: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900F96@tdpost.td.tandbergdata.com>
	<BAEFA5609CC3AB4BAE1625CAD4C27E5C01900F99@tdpost.td.tandbergdata.com>
	<20090612.132344.17157054.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090612.132344.17157054.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: WDunphy-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Fri, 12 Jun 2009 13:23:44 +0900 (JST), Ryusuke Konishi wrote:
> On Tue, 9 Jun 2009 13:04:04 -0600, "Dunphy, Bill" wrote:
> >  
> > Ryusuke,
> > 
> > I've simplified my test approach by simply copying a single 10 byte file
> > repeatedly.  When doing so, I get consistent NILFS log output at the
> > time of hang.  Examination of /proc/sysreq-trigger also shows the copy
> > process to be in the same state as before (at sys_write).
>
> Thank you for sending me the trace log.  I will look into the problem
> later.
> 
> Ryusuke Konishi

In another thread, I've sent a patch that may cause the hang problem.
Here, I attach the out-of-tree version of the patch.

Does this make a difference in your problem ?

Thanks,
Ryusuke Konishi
--

diff --git a/fs/dat.c b/fs/dat.c
index 036b05d..b05d9d4 100644
--- a/fs/dat.c
+++ b/fs/dat.c
@@ -149,15 +149,6 @@ void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
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
 
diff --git a/fs/segment.c b/fs/segment.c
index 3cbb3fe..225d5ae 100644
--- a/fs/segment.c
+++ b/fs/segment.c
@@ -2009,26 +2009,13 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 		err = nilfs_segbuf_write(segbuf, &wi);
 
 		res = nilfs_segbuf_wait(segbuf, &wi);
-		err = unlikely(err) ? : res;
+		err = unlikely(err) ? err : res;
 		if (unlikely(err))
 			return err;
 	}
 	return 0;
 }
 
-static int nilfs_page_has_uncleared_buffer(struct page *page)
-{
-	struct buffer_head *head, *bh;
-
-	head = bh = page_buffers(page);
-	do {
-		if (buffer_dirty(bh) && !list_empty(&bh->b_assoc_buffers))
-			return 1;
-		bh = bh->b_this_page;
-	} while (bh != head);
-	return 0;
-}
-
 static void __nilfs_end_page_io(struct page *page, int err)
 {
 	if (!err) {
@@ -2056,12 +2043,11 @@ static void nilfs_end_page_io(struct page *page, int err)
 	if (!page)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) &&
-	    nilfs_page_has_uncleared_buffer(page))
-		/* For b-tree node pages, this function may be called twice
-		   or more because they might be split in a segment.
-		   This check assures that cleanup has been done for all
-		   buffers in a split btnode page. */
+	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page))
+		/*
+		 * For b-tree node pages, this function may be called twice
+		 * or more because they might be split in a segment.
+		 */
 		return;
 
 	__nilfs_end_page_io(page, err);
@@ -2125,7 +2111,7 @@ static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
 			}
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, err);
-				if (unlikely(fs_page == failed_page))
+				if (fs_page && fs_page == failed_page)
 					goto done;
 				fs_page = bh->b_page;
 			}
