From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/3] nilfs-utils: discard blocks at mkfs time
Date: Mon, 22 Nov 2010 19:24:03 +0900
Message-ID: <1290421443-27679-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1290421443-27679-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290421443-27679-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This add discard support to mkfs.nilfs2 which will be useful to solid
state devices or sparse/thin-provisioned storage.

The updated mkfs.nilfs2 will attempt to discard the device by default
unless -K option is specified.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/mkfs.nilfs2.8 |   11 ++++++
 sbin/mkfs/mkfs.c  |   88 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index fb70c87..e9f7463 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -18,6 +18,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 .B \-c
 ]
 [
+.B \-K
+]
+[
 .B \-L
 .I volume-label
 ]
@@ -52,6 +55,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 .B \-c
 ]
 [
+.B \-K
+]
+[
 .B \-L
 .I volume-label
 ]
@@ -100,6 +106,11 @@ number of blocks per segment is 2048 (= 8MB with 4KB blocks).
 .B \-c
 Check the device for bad blocks before building the filesystem.
 .TP
+.BI \-K
+Keep, do not attempt to discard blocks at mkfs time (discarding blocks
+initially is useful on solid state drives and sparse /
+thinly-provisioned storage).
+.TP
 .BI \-L " new-volume-label"
 Set the volume label for the filesystem to
 .IR new-volume-label\fP.
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 95f4408..092edfd 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -109,6 +109,7 @@ static int quiet = 0;
 static int cflag = 0;
 static int nflag = 0;
 static int verbose = 0;
+static int discard = 1;
 static unsigned long blocksize = NILFS_DEF_BLOCKSIZE;
 static unsigned long blocks_per_segment = NILFS_DEF_BLKS_PER_SEG;
 static unsigned long r_segments_percentage = NILFS_DEF_RESERVED_SEGMENTS;
@@ -288,6 +289,55 @@ static void cannot_allocate_memory(void);
 static void too_small_segment(unsigned long, unsigned long);
 
 /* I/O routines */
+#ifdef __linux__
+
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+#ifndef BLKDISCARDZEROES
+#define BLKDISCARDZEROES _IO(0x12,124)
+#endif
+
+/**
+ * nilfs_mkfs_discard_range - issue discard command to the device
+ * @fd: file descriptor of the device
+ * @start: start offset of the region to discard (in bytes)
+ * @len: length of the region to discard (in bytes)
+ *
+ * Returns zero if the discard succeeds.  Otherwise, -1 is returned.
+ */
+static int nilfs_mkfs_discard_range(int fd, __u64 start, __u64 len)
+{
+	__u64 range[2] = { start, len };
+	int ret;
+
+	ret = ioctl(fd, BLKDISCARD, &range);
+	if (verbose) {
+		pinfo("Discard device from %llu to %llu: %s.",
+		      (unsigned long long)start,
+		      (unsigned long long)start + len,
+		      ret ? "failed" : "succeeded");
+	}
+	return ret;
+}
+
+/**
+ * nilfs_mkfs_discard_zeroes_data - get if discarded blocks are zeroed or not
+ * @fd: file descriptor of the device
+ */
+static int nilfs_mkfs_discard_zeroes_data(int fd)
+{
+	int discard_zeroes_data = 0;
+
+	ioctl(fd, BLKDISCARDZEROES, &discard_zeroes_data);
+	return discard_zeroes_data;
+}
+#else
+#define nilfs_mkfs_discard_range(fd, start, len)	1
+#define nilfs_mkfs_discard_zeroes_data(fd)		0
+#endif
+
 static void disk_scan(const char *device);
 static void check_mount(int fd, const char *device);
 
@@ -760,20 +810,39 @@ static int erase_disk_range(int fd, off_t offset, size_t count)
 
 static int erase_disk(int fd, struct nilfs_disk_info *di)
 {
+	const unsigned int sector_size = 512;
+	off_t start, end;
 	int ret;
 
-	BUG_ON(di->dev_size < NILFS_DISK_ERASE_SIZE ||
-	       di->dev_size - NILFS_DISK_ERASE_SIZE < NILFS_SB_OFFSET_BYTES);
+	/*
+	 * Define range of the partition that nilfs uses.  This should
+	 * not depend on the type of underlying device.
+	 */
+	start = NILFS_SB_OFFSET_BYTES;
+	end = di->dev_size & ~((__u64)sector_size - 1);
+
+	BUG_ON(end < NILFS_DISK_ERASE_SIZE ||
+	       end - NILFS_DISK_ERASE_SIZE < start);
+
+	if (discard) {
+		ret = nilfs_mkfs_discard_range(fd, start, end - start);
+		if (!ret && nilfs_mkfs_discard_zeroes_data(fd)) {
+			if (verbose)
+				pinfo("Discard succeeded and will return 0s "
+				      " - skip wiping");
+			goto out;
+		}
+	}
 
 	/* Erase tail of partition */
-	ret = erase_disk_range(fd, di->dev_size - NILFS_DISK_ERASE_SIZE,
+	ret = erase_disk_range(fd, end - NILFS_DISK_ERASE_SIZE,
 			       NILFS_DISK_ERASE_SIZE);
 	if (ret == 0) {
 		/* Erase head of partition */
-		ret = erase_disk_range(fd, NILFS_SB_OFFSET_BYTES,
-				       NILFS_DISK_ERASE_SIZE -
-				       NILFS_SB_OFFSET_BYTES);
+		ret = erase_disk_range(fd, start,
+				       NILFS_DISK_ERASE_SIZE - start);
 	}
+out:
 	return ret;
 }
 
@@ -877,7 +946,7 @@ static void parse_options(int argc, char *argv[])
 {
 	int c, show_version_only = 0;
 
-	while ((c = getopt(argc, argv, "b:B:cL:m:nqvVP:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:B:cKL:m:nqvVP:")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = atol(optarg);
@@ -889,6 +958,9 @@ static void parse_options(int argc, char *argv[])
 		case 'c':
 			cflag++;
 			break;
+		case 'K':
+			discard = 0;
+			break;
 		case 'L':
 			strncpy(volume_label, optarg, sizeof(volume_label));
 			break;
@@ -945,7 +1017,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] \n"
 		"[-L volume-label] [-m reserved-segments-percentage] \n"
-		"[-nqvV] device\n",
+		"[-nqvKV] device\n",
 		progname);
 	exit(1);
 }
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
