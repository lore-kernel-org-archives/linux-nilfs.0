From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: correct logic of translation virtual blocks number
 into physical ones
Date: Mon, 01 Jul 2013 14:34:12 +0400
Message-ID: <1372674852.2198.23.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=5TfKTwS95hqPpvIMYbb1PLuOLpSa86pLr6icfw9mjQY=;
	b=c2Yjd7H7fSAqIeXQDs6x3EET+DQmX/G+f1aOoyFQcLQSQ2y6XPVR03g0PS/1wxrfGV5UFiazF/FeT1IKoGd/NdQzOYxuyMClKAeq2hFzzU5bYUBQ4gnRdElcvuyUwaDh;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hi,

The issue report is contained description of mount failure:

[  822.390075] NILFS version 2 loaded
[  822.436888] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  822.437107] NILFS: corrupt root inode.

The first phase of investigation discovered that it tries to read
really something wrong instead of root inode:

[ 4148.318860] NILFS HEXDUMP (fs/nilfs2/inode.c, 529): nilfs_read_inode_common:
[ 4148.318864] raw_inode: ffff880076b3c100: 2e 0a 09 20 20 41 54 41 50 49 20 69 73 20 61 20  ...  ATAPI is a
[ 4148.318866] raw_inode: ffff880076b3c110: 6e 65 77 65 72 20 70 72 6f 74 6f 63 6f 6c 20 75  newer protocol u
[ 4148.318869] raw_inode: ffff880076b3c120: 73 65 64 20 62 79 20 49 44 45 20 74 61 70 65 20  sed by IDE tape
[ 4148.318871] raw_inode: ffff880076b3c130: 61 6e 64 20 43 44 2d 52 4f 4d 20 64 72 69 76 65  and CD-ROM drive
[ 4148.318874] raw_inode: ffff880076b3c140: 73 2c 0a 09 20 20 73 69 6d 69 6c 61 72 20 74 6f  s,..  similar to
[ 4148.318876] raw_inode: ffff880076b3c150: 20 74 68 65 20 53 43 53 49 20 70 72 6f 74 6f 63   the SCSI protoc
[ 4148.318879] raw_inode: ffff880076b3c160: 6f 6c 2e 20 20 49 66 20 79 6f 75 20 68 61 76 65  ol.  If you have
[ 4148.318881] raw_inode: ffff880076b3c170: 20 61 6e 20 53 43 53 49 20 74 61 70 65 20 64 72   an SCSI tape dr

Thereby, it means that file system has some corruption that
results in reading of wrong block.

The second phase of investigation is discovered such things:

