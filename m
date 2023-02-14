From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix underflow in second superblock position calculations
Date: Wed, 15 Feb 2023 07:40:43 +0900
Message-ID: <20230214224043.24141-1-konishi.ryusuke@gmail.com>
References: <0000000000004e1dfa05f4a48e6b@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNcWrT1s+JZEu6y/b+CDQSL4Nb1LRZZX+E7NMjsaQdI=;
        b=XA91pX0Mu1DyTojcc+VR7tUekbRGM60OwJTkpqB1pI2ryvb7R3EM80tYuGa5CC/vud
         tM9xJjamBeFKVUD+ELaq702LQ5s4bk4z5ogfRA/kljsMbXWE6rGaEBIhEMXmSZKMtRVI
         ZWx8/+Itpzz3Es/uzFUjUqL5lnLsowpeG3gFhf4ax5BlWk7kewgmWC6URUc1tgbvTLrV
         xuvxCd12wMn6uuGVfvzLDEhPM6neeh1682cjc4NWi+TxB8UdwZdcGibq2eKwoM669e1S
         sbumNqboIvqpodZQtL82Ts8a7JDfjZ/IXRdIpx4VewXArC4LsveWrLZXve0K7244ldQ0
         +iRg==
In-Reply-To: <0000000000004e1dfa05f4a48e6b-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+f0c4082ce5ebebdac63b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Macro NILFS_SB2_OFFSET_BYTES, which computes the position of the second
superblock, underflows when the argument device size is less than 4096
bytes.  Therefore, when using this macro, it is necessary to check in
advance that the device size is not less than a lower limit, or at least
that underflow does not occur.

The current nilfs2 implementation lacks this check, causing
out-of-bound block access when mounting devices smaller than 4096 bytes:

 I/O error, dev loop0, sector 36028797018963960 op 0x0:(READ) flags 0x0
 phys_seg 1 prio class 2
 NILFS (loop0): unable to read secondary superblock (blocksize = 1024)

In addition, when trying to resize the filesystem to a size below 4096
bytes, this underflow occurs in nilfs_resize_fs(), passing a huge number
of segments to nilfs_sufile_resize(), corrupting parameters such as the
number of segments in superblocks.  This causes excessive loop iterations
in nilfs_sufile_resize() during a subsequent resize ioctl, causing
semaphore ns_segctor_sem to block for a long time and hang the writer
thread:

 INFO: task segctord:5067 blocked for more than 143 seconds.
      Not tainted 6.2.0-rc8-syzkaller-00015-gf6feea56f66d #0
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:segctord        state:D stack:23456 pid:5067  ppid:2
 flags:0x00004000
 Call Trace:
  <TASK>
  context_switch kernel/sched/core.c:5293 [inline]
  __schedule+0x1409/0x43f0 kernel/sched/core.c:6606
  schedule+0xc3/0x190 kernel/sched/core.c:6682
  rwsem_down_write_slowpath+0xfcf/0x14a0 kernel/locking/rwsem.c:1190
  nilfs_transaction_lock+0x25c/0x4f0 fs/nilfs2/segment.c:357
  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2486 [inline]
  nilfs_segctor_thread+0x52f/0x1140 fs/nilfs2/segment.c:2570
  kthread+0x270/0x300 kernel/kthread.c:376
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
  </TASK>
 ...
 Call Trace:
  <TASK>
  folio_mark_accessed+0x51c/0xf00 mm/swap.c:515
  __nilfs_get_page_block fs/nilfs2/page.c:42 [inline]
  nilfs_grab_buffer+0x3d3/0x540 fs/nilfs2/page.c:61
  nilfs_mdt_submit_block+0xd7/0x8f0 fs/nilfs2/mdt.c:121
  nilfs_mdt_read_block+0xeb/0x430 fs/nilfs2/mdt.c:176
  nilfs_mdt_get_block+0x12d/0xbb0 fs/nilfs2/mdt.c:251
  nilfs_sufile_get_segment_usage_block fs/nilfs2/sufile.c:92 [inline]
  nilfs_sufile_truncate_range fs/nilfs2/sufile.c:679 [inline]
  nilfs_sufile_resize+0x7a3/0x12b0 fs/nilfs2/sufile.c:777
  nilfs_resize_fs+0x20c/0xed0 fs/nilfs2/super.c:422
  nilfs_ioctl_resize fs/nilfs2/ioctl.c:1033 [inline]
  nilfs_ioctl+0x137c/0x2440 fs/nilfs2/ioctl.c:1301
  ...

This fixes these issues by inserting appropriate minimum device size
checks or anti-underflow checks, depending on where the macro is used.

Link: https://lkml.kernel.org/r/0000000000004e1dfa05f4a48e6b-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+f0c4082ce5ebebdac63b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/ioctl.c     | 7 +++++++
 fs/nilfs2/super.c     | 9 +++++++++
 fs/nilfs2/the_nilfs.c | 8 +++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 87e1004b606d..b4041d0566a9 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1114,7 +1114,14 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 
 	minseg = range[0] + segbytes - 1;
 	do_div(minseg, segbytes);
+
+	if (range[1] < 4096)
+		goto out;
+
 	maxseg = NILFS_SB2_OFFSET_BYTES(range[1]);
+	if (maxseg < segbytes)
+		goto out;
+
 	do_div(maxseg, segbytes);
 	maxseg--;
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 6edb6e0dd61f..1422b8ba24ed 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -408,6 +408,15 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
 	if (newsize > devsize)
 		goto out;
 
+	/*
+	 * Prevent underflow in second superblock position calculation.
+	 * The exact minimum size check is done in nilfs_sufile_resize().
+	 */
+	if (newsize < 4096) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
 	/*
 	 * Write lock is required to protect some functions depending
 	 * on the number of segments, the number of reserved segments,
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 2064e6473d30..3a4c9c150cbf 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -544,9 +544,15 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 {
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
-	u64 sb2off = NILFS_SB2_OFFSET_BYTES(bdev_nr_bytes(nilfs->ns_bdev));
+	u64 sb2off, devsize = bdev_nr_bytes(nilfs->ns_bdev);
 	int valid[2], swp = 0;
 
+	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
+		nilfs_err(sb, "device size too small");
+		return -EINVAL;
+	}
+	sb2off = NILFS_SB2_OFFSET_BYTES(devsize);
+
 	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
 					&sbh[0]);
 	sbp[1] = nilfs_read_super_block(sb, sb2off, blocksize, &sbh[1]);
-- 
2.34.1

