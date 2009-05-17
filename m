From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: users Digest, Vol 38, Issue 14
Date: Sun, 17 May 2009 22:57:59 +0900 (JST)
Message-ID: <20090517.225759.58884506.ryusuke@osrg.net>
References: <mailman.1.1242356401.18832.users@nilfs.org>
	<20090515103724.5dd3285b@simplux>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090515103724.5dd3285b@simplux>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, mniederle-RbZlAiThDcE@public.gmane.org

Hi,
On Fri, 15 May 2009 10:37:24 +0200, "Dipl.-Ing. Michael Niederle" wrote:
> Hi, Ryusuke!
> > What is your pendrive product?
> 
> I have several pen drives for testing (from Corsair, OCZ, SanDisk). I'm
> currently testing nilfs on a "SanDisk Curzer Contour (16GB)". Initially I used
> kernel 2.6.30rc4, but switched to rc5 recently. The new kernel was build under
> nilfs - quickly and without any problems.

I got a SanDisk Cruzer for tests today.
So far, it works pretty well with nilfs.
 
> The problem of a pen based Linux system is, that it is more likely to be just
> disconnected instead of beeing shutdown cleanly than a desktop system.
>
> Loosing current data will be no problem. Loosing the whole filesystem is a
> big problem ...
> 
> Greetings, Michael

If you have a chance, please apply the following patch.

It issues I/O request with an unplug option at the end of every
segment.  This may have effect of minimizing write order reversal
causing the mount failures.

The patch is against 2.6.30-rc6 (ignore hunks since I'm managing more
patches).

Also, I pushed a variant of the patch to the (standalone)
nilfs2-module git tree, but this option is not supported for
kernel-2.6.28 and the prior versions.


Cheers,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: set bio unplug flag for the last bio in segment

This sets BIO_RW_UNPLUG flag on the last bio of each segment during
write.  The last bio should be unplugged immediately because the
caller waits for the completion after the submission.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.6.2
