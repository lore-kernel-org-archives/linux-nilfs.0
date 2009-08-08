From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: use GFP_NOIO for bio_alloc instead of
	GFP_NOWAIT
Date: Sat, 08 Aug 2009 15:52:27 +0900 (JST)
Message-ID: <20090808.155227.128865710.ryusuke@osrg.net>
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

This is a remaining todo item related to the write failure problem
recently fixed.  This patch would decrease the possibility of memory
allocation failure during log-writing.  I'll queue this for the next
merge window.

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Alberto Bertogli advised me about bio_alloc() use in nilfs:
On Sat, 13 Jun 2009 22:52:40 -0300, Alberto Bertogli wrote:
> By the way, those bio_alloc()s are using GFP_NOWAIT but it looks
> like they could use at least GFP_NOIO or GFP_NOFS, since the caller
> can (and sometimes do) sleep. The only caller is nilfs_submit_bh(),
> which calls nilfs_submit_seg_bio() which can sleep calling
> wait_for_completion().

This takes in the comment and replaces the use of GFP_NOWAIT flag with
GFP_NOIO.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 9e3fe17..e6d9e37 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -316,10 +316,10 @@ static struct bio *nilfs_alloc_seg_bio(struct super_block *sb, sector_t start,
 {
 	struct bio *bio;
 
-	bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+	bio = bio_alloc(GFP_NOIO, nr_vecs);
 	if (bio == NULL) {
 		while (!bio && (nr_vecs >>= 1))
-			bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+			bio = bio_alloc(GFP_NOIO, nr_vecs);
 	}
 	if (likely(bio)) {
 		bio->bi_bdev = sb->s_bdev;
-- 
1.6.3.4
