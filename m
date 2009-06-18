From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] nilfs2: fix hang problem after bio_alloc() failed
Date: Fri, 19 Jun 2009 02:34:55 +0900 (JST)
Message-ID: <20090619.023455.111674749.ryusuke@osrg.net>
References: <20090614153256.GA4020@homero.springfield.home>
	<20090615.030245.104791670.konishi.ryusuke@gmail.com>
	<20090614181313.GA16597@homero.springfield.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756534AbZFRRfX@vger.kernel.org>
In-Reply-To: <20090614181313.GA16597@homero.springfield.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Leandro Lucarella <llucax@gmail.com>
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org, albertito@blitiri.com.ar, users@nilfs.org

Hi Leandro,
On Sun, 14 Jun 2009 15:13:13 -0300, Leandro Lucarella wrote:
> Ryusuke Konishi, el 15 de junio a las 03:02 me escribiste:
> [snip]
> > > Here is the complete trace:
> > > http://pastebin.lugmen.org.ar/4931
> > 
> > Thank you for your help.
> > 
> > According to your log, there seems to be a leakage in clear processing
> > of the writeback flag on pages.  I will review the error path of log
> > writer to narrow down the cause.

Here is a patch that hopefully fixes the hang problem after
bio_alloc() failed.  This is composed of three separate patches, but I
now attach them together.

If you still see problems with it, please let me know.
 
> Oh! I forgot to tell you that the cleanerd process was not running. When
> I mounted the NILFS2 filesystem the cleanerd daemon said:
> 
> nilfs_cleanerd[29534]: start
> nilfs_cleanerd[29534]: cannot create cleanerd on /dev/loop0
> nilfs_cleanerd[29534]: shutdown
> 
> I thought I might have an old utilities version and that could be because
> of that (since the nilfs website was down I couldn't check), but now
> I checked in the backup nilfs website that latest version is 2.0.12 and
> I have that (Debian package), so I don't know why the cleanerd failed to
> start in the first place.

The message indicates that initialization of the cleanerd failed.

I don't know for sure, but another memory allocation failure might
cause it.

Thanks,
Ryusuke Konishi
---
Ryusuke Konishi (3):
      nilfs2: fix mis-conversion of error code by unlikely directive
      nilfs2: fix hang problem of log writer that follows on write failures
      nilfs2: remove incorrect warning in nilfs_dat_commit_start function

 fs/nilfs2/dat.c     |    9 ---------
 fs/nilfs2/segment.c |   28 +++++++---------------------
 2 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index bb8a581..e2646c3 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
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
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 22c7f65..e8f188b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1846,26 +1846,13 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
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
@@ -1889,12 +1876,11 @@ static void nilfs_end_page_io(struct page *page, int err)
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
@@ -1957,7 +1943,7 @@ static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
 			}
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, err);
-				if (unlikely(fs_page == failed_page))
+				if (fs_page && fs_page == failed_page)
 					goto done;
 				fs_page = bh->b_page;
 			}
-- 
1.6.2
