From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/3] nilfs-utils: get rid of mkfs_options structure
Date: Mon, 22 Nov 2010 19:24:01 +0900
Message-ID: <1290421443-27679-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This moves out variables stored in mkfs_options structure to global
area and removes the structure for simplicity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/mkfs.c |  191 +++++++++++++++++++++++------------------------------
 1 files changed, 83 insertions(+), 108 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index a281c8e..03d7415 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -99,30 +99,23 @@ static const char badblocks[] = "/sbin/" BADBLOCKS_NAME;
  */
 #define _MI_  "\n       "   /* Message indent */
 
-struct mkfs_options {
-	long blocksize;
-	long blocks_per_segment;
-	long r_segments_percentage;
-	int quiet, cflag, nflag;
-	time_t ctime;
-	char volume_label[80];
-};
-
 extern char *optarg;
 extern int optind;
 
 char *progname = "mkfs.nilfs2";
 
-struct mkfs_options options = {
-	.blocksize = NILFS_DEF_BLOCKSIZE,
-	.blocks_per_segment = NILFS_DEF_BLKS_PER_SEG,
-	.r_segments_percentage = NILFS_DEF_RESERVED_SEGMENTS,
-	.quiet = 0,
-	.cflag = 0,
-	.nflag = 0,
-};
+/* Options */
+static int quiet = 0;
+static int cflag = 0;
+static int nflag = 0;
+static unsigned long blocksize = NILFS_DEF_BLOCKSIZE;
+static unsigned long blocks_per_segment = NILFS_DEF_BLKS_PER_SEG;
+static unsigned long r_segments_percentage = NILFS_DEF_RESERVED_SEGMENTS;
 
-static void parse_options(int argc, char *argv[], struct mkfs_options *opts);
+static time_t creation_time = 0;
+static char volume_label[80] = {0};
+
+static void parse_options(int argc, char *argv[]);
 
 
 /*
@@ -184,8 +177,6 @@ struct nilfs_segment_info {
 };
 
 /* Disk layout information */
