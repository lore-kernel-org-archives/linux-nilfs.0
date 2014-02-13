From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 06/10] nilfs-utils: remove unnecessary parentheses from return statements
Date: Fri, 14 Feb 2014 03:24:06 +0900
Message-ID: <1392315850-29149-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392315850-29149-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392315850-29149-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch errors:

 ERROR: return is not a function, parentheses are not required
 #84: FILE: nilfs.c:84:
 +       return (c == '\n' || c == '\0');

 ERROR: return is not a function, parentheses are not required
 #50: FILE: mkfs/bitops.c:50:
 +       return (mask & *ADDR);

 ERROR: return is not a function, parentheses are not required
 #222: FILE: mkfs/mkfs.c:222:
 +       return (di->blocks_per_segment *

 ERROR: return is not a function, parentheses are not required
 #66: FILE: mount/mount_mntent.c:66:
 +       return (c == ' ' || c == '\t');

 ERROR: return is not a function, parentheses are not required
 #408: FILE: nilfs-resize/nilfs-resize.c:408:
 +       return (snp - segnumv); /* return the number of found segments */

 ERROR: return is not a function, parentheses are not required
 #479: FILE: nilfs-resize/nilfs-resize.c:479:
 +       return (snp - segnumv); /* return the number of found segments */

 ERROR: return is not a function, parentheses are not required
 #509: FILE: nilfs-resize/nilfs-resize.c:509:
 +       return (snp - segnumv); /* return the number of found segments */

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/nilfs.c                      |    2 +-
 sbin/mkfs/bitops.c               |    2 +-
 sbin/mkfs/mkfs.c                 |    4 ++--
 sbin/mount/fstab.c               |    2 +-
 sbin/mount/mount_mntent.c        |    2 +-
 sbin/nilfs-resize/nilfs-resize.c |    6 +++---
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/nilfs.c b/lib/nilfs.c
index 60b51b0..65bf7d5 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -81,7 +81,7 @@ extern __u32 crc32_le(__u32 seed, unsigned char const *data, size_t length);
 
 static inline int iseol(int c)
 {
-	return (c == '\n' || c == '\0');
+	return c == '\n' || c == '\0';
 }
 
 static size_t tokenize(char *line, char **tokens, size_t ntoks)
diff --git a/sbin/mkfs/bitops.c b/sbin/mkfs/bitops.c
index d7efece..6262884 100644
--- a/sbin/mkfs/bitops.c
+++ b/sbin/mkfs/bitops.c
@@ -47,7 +47,7 @@ int ext2fs_test_bit(int nr, const void *addr)
 
 	ADDR += nr >> 3;
 	mask = 1 << (nr & 0x07);
-	return (mask & *ADDR);
+	return mask & *ADDR;
 }
 
 #endif	/* !_EXT2_HAVE_ASM_BITOPS_ */
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 9f03c07..d17dabe 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -219,8 +219,8 @@ static void init_disk_layout(struct nilfs_disk_info *di, int fd,
 
 static inline blocknr_t count_free_blocks(struct nilfs_disk_info *di)
 {
-	return (di->blocks_per_segment *
-		(di->nsegments - di->nsegments_to_write));
+	return di->blocks_per_segment *
+		(di->nsegments - di->nsegments_to_write);
 }
 
 static inline blocknr_t
diff --git a/sbin/mount/fstab.c b/sbin/mount/fstab.c
index e8d88c0..b9feb7c 100644
--- a/sbin/mount/fstab.c
+++ b/sbin/mount/fstab.c
@@ -290,7 +290,7 @@ is_mounted_once(const char *name) {
 		if (streq(mc->m.mnt_dir, name) ||
 		    streq(mc->m.mnt_fsname, name))
 			ct++;
-	return (ct == 1);
+	return ct == 1;
 }
 
 /* Given the name FILE, try to find the option "loop=FILE" in mtab.  */
diff --git a/sbin/mount/mount_mntent.c b/sbin/mount/mount_mntent.c
index ad05183..ea44d0c 100644
--- a/sbin/mount/mount_mntent.c
+++ b/sbin/mount/mount_mntent.c
@@ -63,7 +63,7 @@ next:
 
 static int
 is_space_or_tab (char c) {
-	return (c == ' ' || c == '\t');
+	return c == ' ' || c == '\t';
 }
 
 static char *
diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
index be89f8c..c7ed910 100644
--- a/sbin/nilfs-resize/nilfs-resize.c
+++ b/sbin/nilfs-resize/nilfs-resize.c
@@ -405,7 +405,7 @@ nilfs_resize_find_movable_segments(struct nilfs *nilfs, __u64 start,
 			rest--;
 		}
 	}
-	return (snp - segnumv); /* return the number of found segments */
+	return snp - segnumv; /* return the number of found segments */
 }
 
 #if 0
@@ -476,7 +476,7 @@ nilfs_resize_find_active_segments(struct nilfs *nilfs, __u64 start, __u64 end,
 			}
 		}
 	}
-	return (snp - segnumv); /* return the number of found segments */
+	return snp - segnumv; /* return the number of found segments */
 }
 
 static ssize_t
@@ -506,7 +506,7 @@ nilfs_resize_find_inuse_segments(struct nilfs *nilfs, __u64 start, __u64 end,
 			}
 		}
 	}
-	return (snp - segnumv); /* return the number of found segments */
+	return snp - segnumv; /* return the number of found segments */
 }
 
 static ssize_t
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
