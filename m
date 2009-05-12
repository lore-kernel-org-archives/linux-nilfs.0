From: Hisashi Hifumi <hifumi.hisashi-gVGce1chcLdL9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] NILFS2: Pagecache usage optimization on NILFS2
Date: Tue, 12 May 2009 10:39:48 +0900
Message-ID: <6.0.0.20.2.20090512102342.07225080@172.19.0.2>
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
To: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I introduced "is_partially_uptodate" aops for NILFS2.

A page can have multiple buffers and even if a page is not uptodate, some buffers 
can be uptodate on pagesize != blocksize environment.
This aops checks that all buffers which correspond to a part of a file 
that we want to read are uptodate. If so, we do not have to issue actual 
read IO to HDD even if a page is not uptodate because the portion we 
want to read are uptodate. 
"block_is_partially_uptodate" function is already used by ext2/3/4.
With the following patch random read/write mixed workloads or random read after 
random write workloads can be optimized and we can get performance improvement.

I did a performance test using the sysbench.

# sysbench --num-threads=16 --max-requests=200000 --test=fileio --file-num=
1 --file-block-size=8K --file-total-size=2G --file-test-mode=rndrw --file-fsync-freq=0 --fil
e-rw-ratio=1 run

-2.6.30-rc5

Test execution summary:
    total time:                          151.2907s
    total number of events:              200000
    total time taken by event execution: 2409.8387
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0120s
         max:                            0.9306s
         approx.  95 percentile:         0.0439s

Threads fairness:
    events (avg/stddev):           12500.0000/238.52
    execution time (avg/stddev):   150.6149/0.01

-2.6.30-rc5-patched

Test execution summary:
    total time:                          140.8828s
    total number of events:              200000
    total time taken by event execution: 2240.8577
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0112s
         max:                            0.8750s
         approx.  95 percentile:         0.0418s

Threads fairness:
    events (avg/stddev):           12500.0000/218.43
    execution time (avg/stddev):   140.0536/0.01


arch: ia64
pagesize: 16k

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi-gVGce1chcLdL9jVzuh4AOg@public.gmane.org>

diff -Nrup linux-2.6.30-rc5.org/fs/nilfs2/inode.c linux-2.6.30-rc5.nilfs/fs/nilfs2/inode.c
--- linux-2.6.30-rc5.org/fs/nilfs2/inode.c	2009-05-11 10:07:15.000000000 +0900
+++ linux-2.6.30-rc5.nilfs/fs/nilfs2/inode.c	2009-05-12 10:22:50.000000000 +0900
@@ -249,6 +249,7 @@ struct address_space_operations nilfs_ao
 	/* .releasepage		= nilfs_releasepage, */
 	.invalidatepage		= block_invalidatepage,
 	.direct_IO		= nilfs_direct_IO,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 struct inode *nilfs_new_inode(struct inode *dir, int mode)