-static long blocksize;
-
 struct nilfs_disk_info {
 	const char      *device;
 	__u64           dev_size;
@@ -214,9 +205,8 @@ struct nilfs_segment_ref {
 	__u64 cno;                /* checkpoint number */
 };
 
-static void init_disk_layout(struct nilfs_disk_info *, int, const char *,
-			     struct mkfs_options *);
-
+static void init_disk_layout(struct nilfs_disk_info *di, int fd,
+			     const char *device);
 
 static inline blocknr_t count_free_blocks(struct nilfs_disk_info *di)
 {
@@ -237,22 +227,21 @@ segment_start_blocknr(struct nilfs_disk_info *di, unsigned long segnum)
 static void **disk_buffer = NULL;
 static unsigned long disk_buffer_size;
 
-static void init_disk_buffer(long);
+static void init_disk_buffer(long max_blocks);
 static void destroy_disk_buffer(void);
-static void *map_disk_buffer(blocknr_t, int);
+static void *map_disk_buffer(blocknr_t blocknr, int clear_flag);
 
-static void read_disk_header(int, const char *);
-static void write_disk(int, struct nilfs_disk_info *, struct mkfs_options *);
+static void read_disk_header(int fd, const char *device);
+static void write_disk(int fd, struct nilfs_disk_info *di);
 
 /*
  * Routines to format blocks
  */
 static struct nilfs_super_block *raw_sb;
 
-static void prepare_super_block(struct nilfs_disk_info *,
-				struct mkfs_options *);
-static void commit_super_block(struct nilfs_disk_info *,
-			       const struct nilfs_segment_ref *);
+static void prepare_super_block(struct nilfs_disk_info *di);
+static void commit_super_block(struct nilfs_disk_info *di,
+			       const struct nilfs_segment_ref *segref);
 
 struct nilfs_fs_info {
 	struct nilfs_disk_info *diskinfo;
@@ -273,7 +262,7 @@ struct nilfs_fs_info {
 
 static struct nilfs_fs_info nilfs;
 
-static void init_nilfs(struct nilfs_disk_info *);
+static void init_nilfs(struct nilfs_disk_info *di);
 static void prepare_segment(struct nilfs_segment_info *);
 static void commit_segment(void);
 static void make_rootdir(void);
@@ -298,16 +287,15 @@ static void cannot_allocate_memory(void);
 static void too_small_segment(unsigned long, unsigned long);
 
 /* I/O routines */
-static void disk_scan(const char *, struct mkfs_options *);
-static void check_mount(int, const char *);
+static void disk_scan(const char *device);
+static void check_mount(int fd, const char *device);
 
 
 /*
  * Routines to decide disk layout
  */
-static unsigned
-count_blockgrouped_file_blocks(long blocksize, unsigned entry_size,
-			       unsigned nr_initial_entries)
+static unsigned count_blockgrouped_file_blocks(unsigned entry_size,
+					       unsigned nr_initial_entries)
 {
 	unsigned long entries_per_block = blocksize / entry_size;
 
@@ -315,13 +303,12 @@ count_blockgrouped_file_blocks(long blocksize, unsigned entry_size,
 		ROUNDUP_DIV(nr_initial_entries, entries_per_block);
 }
 
-static unsigned count_ifile_blocks(long blocksize)
+static unsigned count_ifile_blocks(void)
 {
 	unsigned long entries_per_group = blocksize * 8; /* CHAR_BIT */
 	unsigned nblocks;
 
-	nblocks = count_blockgrouped_file_blocks(blocksize,
-						 sizeof(struct nilfs_inode),
+	nblocks = count_blockgrouped_file_blocks(sizeof(struct nilfs_inode),
 						 NILFS_MAX_INITIAL_INO);
 	if (NILFS_MAX_INITIAL_INO > entries_per_group ||
 	    nblocks > NILFS_MAX_BMAP_ROOT_PTRS)
@@ -329,7 +316,7 @@ static unsigned count_ifile_blocks(long blocksize)
 	return nblocks;
 }
 
-static unsigned count_sufile_blocks(long blocksize)
+static unsigned count_sufile_blocks(void)
 {
 	unsigned long sufile_segment_usages_per_block
 		= blocksize / sizeof(struct nilfs_segment_usage);
@@ -338,7 +325,7 @@ static unsigned count_sufile_blocks(long blocksize)
 			   sufile_segment_usages_per_block);
 }
 
-static unsigned count_cpfile_blocks(long blocksize)
+static unsigned count_cpfile_blocks(void)
 {
 	const unsigned nr_initial_checkpoints = 1;
 	unsigned long cpfile_checkpoints_per_block
@@ -349,13 +336,13 @@ static unsigned count_cpfile_blocks(long blocksize)
 			   cpfile_checkpoints_per_block);
 }
 
-static unsigned count_dat_blocks(long blocksize, unsigned nr_dat_entries)
+static unsigned count_dat_blocks(unsigned nr_dat_entries)
 {
 	unsigned long entries_per_group = blocksize * 8; /* CHAR_BIT */
 	unsigned nblocks;
 
 	nblocks = count_blockgrouped_file_blocks(
-		blocksize, sizeof(struct nilfs_dat_entry), nr_dat_entries);
+		sizeof(struct nilfs_dat_entry), nr_dat_entries);
 	if (nr_dat_entries > entries_per_group ||
 	    nblocks > NILFS_MAX_BMAP_ROOT_PTRS)
 		perr("Internal error: too many initial dat entries");
@@ -375,8 +362,8 @@ static void nilfs_check_ondisk_sizes(void)
 }
 
 static unsigned long
-__increment_segsum_size(unsigned long offset, long blocksize, 
-			unsigned item_size, unsigned count)
+__increment_segsum_size(unsigned long offset, unsigned item_size,
+			unsigned count)
 {
 	unsigned long offset2;
 	unsigned rest_items_in_block =
@@ -395,16 +382,15 @@ __increment_segsum_size(unsigned long offset, long blocksize,
 	return offset2;
 }
 
-static void
-increment_segsum_size(struct nilfs_segment_info *si, long blocksize,
-		      unsigned nblocks_in_file, int dat_flag)
+static void increment_segsum_size(struct nilfs_segment_info *si,
+				  unsigned nblocks_in_file, int dat_flag)
 {
 	unsigned binfo_size = dat_flag ? 
 		sizeof(__le64) /* offset */ : sizeof(struct nilfs_binfo_v);
 
-	si->sumbytes = __increment_segsum_size(si->sumbytes, blocksize,
+	si->sumbytes = __increment_segsum_size(si->sumbytes,
 					       sizeof(struct nilfs_finfo), 1);
-	si->sumbytes = __increment_segsum_size(si->sumbytes, blocksize,
+	si->sumbytes = __increment_segsum_size(si->sumbytes,
 					       binfo_size, nblocks_in_file);
 }
 
@@ -424,9 +410,8 @@ static unsigned long nilfs_min_nsegments(struct nilfs_disk_info *di, long rp)
 		max_t(unsigned long, nr_initial_segments, NILFS_MIN_NUSERSEGS);
 }
 
-static void
-init_disk_layout(struct nilfs_disk_info *di, int fd, const char *device,
-		 struct mkfs_options *opts)
+static void init_disk_layout(struct nilfs_disk_info *di, int fd,
+			     const char *device)
 {
 	__u64 dev_size;
 	time_t nilfs_time = time(NULL);
@@ -446,14 +431,14 @@ init_disk_layout(struct nilfs_disk_info *di, int fd, const char *device,
 
 	di->device = device;
 	di->dev_size = dev_size;
-	di->blkbits = my_log2(opts->blocksize);
-	di->ctime = (opts->ctime ? : nilfs_time);
+	di->blkbits = my_log2(blocksize);
+	di->ctime = (creation_time ? : nilfs_time);
 	srand48(nilfs_time);
 	di->crc_seed = (__u32)mrand48();
 
-	di->blocks_per_segment = opts->blocks_per_segment;
-	segment_size = di->blocks_per_segment * opts->blocksize;
-	first_segblk = ROUNDUP_DIV(NILFS_DISKHDR_SIZE, opts->blocksize);
+	di->blocks_per_segment = blocks_per_segment;
+	segment_size = di->blocks_per_segment * blocksize;
+	first_segblk = ROUNDUP_DIV(NILFS_DISKHDR_SIZE, blocksize);
 	di->first_segment_block = first_segblk;
 	if (first_segblk + NILFS_PSEG_MIN_BLOCKS > di->blocks_per_segment)
 		too_small_segment(di->blocks_per_segment,
@@ -461,7 +446,7 @@ init_disk_layout(struct nilfs_disk_info *di, int fd, const char *device,
 
 	di->nsegments = (NILFS_SB2_OFFSET_BYTES(dev_size) >> di->blkbits) /
 		di->blocks_per_segment;
-	min_nsegments = nilfs_min_nsegments(di, opts->r_segments_percentage);
+	min_nsegments = nilfs_min_nsegments(di, r_segments_percentage);
 	if (di->nsegments < min_nsegments)
 		perr("Error: too small device."
 		     _MI_ "device size=%llu bytes, required size=%llu bytes."
@@ -535,7 +520,7 @@ static void add_file(struct nilfs_segment_info *si, ino_t ino,
 	si->nblocks += nblocks;
 	if (nblocks > 0) {
 		si->nfinfo++;
-		increment_segsum_size(si, blocksize, nblocks, dat_flag);
+		increment_segsum_size(si, nblocks, dat_flag);
 		if (!dat_flag)
 			si->nvblocknrs += nblocks;
 		si->nblk_sum = ROUNDUP_DIV(si->sumbytes, blocksize);
@@ -546,29 +531,26 @@ static void add_file(struct nilfs_segment_info *si, ino_t ino,
 int main(int argc, char *argv[])
 {
 	struct nilfs_disk_info diskinfo, *di = &diskinfo;
-	struct mkfs_options *opts = &options;
 	struct nilfs_segment_info *si;
 	struct stat statbuf;
 	const char *device;
 	int fd;
 
-	parse_options(argc, argv, opts);
+	parse_options(argc, argv);
 	device = argv[optind];
 
-	blocksize = opts->blocksize;
-
 	if (stat(device, &statbuf) != 0)
 		perr("Error: cannot find %s: %s", device, strerror(errno));
 	else if (!S_ISREG(statbuf.st_mode) && !S_ISBLK(statbuf.st_mode))
 		perr("Error: device must be a block device or a file");
 
-	if (opts->cflag)
-		disk_scan(device, opts);  /* check the block device */
+	if (cflag)
+		disk_scan(device);  /* check the block device */
 	if ((fd = open(device, O_RDWR)) < 0)
 		perr("Error: cannot open device: %s", device);
 	check_mount(fd, device);
 
-	init_disk_layout(di, fd, device, opts);
+	init_disk_layout(di, fd, device);
 	si = new_segment(di);
 
 	add_file(si, NILFS_ROOT_INO, 1, 0);
@@ -578,11 +560,10 @@ int main(int argc, char *argv[])
 	add_file(si, 1, 0, 0);
 	add_file(si, 8, 0, 0);
 	add_file(si, 9, 0, 0);
-	add_file(si, NILFS_IFILE_INO, count_ifile_blocks(blocksize), 0);
-	add_file(si, NILFS_CPFILE_INO, count_cpfile_blocks(blocksize), 0);
-	add_file(si, NILFS_SUFILE_INO, count_sufile_blocks(blocksize), 0);
-	add_file(si, NILFS_DAT_INO,
-		 count_dat_blocks(blocksize, si->nvblocknrs), 1);
+	add_file(si, NILFS_IFILE_INO, count_ifile_blocks(), 0);
+	add_file(si, NILFS_CPFILE_INO, count_cpfile_blocks(), 0);
+	add_file(si, NILFS_SUFILE_INO, count_sufile_blocks(), 0);
+	add_file(si, NILFS_DAT_INO, count_dat_blocks(si->nvblocknrs), 1);
 
 	fix_disk_layout(di);
 
@@ -590,7 +571,7 @@ int main(int argc, char *argv[])
 	init_disk_buffer(di->nblocks_to_write);
 	read_disk_header(fd, device);
 
-	prepare_super_block(di, opts);
+	prepare_super_block(di);
 	init_nilfs(di);
 
 	prepare_segment(&di->seginfo[0]);
@@ -602,7 +583,7 @@ int main(int argc, char *argv[])
 
 	commit_super_block(di, get_last_segment());
 
-	write_disk(fd, di, opts); /* Writing to the device */
+	write_disk(fd, di); /* Writing to the device */
 
 	close(fd);
 	exit(0);
@@ -611,7 +592,7 @@ int main(int argc, char *argv[])
 /*
  * I/O routines & primitives
  */
-static void disk_scan(const char *device, struct mkfs_options *opts)
+static void disk_scan(const char *device)
 {
 	struct stat statbuf;
 	pid_t pid;
@@ -622,7 +603,7 @@ static void disk_scan(const char *device, struct mkfs_options *opts)
 		return;
 	}
 
-	if (!opts->quiet)
+	if (!quiet)
 		pinfo("checking blocks");
 
 	pid = fork();
@@ -638,15 +619,14 @@ static void disk_scan(const char *device, struct mkfs_options *opts)
 			perr("Error: failed to drop setuid privileges");
 		args[i++] = badblocks;
 		args[i++] = "-b";
-		n = snprintf(bszbuf, BLOCKSIZE_BUFFER_SIZE, "%ld",
-			     opts->blocksize);
+		n = snprintf(bszbuf, BLOCKSIZE_BUFFER_SIZE, "%ld", blocksize);
 		if (n < 0 || n >= BLOCKSIZE_BUFFER_SIZE)
 			perr("Internal error: blocksize buffer overflow");
 		args[i++] = bszbuf;
 
-		if (!opts->quiet)
+		if (!quiet)
 			args[i++] = "-s";
-		if (opts->cflag > 1)
+		if (cflag > 1)
 			args[i++] = "-w";
 		args[i++] = device;
 		args[i] = NULL;
@@ -796,20 +776,19 @@ static int erase_disk(int fd, struct nilfs_disk_info *di)
 	return ret;
 }
 
-static void write_disk(int fd, struct nilfs_disk_info *di,
-		       struct mkfs_options *opts)
+static void write_disk(int fd, struct nilfs_disk_info *di)
 {
 	blocknr_t blocknr;
 	struct nilfs_segment_info *si;
 	int i;
 
-	if (!opts->quiet) {
+	if (!quiet) {
 		show_version();
 		pinfo("Start writing file system initial data to the device"
 		      _MI_ "Blocksize:%d  Device:%s  Device Size:%llu",
 		      blocksize, di->device, di->dev_size);
 	}
-	if (!opts->nflag) {
+	if (!nflag) {
 		if (erase_disk(fd, di) < 0)
 			goto failed_to_write;
 
@@ -840,7 +819,7 @@ static void write_disk(int fd, struct nilfs_disk_info *di,
 		if (fsync(fd) < 0)
 			goto failed_to_write;
 	}
-	if (!opts->quiet)
+	if (!quiet)
 		pinfo("File system initialization succeeded !! ");
 	return;
 
@@ -880,7 +859,7 @@ check_reserved_segments_percentage(long r_segments_percentage)
 		     r_segments_percentage);
 }
 
-static inline void check_ctime(long ctime)
+static inline void check_ctime(time_t ctime)
 {
 	if ((long)time(NULL) - (long)ctime < 0) {
 		char cbuf[26], *cbufp;
@@ -893,41 +872,40 @@ static inline void check_ctime(long ctime)
 	}
 }
 
-static void parse_options(int argc, char *argv[], struct mkfs_options *opts)
+static void parse_options(int argc, char *argv[])
 {
 	int c, show_version_only = 0;
 
 	while ((c = getopt(argc, argv, "b:B:cL:m:nqVP:")) != EOF) {
 		switch (c) {
 		case 'b':
-			opts->blocksize = atol(optarg);
-			check_blocksize(opts->blocksize);
+			blocksize = atol(optarg);
+			check_blocksize(blocksize);
 			break;
 		case 'B':
-			opts->blocks_per_segment = atol(optarg);
+			blocks_per_segment = atol(optarg);
 			break;
 		case 'c':
-			opts->cflag++;
+			cflag++;
 			break;
 		case 'L':
-			strncpy(opts->volume_label, optarg,
-				sizeof(opts->volume_label));
+			strncpy(volume_label, optarg, sizeof(volume_label));
 			break;
 		case 'm':
-			opts->r_segments_percentage = atol(optarg);
+			r_segments_percentage = atol(optarg);
 			break;
 		case 'n':
-			opts->nflag++;
+			nflag = 1;
 			break;
 		case 'q':
-			opts->quiet++;
+			quiet = 1;
 			break;
 		case 'V':
-			show_version_only++;
+			show_version_only = 1;
 			break;
 		case 'P': /* Passive mode */
-			opts->ctime = atol(optarg);
-			check_ctime(opts->ctime);
+			creation_time = atol(optarg);
+			check_ctime(creation_time);
 			break;
 		default:
 			usage();
@@ -941,8 +919,8 @@ static void parse_options(int argc, char *argv[], struct mkfs_options *opts)
 		exit(0);
 	}
 
-	check_blocks_per_segment(opts->blocks_per_segment);
-	check_reserved_segments_percentage(opts->r_segments_percentage);
+	check_blocks_per_segment(blocks_per_segment);
+	check_reserved_segments_percentage(r_segments_percentage);
 
         if (argc > 0) {
                 char *cp = strrchr(argv[0], '/');
@@ -1585,8 +1563,7 @@ static void commit_segment(void)
 	segref->free_blocks_count = count_free_blocks(di);
 }
 
-static void prepare_super_block(struct nilfs_disk_info *di,
-				struct mkfs_options *opts)
+static void prepare_super_block(struct nilfs_disk_info *di)
 {
 	blocknr_t blocknr = NILFS_SB_OFFSET_BYTES / blocksize;
 	unsigned long offset = NILFS_SB_OFFSET_BYTES % blocksize;
@@ -1610,8 +1587,7 @@ static void prepare_super_block(struct nilfs_disk_info *di,
 	raw_sb->s_dev_size = cpu_to_le64(di->dev_size);
 	raw_sb->s_first_data_block = cpu_to_le64(di->first_segment_block);
 	raw_sb->s_blocks_per_segment = cpu_to_le32(di->blocks_per_segment);
-	raw_sb->s_r_segments_percentage =
-		cpu_to_le32(opts->r_segments_percentage);
+	raw_sb->s_r_segments_percentage = cpu_to_le32(r_segments_percentage);
 
 	raw_sb->s_ctime = cpu_to_le64(di->ctime);
 	raw_sb->s_mtime = 0;
@@ -1633,8 +1609,7 @@ static void prepare_super_block(struct nilfs_disk_info *di,
 		cpu_to_le16(sizeof(struct nilfs_segment_usage));
 
 	uuid_generate(raw_sb->s_uuid);	/* set uuid using libuuid */
-	memcpy(raw_sb->s_volume_name, opts->volume_label,
-	       sizeof(opts->volume_label));
+	memcpy(raw_sb->s_volume_name, volume_label, sizeof(volume_label));
 }
 
 static void commit_super_block(struct nilfs_disk_info *di, 
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
