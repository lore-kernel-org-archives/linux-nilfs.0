From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Pause intervals when copying/extracting an archive
Date: Sat, 06 Jun 2009 04:56:53 +0900 (JST)
Message-ID: <20090606.045653.133237039.ryusuke@osrg.net>
References: <20090516171555.GA21962@nezmer.homelinux.org>
	<20090517.122816.105794011.ryusuke@osrg.net>
	<20090605193256.GA3663@nezmer.homelinux.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090605193256.GA3663-JEps/AmnTFO/RHH9vPZxQGD2FQJk+8+b@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Fri, 5 Jun 2009 22:32:56 +0300, nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> Sorry for the late reply .
> 
> I tried to use deplock but I always get this :
> SysRq : Show Locks Held
> INFO: lockdep is turned off.
> 
> sysrq t works . I hope the attached file will be helpful .

Thanks for the log!

According to you log, the performance problem seems to be caused
by a wait function in segment constructor of nilfs.

If you have a chance, please try the following coupled patch which
comes from two patches queued for 2.6.31.  The upper half of the patch
greatly improves read performance, and the lower part may have effect
on the write performance.

Regards,
Ryusuke Konishi
---
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 3f70eed..f25fd4b 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -240,7 +240,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 struct address_space_operations nilfs_aops = {
 	.writepage		= nilfs_writepage,
 	.readpage		= nilfs_readpage,
-	/* .sync_page		= nilfs_sync_page, */
+	.sync_page		= block_sync_page,
 	.writepages		= nilfs_writepages,
 	.set_page_dirty		= nilfs_set_page_dirty,
 	.readpages		= nilfs_readpages,
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc0277a..9e3fe17 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -393,7 +393,7 @@ int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 		 * Last BIO is always sent through the following
 		 * submission.
 		 */
-		rw |= (1 << BIO_RW_SYNCIO);
+		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 		res = nilfs_submit_seg_bio(wi, rw);
 		if (unlikely(res))
 			goto failed_bio;