[  236.389166] NILFS DEBUG (fs/nilfs2/inode.c, 527): nilfs_read_inode_common:
[  236.389171] i_ino 6
[  236.389175] NILFS HEXDUMP (fs/nilfs2/inode.c, 529): nilfs_read_inode_common:
[  236.389180] raw_inode: ffff88007056b640: fb 60 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .`..............
[  236.389186] raw_inode: ffff88007056b650: a1 8f 2d 50 00 00 00 00 a1 8f 2d 50 00 00 00 00  ..-P......-P....
[  236.389190] raw_inode: ffff88007056b660: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  236.389195] raw_inode: ffff88007056b670: 00 80 01 00 00 00 00 00 01 03 01 00 00 00 00 00  ................
[  236.389199] raw_inode: ffff88007056b680: 00 00 00 00 00 00 00 00 ff 00 00 00 00 00 00 00  ................
[  236.389203] raw_inode: ffff88007056b690: fe 01 00 00 00 00 00 00 e7 f4 09 00 00 00 00 00  ................
[  236.389208] raw_inode: ffff88007056b6a0: 04 33 04 00 00 00 00 00 05 33 04 00 00 00 00 00  .3.......3......
[  236.389212] raw_inode: ffff88007056b6b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

Namely, block of ifile's btree of second level is located in 0x9f4e7 (#652519)
virtual block number.

[  945.415667] NILFS DEBUG (fs/nilfs2/mdt.c, 148): nilfs_mdt_submit_block:
[  945.415670] i_ino 6, blkoff 2, mode 0x0, out_bh ffff88007055dac8
[  945.415691] NILFS DEBUG (fs/nilfs2/bmap.c, 87): nilfs_bmap_lookup_at_level:
[  945.415694] i_ino 6, key 2, level 1

[  945.415734] NILFS DEBUG (fs/nilfs2/dat.c, 488): nilfs_dat_translate:
[  945.415737] i_ino 3, vblocknr 652519, blocknrp ffff88007055d870
[  945.415752] NILFS DEBUG (fs/nilfs2/mdt.c, 148): nilfs_mdt_submit_block:
[  945.415754] i_ino 3, blkoff 5118, mode 0x0, out_bh ffff88007055d638
[  945.417063] NILFS DEBUG (fs/nilfs2/dat.c, 516): nilfs_dat_translate:
[  945.417065] blocknr 405468

As a result, we have #405468 physical block number after translation.

segment: segnum = 197
  sequence number = 568325, next segnum = 198
partial segment: blocknr = 405460, nblocks = 44
    creation time = 2013-06-23 05:00:59
      ino = 6, cno = 373808, nblocks = 8, ndatblk = 6
        vblocknr = 692137, blocknr = 405467
        vblocknr = 652519, blocknr = 405468

The dumpseg output includes info about this [652519 : 405468] blocks pair.

The block #405468 contains information about virtual block on the next level.

dd if=/dev/loop0 bs=4096 skip=405468 | hexdump -vC

00000000  00 02 0d 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000010  00 00 00 00 00 00 00 00  ff 00 00 00 00 00 00 00  |................|

00000800  00 00 00 00 00 00 00 00  a9 8f 0a 00 00 00 00 00  |................|
00000810  80 43 08 00 00 00 00 00  e0 cf 07 00 00 00 00 00  |.C..............|

Virtual block number of next btree level is #a8fa9 (#692137).

[ 945.417138] NILFS DEBUG (fs/nilfs2/dat.c, 488): nilfs_dat_translate:
[  945.417141] i_ino 3, vblocknr 692137, blocknrp ffff88007055d870
[  945.417156] NILFS DEBUG (fs/nilfs2/mdt.c, 148): nilfs_mdt_submit_block:
[  945.417158] i_ino 3, blkoff 5430, mode 0x0, out_bh ffff88007055d638
[  945.418361] NILFS DEBUG (fs/nilfs2/dat.c, 516): nilfs_dat_translate:
[  945.418363] blocknr 405467

As a result, we have #405467 physical block number after translation.

segment: segnum = 197
  sequence number = 568325, next segnum = 198
   partial segment: blocknr = 405460, nblocks = 44
    creation time = 2013-06-23 05:00:59
      ino = 6, cno = 373808, nblocks = 8, ndatblk = 6
        vblocknr = 692137, blocknr = 405467
        vblocknr = 652519, blocknr = 405468

The dumpseg output includes info about this [692137 : 405467] blocks pair.

The block #405467 contains information about virtual block that
describes location of ifile block with blkoff = 2.

dd if=/dev/loop0 bs=4096 skip=405467 | hexdump -vC

00000000  00 01 ff 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000010  00 00 00 00 00 00 00 00  01 00 00 00 00 00 00 00  |................|
00000020  02 00 00 00 00 00 00 00  03 00 00 00 00 00 00 00  |................|

00000800  fe 00 00 00 00 00 00 00  6d 78 0b 00 00 00 00 00  |........mx......|
00000810  85 39 09 00 00 00 00 00  de 67 07 00 00 00 00 00  |.9.......g......|

The virtual block of ifile block with blkoff = 2 is 0x767de (#485342).
But dumpseg output for all segments on the partition doesn't contain
virtual block with such number. However, translation of virtual block
number into physical results with #51321 block number.

[  945.418420] NILFS DEBUG (fs/nilfs2/dat.c, 488): nilfs_dat_translate:
[  945.418423] i_ino 3, vblocknr 485342, blocknrp ffff88007055da30
[  945.418438] NILFS DEBUG (fs/nilfs2/mdt.c, 148): nilfs_mdt_submit_block:
[  945.418440] i_ino 3, blkoff 3807, mode 0x0, out_bh ffff88007055d808
[  945.418626] NILFS DEBUG (fs/nilfs2/bmap.c, 106): nilfs_bmap_lookup_at_level:
[  945.418629] ptr 353444
[  945.419557] NILFS DEBUG (fs/nilfs2/dat.c, 516): nilfs_dat_translate:
[  945.419559] blocknr 51321

Such result takes place because of calculated block (#353444) of DAT file
on blkoff 3807 contains:

dd if=/dev/loop0 bs=4096 skip=353444 | hexdump -vC

00000bc0  79 c8 00 00 00 00 00 00  95 b1 05 00 00 00 00 00  |y...............|
00000bd0  96 b1 05 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

But block 0xc879 (51321) was alive from checkpoint 0x5b195 (#373141)
till checkpoint 0x5b196 (#373142). So, it makes sense to add logic
of comparing current checkpoint number with start and end checkpoint
numbers. And, if current checkpoint is outside of checkpoints range
of requested block then operation of translation should fail with
error.

With the best regards,
Vyacheslav Dubeyko.
---
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: correct logic of translation virtual blocks number into physical ones

The issue report is contained description of mount failure:

[  822.390075] NILFS version 2 loaded
[  822.436888] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  822.437107] NILFS: corrupt root inode.

Investigation of the issue discovered that it takes places
reading of ifile's block from not proper placement because of
successful ending of operation of virtual block number translation
into physical one.

This patch adds checking of start checkpoint and end checkpoint by
comparing with current checkpoint number during translation of
virtual block number into physical block number. Because it makes
sense to operate with blocks that are alive for current checkpoint.

As a result, mount fails with such error message:

[17348.793335] NILFS warning (device loop0): nilfs_ifile_get_inode_block: unable to read inode: 2
[17348.793869] NILFS: get root inode failed

Reported-by: Bryce Gibson <bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dat.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index fa0f803..08d9268 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -396,9 +396,11 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
  */
 int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 {
+	struct the_nilfs *nilfs = dat->i_sb->s_fs_info;
 	struct buffer_head *entry_bh, *bh;
 	struct nilfs_dat_entry *entry;
 	sector_t blocknr;
+	__u64 cur_cno, start_cno, end_cno;
 	void *kaddr;
 	int ret;
 
@@ -422,6 +424,13 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 		ret = -ENOENT;
 		goto out;
 	}
+	cur_cno = nilfs->ns_cno;
+	start_cno = le64_to_cpu(entry->de_start);
+	end_cno = le64_to_cpu(entry->de_end);
+	if (cur_cno < start_cno || cur_cno > end_cno) {
+		ret = -ENOENT;
+		goto out;
+	}
 	*blocknrp = blocknr;
 
  out:
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
