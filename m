From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: silent random symbolic link corruption
Date: Mon, 09 Mar 2009 00:45:55 +0900 (JST)
Message-ID: <20090309.004555.56048618.ryusuke@osrg.net>
References: <49872E1E.4090209@prnet.org> <49875F16.7060107@prnet.org>
	<20090308.153730.64866441.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090308.153730.64866441.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

On Sun, 08 Mar 2009 15:37:30 +0900 (JST), Ryusuke Konishi wrote:
> Some filesystems including ext3 and nilfs2, do not support nano-second
> timestamps on disk, so nano-second mtime values have possibility to
> reset to zero when flushed from memory.  This is the reason why you
> saw the problem randomly.
> 
> The solution for this is
> 
>  1) supporting nano second time-stamps.
>  2) changing tar program to stop comparison of nano-second time values
>  3) changing tar to stop the comparison if underlying filesystem
>     does not support the resolution.
> 
> The solution 1 suffers compatiblity problem for filesystems.
> Maybe nilfs should support nano second timestamps, but the inode of
> nilfs is unfortunately short 32-bits for this. :(
> 
> If I can allot one 64-bit field of the btree root array, this can be
> possible. But it breaks the compatibility.  Another candidate is an
> unused 64-bit field reserved for extended attribute. But I'd like to
> reserve it as is because it is enough important. So it's thorny.
> 
> The solution 3 requires a new kernel interface. Actually this was 
> discussed recently in the kernel mailing list, but it's unconcluded.
> 
> I don't know why the tar requires such intermediate file, but the 3
> seems required at the thought of conventional file systems.

I've found the cause of this problem in timestamp initialization of
on-memory nilfs inode.  It initialized timestamps with valid nano
second values even though nilfs does not support it on disk.

It seems not to be a tar problem, and maybe properly handled file
systems (e.g. ext3) does not suffer the problem.

By applying the following patch, this problem may be solved.

However, I'd like to support nano-second timestamp in the next release
in the way I wrote in the previous mail.  I think the high resolution
timestamp is an important feature for file systems of today.

Regards,
Ryusuke Konishi

diff --git a/fs/inode.c b/fs/inode.c
index 46b24e5..3d39dff 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -355,7 +355,7 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	inode->i_blksize = PAGE_SIZE;	/* This is the optimal IO size
 					   (for stat), not fs block size */
 #endif
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)) {
 		err = nilfs_bmap_read(ii->i_bmap, NULL);
