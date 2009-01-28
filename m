From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: NilFS cleanerd bugreport
Date: Wed, 28 Jan 2009 21:52:23 +0100
Message-ID: <20090128205223.GA416@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
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
To: "nilfs.org" <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Dear folks, dear Ryusuke,

I've found a bug in the cleanerd/nilfs interaction that might give rise to the
various problems we've seen recently with the cleanerd. It comes down to the
wrong counting of the number of dirty segments and the wrong counting of the
number of checkpoints.

I created this disc using the NiLFS version 2.05 with 2.06 userland (AFAIK)
with mkfs.nilfs and created a sparse file on it with my sparse file generator
I created for UDF testing. It dismounted fine giving a nilfs_dump
`vnd0e-dump-3'. When i remounted it again, the cleanerd started after a while
and after unmounting it gives `vnd03-dump-3-cleanerd'. A diff shows:

(superblock)
--- /root/luiaard/root/vnd0e-dump-3	2009-01-25 17:10:22.000000000 +0100
+++ /root/luiaard/root/vnd0e-dump-3-cleanerd	2009-01-28 17:24:07.000000000 +0100
@@ -7,7 +7,7 @@
 
 	Flags                       0x0000
 	CRC seed                    0xd4dd3d5a
-	Checksum (CRC)              0x05ec6c58 (OK)
+	Checksum (CRC)              0xddd0a2f7 (OK)
 
 	Blocksize                   4096
 	Number of segments          499
@@ -17,15 +17,15 @@
 	Blocks per segment          2048
 	Reserved segments percent   5
 
-	Last checkpoint number      8
-	Last pseg blocknr writen    12288
+	Last checkpoint number      11
+	Last pseg blocknr writen    13726
 	Seq. number last segment    6
-	Free blocks count           1005568
+	Free blocks count           1015808
 	FS Creation time            Sun Jan 25 17:05:10 2009
-	FS last mount time          Sun Jan 25 17:05:14 2009
-	FS last write time          Sun Jan 25 17:06:02 2009
+	FS last mount time          Wed Jan 28 17:21:25 2009
+	FS last write time          Wed Jan 28 17:21:44 2009
 
-	Mount count                 1
+	Mount count                 2
 	Max mount count             50
 	FS state                    0x1<VALID_FS>
 	Error behaviour flags       0x0001


And the su and cp files give:

@@ -30743,34 +31480,34 @@
 Reading file `SU.out` for 1 blocks (4 Kb)
 
 	SU file dump
-		nclean       491
-		ndirty       8
+		nclean       496
+		ndirty       21474836483
 		last alloced 7
 
 		Segment 0
-		Last modified Sun Jan 25 17:05:28 2009
-		Containing nblks 2047
-		Flags            0x2<DIRTY>
+		Last modified Thu Jan  1 01:00:00 1970
+		Containing nblks 0
+		Flags            0x0

......

@@ -30789,136 +31526,72 @@
 
 Reading file `CP.out` for 1 blocks (4 Kb)
 	CP file dump
-		Number of checkpoints 8
+		Number of checkpoints 8589934596
 		Number of snapshots   0
 
 		Checkpoint number    1
-		Flags                0x0
+		Flags                0x2<INVALID>
 		Checkpoints in block 0
 		Created at Sun Jan 25 17:05:10 2009
 		Blocks incremented   11
 		Inodes count         3
 		Blocks count (red.)  9

---------------------

ny idea as to if and why this can happen? Has it been fixed in the meantime?
or could this be a clue as to the wierd behaviour seen by others including the
corruption?

With regards,
Reinoud
