From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: add sufile function that can
	modify multiple segment usages
Date: Mon, 18 May 2009 00:29:44 +0900
Message-ID: <1242574186-21554-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242574186-21554-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1242574186-21554-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This is a preparation for the later cleanup patch ("nilfs2: remove
list of freeing segments").

This adds nilfs_sufile_updatev() to sufile, which can modify multiple
segment usages at a time.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/sufile.h |    4 ++
 2 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 98e6867..e968913 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -17,7 +17,8 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * Written by Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>.
+ * Written by Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>
+ * Rivised by Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>.
  */
 
 #include <linux/kernel.h>
@@ -108,6 +109,102 @@ static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
 	nilfs_mdt_mark_buffer_dirty(header_bh);
 }
 
+/**
+ * nilfs_sufile_updatev - modify multiple segment usages at a time
+ * @sufile: inode of segment usage file
+ * @segnumv: array of segment numbers
+ * @nsegs: size of @segnumv array
+ * @create: creation flag
+ * @ndone: place to store number of modified segments on @segnumv
+ * @dofunc: primitive operation for the update
+ *
+ * Description: nilfs_sufile_updatev() repeatedly calls @dofunc
+ * against the given array of segments.  The @dofunc is called with
+ * buffers of a header block and the sufile block in which the target
+ * segment usage entry is contained.  If @ndone is given, the number
+ * of successfully modified segments from the head is stored in the
+ * place @ndone points to.
+ *
+ * Return Value: On success, zero is returned.  On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - Given segment usage is in hole block (may be returned if
+ *            @create is zero)
+ *
+ * %-EINVAL - Invalid segment usage number
+ */
+int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
+			 int create, size_t *ndone,
+			 void (*dofunc)(struct inode *, __u64,
+					struct buffer_head *,
+					struct buffer_head *))
+{
+	struct buffer_head *header_bh, *bh;
+	unsigned long blkoff, prev_blkoff;
+	__u64 *seg;
+	size_t nerr = 0, n = 0;
+	int ret = 0;
+
+	if (unlikely(nsegs == 0))
+		goto out;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+	for (seg = segnumv; seg < segnumv + nsegs; seg++) {
+		if (unlikely(*seg >= nilfs_sufile_get_nsegments(sufile))) {
+			printk(KERN_WARNING
+			       "%s: invalid segment number: %llu\n", __func__,
+			       (unsigned long long)*seg);
+			nerr++;
+		}
+	}
+	if (nerr > 0) {
+		ret = -EINVAL;
+		goto out_sem;
+	}
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+
+	seg = segnumv;
+	blkoff = nilfs_sufile_get_blkoff(sufile, *seg);
+	ret = nilfs_mdt_get_block(sufile, blkoff, create, NULL, &bh);
+	if (ret < 0)
+		goto out_header;
+
+	for (;;) {
+		dofunc(sufile, *seg, header_bh, bh);
+
+		if (++seg >= segnumv + nsegs)
+			break;
+		prev_blkoff = blkoff;
+		blkoff = nilfs_sufile_get_blkoff(sufile, *seg);
+		if (blkoff == prev_blkoff)
+			continue;
+
+		/* get different block */
+		brelse(bh);
+		ret = nilfs_mdt_get_block(sufile, blkoff, create, NULL, &bh);
+		if (unlikely(ret < 0))
+			goto out_header;
+	}
+	brelse(bh);
+
+ out_header:
+	n = seg - segnumv;
+	brelse(header_bh);
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+ out:
+	if (ndone)
+		*ndone = n;
+	return ret;
+}
+
 int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
 			void (*dofunc)(struct inode *, __u64,
 				       struct buffer_head *,
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index a2e2efd..e8e2627 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -46,6 +46,10 @@ int nilfs_sufile_get_ncleansegs(struct inode *, unsigned long *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, struct nilfs_suinfo *,
 				size_t);
 
+int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
+			 void (*dofunc)(struct inode *, __u64,
+					struct buffer_head *,
+					struct buffer_head *));
 int nilfs_sufile_update(struct inode *, __u64, int,
 			void (*dofunc)(struct inode *, __u64,
 				       struct buffer_head *,
-- 
1.6.2
